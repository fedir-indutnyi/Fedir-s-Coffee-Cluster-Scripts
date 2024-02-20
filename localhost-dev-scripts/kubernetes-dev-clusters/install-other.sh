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
