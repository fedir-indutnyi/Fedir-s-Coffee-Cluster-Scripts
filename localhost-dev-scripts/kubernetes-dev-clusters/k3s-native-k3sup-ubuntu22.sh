#!/bin/bash

echo "======== Starting to install Localhost Development K3s Prerequisites =================="
# Define environment variables
export LINUX_USERNAME=$USER
export NODE_NAME="localhost"
export LOCALHOST_IP="127.0.0.1"

echo "======== Check Environment Variables =================="
env




        cd ~
        echo "======== Starting k3s installation .. =================="
        export LOCALHOST_IP=$LOCALHOST_IP
        export SERVER_IP=$LOCALHOST_IP
        export LINUX_USERNAME=$LINUX_USERNAME
        export KUBE_EDITOR="nano"
        [ -e kubeconfig ] && rm kubeconfig
        
        echo "======== Downloading k3sup script =================="
        curl -sLS --insecure https://get.k3sup.dev |  K3S_KUBECONFIG_MODE="644" sh -s - --write-kubeconfig-mode 644

        echo "======== Checking if k3sup script downloaded successfully =================="
        chmod +x k3sup
        cp ./k3sup ~/k3sup
        chmod +x ~/k3sup

# Add k3sup to PATH
export PATH=$PATH:$HOME/.k3sup/bin

~/k3sup --help
echo "======== K3Sup installed and ready =================="

        echo "======== Installing k3s without LB & Traefik =================="
        # bash -c '~/k3sup install --ip $LOCALHOST_IP --user $LINUX_USERNAME --local --no-extras'
        echo "======== Installing k3s without Traefik =================="
        bash -c '~/k3sup install --ip $LOCALHOST_IP --user $LINUX_USERNAME --local --no-extras'
        sudo chmod +rwx /etc/rancher/k3s/k3s.yaml
        echo "======== Installation of k3s finished =================="
        
        export KUBECONFIG=/home/$LINUX_USERNAME/kubeconfig
        echo "... make kubeconfig path permanent and kubeditor=nano"
        echo 'KUBECONFIG="/home/{{.LINUX_USERNAME}}/kubeconfig"' | sudo tee -a /etc/environment
        export KUBE_EDITOR="nano"
        echo 'KUBE_EDITOR="nano"' | sudo tee -a /etc/environment
        echo "... listing updated environment variables: "
        sudo cat /etc/environment
        export KUBECONFIG=/home/$LINUX_USERNAME/kubeconfig
        kubectl config use-context default
        # restart k3s:
        echo "======== Restarting Cluster =================="
        /usr/local/bin/k3s-killall.sh
        sudo chmod +rwx /etc/rancher/k3s/k3s.yaml
        sudo systemctl start k3s
        sudo chmod +rwx /etc/rancher/k3s/k3s.yaml
        echo "======== Trying to get cluster =================="
        kubectl get node -o wide
        echo "======== Waiting for the node to boot ...  =================="
        until kubectl wait --for condition=ready --timeout=600s node $NODE_NAME; do \
          sleep 1; \
        done
        kubectl get node -o wide
        kubectl get pods -A
        
        # echo "========Setting final options to prevent permission denied ...  =================="
        # #this option is useless :(
        # sudo chmod +rwx /etc/rancher/k3s/k3s.yaml
        # export KUBECONFIG=/home/$LINUX_USERNAME/kubeconfig
        # kubectl config use-context default
        # sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
        # sudo chown -R $USER:$USER /home/$USER

        echo "======== K3s version =================="
        k3s --v

        echo "======== Installing k9s Completed =================="      

        echo "======== Cluster Successfully installed =================="
        echo "======== For WSL Reboot is needed for Kubectl and variables to take effect =================="
        echo "to access wsl under windows use : wsl hostname -I "


# Verify installation
k3sup version
