!#/bin/bash

# 1) Add the Webmin repo
sudo tee /etc/yum.repos.d/webmin.repo >/dev/null <<'EOF'
[Webmin]
name=Webmin Distribution Neutral
baseurl=https://download.webmin.com/download/yum
enabled=1
gpgcheck=1
gpgkey=https://download.webmin.com/jcameron-key.asc
EOF

# 2) Import the GPG key and refresh metadata
sudo rpm --import https://download.webmin.com/jcameron-key.asc
sudo dnf makecache

# 3) Install Webmin
sudo dnf install -y webmin

# 4) Start and enable the service
sudo systemctl enable --now webmin

# 5) (If using firewalld) open the management port
sudo firewall-cmd --add-port=10000/tcp --permanent
sudo firewall-cmd --reload