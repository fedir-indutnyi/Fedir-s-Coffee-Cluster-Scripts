#!/bin/bash

# Proxy settings
proxy_host="10.0.2.2"
proxy_port="3128"

# Username and password for proxy (if required)
proxy_username=""
proxy_password=""

# Backup the existing proxy settings
sudo cp /etc/environment /etc/environment.bak

# Configure the proxy settings
# echo "http_proxy=http://$proxy_host:$proxy_port/" | sudo tee -a /etc/environment
# echo "https_proxy=http://$proxy_host:$proxy_port/" | sudo tee -a /etc/environment

echo 'Setup permanent Proxy (if needed):'
sudo cat /etc/environment
sudo bash -c 'grep -q FTP_PROXY /etc/environment || echo 'FTP_PROXY="http://$proxy_host:$proxy_port/"' >> /etc/environment'
sudo bash -c 'grep -q HTTPS_PROXY /etc/environment || echo 'HTTPS_PROXY="http://$proxy_host:$proxy_port/"' >> /etc/environment'
sudo bash -c 'grep -q HTTP_PROXY /etc/environment || echo 'HTTP_PROXY="http://$proxy_host:$proxy_port/"' >> /etc/environment'
sudo bash -c 'grep -q NO_PROXY /etc/environment || echo 'NO_PROXY="http://$proxy_host:$proxy_port/"' >> /etc/environment'
sudo bash -c 'grep -q ftp_proxy /etc/environment || echo 'ftp_proxy="http://$proxy_host:$proxy_port/"' >> /etc/environment'
sudo bash -c 'grep -q http_proxy /etc/environment || echo 'http_proxy="http://$proxy_host:$proxy_port/"' >> /etc/environment'
sudo bash -c 'grep -q https_proxy /etc/environment || echo 'https_proxy="http://$proxy_host:$proxy_port/"' >> /etc/environment'
sudo bash -c 'grep -q no_proxy /etc/environment || echo 'no_proxy="localhost,127.0.0.0/8,::1"' >> /etc/environment'
sudo cat /etc/environment
sudo cat /etc/systemd/system.conf
sudo bash -c 'sed -i -e 's/#DefaultEnvironment=//g' /etc/systemd/system.conf'
export DefaultEnvironment='"FTP_PROXY=http://$proxy_host:$proxy_port/" "HTTPS_PROXY=http://$proxy_host:$proxy_port/" "HTTP_PROXY=http://$proxy_host:$proxy_port/" "NO_PROXY=localhost,127.0.0.0/8,::1" "ftp_proxy=http://10.0.2.2:3128/" "http_proxy=http://10.0.2.2:3128/" "https_proxy=http://10.0.2.2:3128/" "no_proxy=localhost,127.0.0.0/8,::1"'
echo "DefaultEnvironment=$DefaultEnvironment" | sudo tee -a /etc/systemd/system.conf
sudo cat /etc/systemd/system.conf

echo "Check k3s proxy settings"
sudo cat /etc/systemd/system/k3s.service.env
sudo cat /etc/systemd/system/k3s-agent.service.env

sudo bash -c 'grep -q FTP_PROXY /etc/systemd/system/k3s.service.env || echo 'FTP_PROXY="http://$proxy_host:$proxy_port/"' >> /etc/systemd/system/k3s.service.env'
sudo bash -c 'grep -q HTTPS_PROXY /etc/systemd/system/k3s.service.env || echo 'HTTPS_PROXY="http://$proxy_host:$proxy_port/"' >> /etc/systemd/system/k3s.service.env'
sudo bash -c 'grep -q HTTP_PROXY /etc/systemd/system/k3s.service.env || echo 'HTTP_PROXY="http://$proxy_host:$proxy_port/"' >> /etc/systemd/system/k3s.service.env'
sudo bash -c 'grep -q NO_PROXY /etc/systemd/system/k3s.service.env || echo 'NO_PROXY="http://$proxy_host:$proxy_port/"' >> /etc/systemd/system/k3s.service.env'

sudo cat /etc/systemd/system/k3s.service.env



if [ -n "$proxy_username" ] && [ -n "$proxy_password" ]; then
    echo "proxy_username=$proxy_username" | sudo tee -a /etc/environment
    echo "proxy_password=$proxy_password" | sudo tee -a /etc/environment
fi

# Apply the changes
source /etc/environment

echo "Proxy settings configured successfully."
