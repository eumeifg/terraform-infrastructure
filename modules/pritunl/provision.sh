#!/bin/bash -xe
# exec > >(tee /var/log/pritunl-install-data.log|logger -t user-data -s 2>/dev/console) 2>&1yes
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/aws/bin:/root/bin
echo "Pritunl Installing"

sudo tee /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=https://repo.pritunl.com/stable/yum/oraclelinux/8/
gpgcheck=0
enabled=1
EOF

echo "* hard nofile 64000" >> /etc/security/limits.conf
echo "* soft nofile 64000" >> /etc/security/limits.conf
echo "root hard nofile 64000" >> /etc/security/limits.conf
echo "root soft nofile 64000" >> /etc/security/limits.conf

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

sudo dnf -y install oracle-epel-release-el8
sudo yum-config-manager --enable ol8_developer_EPEL

sudo dnf -y update
sudo dnf -y install dnf-automatic
sudo sed -i 's/^upgrade_type =.*/upgrade_type = default/g' /etc/dnf/automatic.conf
sudo sed -i 's/^download_updates =.*/download_updates = yes/g' /etc/dnf/automatic.conf
sudo sed -i 's/^apply_updates =.*/apply_updates = yes/g' /etc/dnf/automatic.conf
sudo systemctl enable --now dnf-automatic.timer

# WireGuard server support
sudo dnf -y install wireguard-tools

sudo dnf -y remove iptables-services
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service

# Import signing key from keyserver
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
# Alternative import from download if keyserver offline
sudo rpm --import https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc

# Install updated openvpn package from pritunl
sudo dnf -y --allowerasing install pritunl-openvpn

sudo dnf -y install pritunl
sudo systemctl enable pritunl
sudo systemctl start pritunl
