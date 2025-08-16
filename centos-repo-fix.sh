#!/bin/bash
# Script to update CentOS 8 from vault repos and install xeyes

echo "=== Switching repos to vault.centos.org ==="
sed -i 's|mirror.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*
sed -i 's|^#baseurl=http|baseurl=http|g' /etc/yum.repos.d/CentOS-*

echo "=== Enabling AppStream repo ==="
dnf config-manager --set-enabled AppStream

echo "=== Cleaning DNF cache ==="
dnf clean all

echo "=== Updating system from vault ==="
dnf -y update

echo "=== Installing xeyes (xorg-x11-apps) ==="
dnf -y install xorg-x11-apps

echo "=== Done! You can now run 'xeyes' ==="