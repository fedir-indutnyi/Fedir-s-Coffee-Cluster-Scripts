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
# sudo apt install openssh-server
# sudo service ssh start
# sudo service ssh status
# sudo apt install nano
# sudo apt install curl
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
export K3SLOCALDEVPREREQUISITESINSTALLED=true
echo "======== Prerequisites were installed successfully! =================="





# # Install autok3s
# curl -sS https://rancher-mirror.rancher.cn/autok3s/install.sh | sh

# # Start autok3s daemon
# autok3s --help
# # This is not needed as autok3s will be started 
# # autok3s -d serve --bind-address=0.0.0.0







# # Configure shell
# mkdir -p /home/shell
# # echo '. /etc/profile.d/bash_completion.sh' >> /home/shell/.bashrc 
# # echo 'alias k="kubectl"' >> /home/shell/.bashrc && \
# # echo 'source <(kubectl completion bash)' >> /home/shell/.bashrc && \
# # echo 'PS1="> "' >> /home/shell/.bashrc

# # Install kube-explorer
# curl -sSL https://github.com/cnrancher/kube-explorer/releases/download/${KUBE_EXPLORER_VERSION}/kube-explorer-${OS}-${ARCH} > /usr/local/bin/kube-explorer && \
# chmod +x /usr/local/bin/kube-explorer

# # Install helm-dashboard
# curl -sLf https://github.com/komodorio/helm-dashboard/releases/download/v${HELM_DASHBOARD_VERSION}/helm-dashboard_${HELM_DASHBOARD_VERSION}_Linux_x86_64.tar.gz | tar xvzf - -C /usr/local/bin && \
# chmod +x /usr/local/bin/helm-dashboard

# # Set environment variables
# export AUTOK3S_CONFIG=/root/.autok3s
# export DOCKER_HOST=unix:///var/run/docker.sock
# export HOME=/root
# export AUTOK3S_HELM_DASHBOARD_ADDRESS=0.0.0.0

# # Change working directory
# # cd /home/shell

# # Link autok3s to kubectl
# ln -sf autok3s /usr/local/bin/kubectl

# # run autok3s
# echo "n" | autok3s
# autok3s --help


# autok3s -d  create --provider  k3d --master  1 --name  naaadoker --worker  0 --k3s-install-script  https://get.k3s.io --api-port  0.0.0.0:0 --image  docker.io/rancher/k3s:v1.28.5-k3s1 --no-image-volume --no-lb
# autok3s -d create -p k3d --name myk3s --master 1
# autok3s   create --provider  native --docker-script  https://get.docker.com --k3s-channel  stable --k3s-install-mirror  INSTALL_K3S_MIRROR=cn --k3s-install-script  https://rancher-mirror.rancher.cn/k3s/k3s-install.sh --master-extra-args  '--disable coredns,local-storage,servicelb,metrics-server,traefik' --rollback --ssh-port  22 --ssh-user  osboxes --master-ips  127.0.0.1
# autok3s   create --provider  native --master 1 --name mytempk3s --docker-script  https://get.docker.com --k3s-channel  stable --k3s-install-mirror  INSTALL_K3S_MIRROR=cn --k3s-install-script  https://rancher-mirror.rancher.cn/k3s/k3s-install.sh --master-extra-args  '--disable coredns,local-storage,servicelb,metrics-server,traefik' 

# autok3s -d create \
#     --provider native \
#     --name myk3stemp1 \
#     --ssh-user osboxes \
#     --ssh-port 22 \
#     --ssh-password osboxes.org \
#     --ssh-key-path /home/osboxes/.ssh/id_rsa \
#     --master-ips 127.0.0.1

# # Without this it will block passwords in terminal
# sudo visudo
# osboxes ALL=(ALL) NOPASSWD:ALL

