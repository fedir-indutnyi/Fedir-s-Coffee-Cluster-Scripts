#!/bin/bash


echo "======== Starting to install Localhost Development K3s Prerequisites =================="
# Define environment variables
export KUBE_EXPLORER_VERSION="v0.4.0"
export HELM_DASHBOARD_VERSION="1.3.3"
# Define environment variables
export LINUX_USERNAME=$USER
export NODE_NAME="localhost"
export LOCALHOST_IP="127.0.0.1"

echo "======== Check Environment Variables =================="
env

cd ~
echo "======== Updating OS (if needed) =================="
# sudo apt update
# Install required packages
export LINUX_USERNAME=$LINUX_USERNAME
echo "======== Installing required packages and SSH Server on port 22 =================="
sudo apt-get update && \
sudo apt-get install -y curl ca-certificates tar gzip nano iptables ip6tables && \
sudo rm -rf /var/lib/apt/lists/*
# Install SSH Server
sudo apt-get update && \
sudo apt-get install -y openssh-client openssh-server && \
sudo dpkg-reconfigure openssh-server

# Start SSH service
sudo service ssh start && sleep 5 && service ssh status


echo "======== Allow no password behavior =================="
echo "$LINUX_USERNAME ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
export IP=$LOCALHOST_IP
export KUBE_EDITOR="nano"

echo "======== Generating local keys & certificate =================="
sudo chmod 700 ~/.ssh
export LINUX_USERNAME=$LINUX_USERNAME
# improved with removal of existing keys:
echo 'yes\n'  | sudo -u $LINUX_USERNAME sh -c 'rm -f ~/.ssh/id_rsa; ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa' <<<''
echo -e 'yes\n' | ssh-copy-id $LINUX_USERNAME@$LOCALHOST_IP
echo "======== Listing Keys =================="
ls -l ~/.ssh/id*

echo "======== Install helm (please wait) =================="
sudo snap install helm --classic

echo "======== Prerequisites were installed successfully! =================="



