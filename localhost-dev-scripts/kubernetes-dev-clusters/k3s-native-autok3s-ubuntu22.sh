#!/bin/bash

################################################################################################
# Created by Fedir Indutnyi                                                                    #
# Note: This script is not working as expected. It is just a draft.                            #
################################################################################################

# Define environment variables
export KUBE_EXPLORER_VERSION="v0.4.0"
export HELM_DASHBOARD_VERSION="1.3.3"
# Define environment variables
export LINUX_USERNAME=$USER
export LINUX_PASSWORD="ubuntu"
export NODE_NAME="localhost"
export LOCALHOST_IP="127.0.0.1"

echo "======== Check Environment Variables =================="
env
cd ~

# Install autok3s
curl -sS https://rancher-mirror.rancher.cn/autok3s/install.sh | sudo sh

# Start autok3s daemon
sudo autok3s --help
# This is not needed as autok3s will be started 
# autok3s -d serve --bind-address=0.0.0.0

# Configure shell
sudo mkdir -p /home/shell
echo '. /etc/profile.d/bash_completion.sh' | sudo tee -a /home/shell/.bashrc > /dev/null
echo 'alias k="kubectl"' | sudo tee -a /home/shell/.bashrc > /dev/null
echo 'source <(kubectl completion bash)' | sudo tee -a /home/shell/.bashrc > /dev/null
# echo 'PS1="> "' >> /home/shell/.bashrc

# Install kube-explorer
sudo curl -sSL https://github.com/cnrancher/kube-explorer/releases/download/${KUBE_EXPLORER_VERSION}/kube-explorer-${OS}-${ARCH} > /usr/local/bin/kube-explorer && \
sudo chmod +x /usr/local/bin/kube-explorer

# Install helm-dashboard
sudo curl -sLf https://github.com/komodorio/helm-dashboard/releases/download/v${HELM_DASHBOARD_VERSION}/helm-dashboard_${HELM_DASHBOARD_VERSION}_Linux_x86_64.tar.gz | sudo tar xvzf - -C /usr/local/bin && \
sudo chmod +x /usr/local/bin/helm-dashboard

# Set environment variables
export AUTOK3S_CONFIG=/root/.autok3s
export DOCKER_HOST=unix:///var/run/docker.sock
export HOME=/root
export AUTOK3S_HELM_DASHBOARD_ADDRESS=0.0.0.0

# Change working directory
cd /home/shell

# Link autok3s to kubectl
sudo ln -sf autok3s /usr/local/bin/kubectl

# run autok3s
echo "n\n" | sudo autok3s
sudo autok3s --help


echo "======== Creating Cluster "devluster" =================="
# since it asks for telemetry we need to send n
echo 'n\n' | sudo autok3s  create --provider  native --docker-script  https://get.docker.com --k3s-channel  stable --k3s-install-script  https://get.k3s.io --master-extra-args  '--disable coredns,local-storage,servicelb,traefik,metrics-server' --name  devluster --rollback --ssh-password  $LINUX_PASSWORD --ssh-port  22 --ssh-user  $USER --master-ips  '127.0.0.1'

echo "======== Cluster created Successfully =================="

sudo autok3s kubectl config use-context devluster


echo "======== Trying to get cluster =================="
sudo autok3s kubectl get node -o wide
echo "======== Waiting for the node to boot ...  =================="
until sudo autok3s kubectl wait --for condition=ready --timeout=600s node $NODE_NAME; do \
  sleep 1; \
done
sudo autok3s kubectl get node -o wide
sudo autok3s kubectl get pods -A

echo "======== Cluster booted Successfully =================="
echo "For web autok3 panel run: sudo autok3s serve "



Steps to Set Up and Start the Service
Create the Service File:

Create and edit the file with the correct path:

sh
Copy code
sudo nano /etc/systemd/system/autok3s.service
Paste the contents with the correct ExecStart path:

ini
Copy code
[Unit]
Description=AutoK3s Service
After=network.target

[Service]
User=ubuntu
ExecStart=/usr/local/bin/autok3s serve
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
Save and exit the editor (e.g., Ctrl+O, Enter, Ctrl+X in nano).

Reload Systemd to Recognize the New Service:

sh
Copy code
sudo systemctl daemon-reload
Enable and Start the Service:

Enable the service to start on boot:

sh
Copy code
sudo systemctl enable autok3s
Start the service immediately:

sh
Copy code
sudo systemctl start autok3s
Check the Status of the Service:

You can check the status of the autok3s service to ensure it’s running correctly:

sh
Copy code
sudo systemctl status autok3s
Check Logs:

If there are issues, you can check the logs for more details:

sh
Copy code
sudo journalctl -u autok3s
By following these steps, you can ensure that the autok3s service is set up to start automatically on boot and is using the correct executable path.



ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
autok3s   create --provider  native --docker-script  https://get.docker.com --k3s-channel  stable --k3s-install-script  https://get.k3s.io --name  localhost --rollback --ssh-key-path  ~/.ssh/id_rsa --ssh-port  22 --ssh-user  ubuntu --master-ips  127.0.0.1
# autok3s delete --provider native --name localhost
# autok3s serve