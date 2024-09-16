#!/bin/bash
# !!!! Need to be run as "sh k3s-native-k3sup.sh" !!!!
echo "!!! Important - make sure ending of this file is LF !!!"
echo "======== Starting to install Localhost Development K3s Prerequisites =================="
# Define environment variables
export NODE_NAME="localhost"
export LOCALHOST_IP="127.0.0.1"

echo "======== Check Environment Variables =================="
env




        cd ~
        echo "======== Starting k3s installation .. =================="
        export LOCALHOST_IP=$LOCALHOST_IP
        export SERVER_IP=$LOCALHOST_IP
        export KUBE_EDITOR="nano"



        # [ -e kubeconfig ] && rm kubeconfig
        
        # echo "======== Downloading k3sup script =================="
        # # curl -sLS https://get.k3sup.dev | sh
        # curl -sLS --insecure https://get.k3sup.dev |  K3S_KUBECONFIG_MODE="644" sh -s - --write-kubeconfig-mode 644

        # echo "======== Checking if k3sup script downloaded successfully =================="
        # chmod +x k3sup
        # cp ./k3sup ~/k3sup
        # chmod +x ~/k3sup

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
        k3sup install --local --ip $LOCALHOST_IP --user $USER --k3s-extra-args '--no-deploy traefik'

                
        # # sudo install k3sup /usr/local/bin/
        # bash -c '~/k3sup install --ip $LOCALHOST_IP --user $USER --local'
        
        sudo chmod +rwx /etc/rancher/k3s/k3s.yaml
        echo "======== Installation of k3s finished =================="
        
        export KUBECONFIG=/home/$USER/kubeconfig
        echo "KUBECONFIG=\"/home/$USER/kubeconfig\"" | sudo tee -a /etc/environment
        export KUBE_EDITOR="nano"
        echo 'KUBE_EDITOR="nano"' | sudo tee -a /etc/environment
        echo "... listing updated environment variables: "
        sudo cat /etc/environment
        export KUBECONFIG=/home/$USER/kubeconfig
        kubectl config use-context default
        kubectl get node -o wide
        
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
        # export KUBECONFIG=/home/$USER/kubeconfig
        # kubectl config use-context default
        # sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
        # sudo chown -R $USER:$USER /home/$USER

        echo "======== K3s version =================="
        k3s --v

        echo "======== Cluster Successfully installed =================="
        echo "======== For WSL Reboot is needed for Kubectl and variables to take effect =================="
        echo "to access wsl under windows use : wsl hostname -I "


# Verify installation
k3sup version
