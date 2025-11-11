#!/usr/bin/env bash
#
# convert-to-rocky.sh
# Purpose: help transition older CentOS 8 classroom VMs to Rocky Linux 8
# and/or fix missing repos (PowerTools/CRB) for GUI/X11 tools.
#
# Run as: sudo bash convert-to-rocky.sh
#

set -e

echo "=== CentOS 8 → Rocky 8 helper ==="
echo "This will try to:"
echo "  1) Make sure dnf is usable"
echo "  2) Enable PowerTools/CRB (the thing that fixed xorg-x11-apps/Xfce)"
echo "  3) (Optional) run migrate2rocky to fully convert to Rocky 8"
echo

# 1. Make sure we have dnf config manager
if ! command -v dnf &>/dev/null; then
  echo "ERROR: dnf not found. Are you sure this is CentOS/RHEL-like?"
  exit 1
fi

#echo "→ Ensuring 'dnf-plugins-core' is installed..."
#dnf install -y dnf-plugins-core

# 2. Enable the extra repo (this was the key step in your note)
# Some images use 'powertools', some use 'crb'
echo "→ Trying to enable 'powertools' repo..."
if dnf config-manager --set-enabled powertools 2>/dev/null; then
  echo "✓ Enabled powertools"
else
  echo "→ 'powertools' not found, trying 'crb'..."
  if dnf config-manager --set-enabled crb 2>/dev/null; then
    echo "✓ Enabled crb"
  else
    echo "WARN: Could not enable powertools or crb automatically."
    echo "      You may need to enable it manually in /etc/yum.repos.d/"
  fi
fi

echo
echo "→ Repo fix step complete."
echo "At this point, packages like xorg-x11-apps should be installable again."
echo

# 3. Ask to do the full Rocky conversion
read -p "Do you want to download and run the Rocky Linux migrate2rocky script now? [y/N]: " RUN_MIGRATE

if [[ "$RUN_MIGRATE" =~ ^[Yy]$ ]]; then
  echo "→ Downloading migrate2rocky.sh from Rocky Linux..."
  curl -O https://raw.githubusercontent.com/rocky-linux/rocky-tools/main/migrate2rocky/migrate2rocky.sh

  echo
  echo "NOTE IMPORTANT (matches your earlier fix):"
  echo "If this VM chokes on a pre-dnf-update step inside the script,"
  echo "you can open migrate2rocky.sh and comment out the line that does the"
  echo "preliminary 'dnf update' before the real migration."
  echo

  chmod +x migrate2rocky.sh

  echo "→ Running migrate2rocky.sh -r ..."
  # This is the actual conversion step
  sudo bash ./migrate2rocky.sh -r

  echo
  echo "✓ Migration script completed. A reboot is usually recommended:"
  echo "  sudo reboot"
else
  echo "Skipping full Rocky migration. Repo fix remains in place."
fi

echo
echo "=== Done. ==="
echo "If this was for the Linux course lab VMs, keep this script with your instructor prep files."