# autok3s -d create --provider native  --name myk3stemp1 --ssh-user osboxes  --ssh-port 22  --ssh-password osboxes.org --ssh-key-path /home/osboxes/.ssh/id_rsa  --master-ips 127.0.0.1
# echo "osboxes.org" | sudo -S autok3s -d create --provider native  --name myk3stemp1 --ssh-user osboxes  --ssh-port 22  --ssh-password osboxes.org --ssh-key-path /home/osboxes/.ssh/id_rsa  --master-ips 127.0.0.1


# seems successfull
# autok3s   create --provider  native --docker-script  https://get.docker.com --k3s-channel  stable --k3s-install-script  https://get.k3s.io --master-extra-args  '--disable coredns,local-storage,servicelb,traefik,metrics-server' --name  twertwer --rollback --set  {} --ssh-password  osboxes.org --ssh-port  22 --ssh-user  osboxes --master-ips  127.0.0.1


# # Install kubectl
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# # Install helm
# curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# # Install skaffold
# curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
# chmod +x skaffold
# sudo mv skaffold /usr/local/bin

# # Install kustomize
# curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
# sudo mv kustomize /usr/local/bin

# # Install stern
# wget https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64
# chmod +x stern_linux_amd64
# sudo mv stern_linux_amd64 /usr/local/bin/stern

# # Install k9s
# wget https://github.com/derailed/k9s/releases/download/v0.24.15/k9s_Linux_x86_64.tar.gz
# tar -xzvf k9s_Linux_x86_64.tar.gz
# chmod +x k9s
# sudo mv k9s /usr/local/bin

# # Install kube-ps1
# git clone https://github.com/jonmosco/kube-ps1.git
# echo 'source ~/kube-ps1/kube-ps1.sh' >> ~/.bashrc

# # Install kubectx and kubens
# git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
# COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
# ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
# ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
# echo 'source ~/.kubectx/kubectx.sh' >> ~/.bashrc
# echo 'source ~/.kubectx/kubens.sh' >> ~/.bashrc

# # Install kubeval
# wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz
# tar xf kubeval-linux-amd64.tar.gz
# chmod +x kubeval
# sudo mv kubeval /usr/local/bin

# # Install kube-score
# wget https://github.com/zegl/kube-score/releases/latest/download/kube-score-linux-amd64.tar.gz
# tar xf kube-score-linux-amd64.tar.gz
# chmod +x kube-score
# sudo mv kube-score /usr/local/bin

# # Install kube-shell
# pip install kube-shell

# # Install krew
# set -x; cd "$(mktemp -d)" &&
# curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
# tar zxvf krew.tar.gz &&
# KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
# "$KREW" install krew
# echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.bashrc

# # Install kubeseal
# wget https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/kubeseal-linux-amd64
# chmod +x kubeseal-linux-amd64
# sudo mv kubeseal-linux-amd64 /usr/local/bin/kubeseal

# # Install kube-prompt
# wget https://github.com/c-bata/kube-prompt/releases/latest/download/kube-prompt_linux_amd64.zip
# unzip kube-prompt_linux_amd64.zip
# chmod +x kube-prompt
# sudo mv kube-prompt /usr/local/bin

# # Install kube-resource-report
# wget https://github.com/hjacobs/kube-resource-report/releases/latest/download/kube-resource-report-linux-amd64.tar.gz
# tar xf kube-resource-report-linux-amd64.tar.gz
# chmod +x kube-resource-report
# sudo mv kube-resource-report /usr/local/bin

# # Install kube-state-metrics
# kubectl apply -f https://github.com/kubernetes/kube-state-metrics/raw/master/examples/standard/cluster-role.yaml
# kubectl apply -f https://github.com/kubernetes/kube-state-metrics/raw/master/examples/standard/cluster-role-binding.yaml
# kubectl apply -f https://github.com/kubernetes/kube-state-metrics/raw/master/examples/standard/deployment.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# # Install kube-ops-view
# kubectl apply -f https://raw.githubusercontent.com/hjacobs/kube-ops-view/master/deploy/kube-ops-view.yaml

# # Install kube-capacity
# kubectl apply -f https://github.com/robscott/kube-capacity/raw/master/kube-capacity.yaml

# echo "Prerequisites installed successfully!"
