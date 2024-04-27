#!/bin/bash -xe
echo "Squid Proxy Installing...."
sudo apt update && sudo apt upgrade -y
sudo apt install squid -y


# Allow all to connect to Squid Http proxy server
echo "Configuring Squid ...."
sudo sed -i "s/http_access deny all .*/http_access allow all" /etc/squid/squid.conf


# Restart Squid Service 
echo "Restarting Squid Proxy Installing...."
sudo systemctl restart squid

sudo ufw allow 3128/tcp
sudo ufw reload