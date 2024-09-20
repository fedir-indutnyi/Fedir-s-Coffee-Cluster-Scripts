#!/bin/bash
# !!!! Need to be run as "sh k3s-native-k3sup.sh" !!!!
echo "!!! Important - make sure ending of this file is LF !!!"

echo "Update os"
sudo apt update

echo "======== Starting to install Localhost Development K3s Prerequisites =================="
# Define environment variables
export NODE_NAME="localhost"
export LOCALHOST_IP="127.0.0.1"

echo "======== Check Environment Variables =================="
env

cd ~
echo "======== Starting k3s installation .. =================="
export KUBE_EDITOR="nano"

# Add k3sup to PATH
export PATH=$PATH:$HOME/.k3sup/bin

echo "======== Installing k3s =================="

K3SUP_PATH="./k3sup"  # Specify the path where you want to check for the k3sup file
# Check if k3sup already exists
if [ -f "$K3SUP_PATH" ]; then
    echo "Using existing k3sup binary."
    K3SUP_CMD="$K3SUP_PATH"
else
    echo "Downloading k3sup..."
    curl -sLS --insecure https://get.k3sup.dev -o k3sup
    chmod +x k3sup
    K3SUP_CMD="./k3sup"
fi
# Execute k3sup with the desired options
K3S_KUBECONFIG_MODE="644" $K3SUP_CMD --write-kubeconfig-mode 644

sudo cp k3sup /usr/local/bin/k3sup
k3sup --help
echo "======== Running install command =================="
# k3sup install --local --ip $LOCALHOST_IP --user $USER --k3s-extra-args '--no-deploy traefik'
k3sup install --local --ip $LOCALHOST_IP --user $USER 
# this line is important, it allows changing context
sudo chmod +rwx /etc/rancher/k3s/k3s.yaml
echo "======== Installation of k3s finished =================="

echo "======== Setting default kubeconfig =================="
export KUBECONFIG=~/kubeconfig
# this line doesnt work as this cannot accept ~ for system wide variable .
# echo "KUBECONFIG=~/kubeconfig" | sudo tee -a /etc/environment
# this line works locally during startup
echo 'export KUBECONFIG=~/kubeconfig' >> ~/.bash_profile

export KUBE_EDITOR="nano"
echo 'KUBE_EDITOR="nano"' | sudo tee -a /etc/environment
echo "... listing updated environment variables: "
sudo cat /etc/environment
sudo cat ~/.bashrc
kubectl config use-context default
kubectl get node -o wide

echo "======== Restarting Cluster =================="
/usr/local/bin/k3s-killall.sh
sudo systemctl start k3s
sudo chmod +rwx /etc/rancher/k3s/k3s.yaml

# echo "======== Set variables =================="
export KUBECONFIG=~/kubeconfig
sudo cp /etc/rancher/k3s/k3s.yaml ~/kubeconfig
sudo chmod +rwx ~/kubeconfig
kubectl config use-context default
# sudo chmod +rwx /etc/rancher/k3s/k3s.yaml
kubectl get node -o wide
# adding default context to user sturtup, possibly not needed if k3s sometimes does it automatically
echo 'kubectl config use-context default' >> ~/.bash_profile


echo "======== Waiting for the node to boot ...  =================="
until kubectl wait --for condition=ready --timeout=600s node $NODE_NAME; do \
  sleep 1; \
done
kubectl get node -o wide
kubectl get pods -A

echo "======== K3s version =================="
k3s --v

echo "======== Cluster Successfully installed =================="
echo "======== For WSL Reboot is needed for Kubectl and variables to take effect =================="
echo "to access wsl under windows use : wsl hostname -I "

# Verify installation
k3sup version
