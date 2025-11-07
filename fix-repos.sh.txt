#!/bin/bash

sed -i 's|mirror.centos.org|vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*
sed -i 's|^#baseurldnf clean a=http|baseurl=http|g' /etc/yum.repos.d/CentOS-*

dnf clean all
dnf makecache
