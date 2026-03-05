Fedir's Coffee Cluster Scripts


Prepare environment - these cations are not mandatory, but can be helpful:
``` sh
cd ~
sudo apt update
echo sudo apt upgrade
sudo apt install curl
sudo apt install nano
sudo apt install mc
echo 'Install git:'
sudo apt install git -y
```




``` sh

# Install Prerequisites
chmod +x install-prerequisites-ubuntu22.sh && sh ./install-prerequisites-ubuntu22.sh
# cp install-prerequisites-ubuntu22.sh /tmp/install-prerequisites-ubuntu22.sh && \
# chmod +x /tmp/install-prerequisites-ubuntu22.sh && \
# /bin/bash -c "/tmp/install-prerequisites-ubuntu22.sh"

# Install AutoK3s Native-Baremetal (doesnt work - dont use it as it is not ready - debugging needed)
cp k3s-native-autok3s-ubuntu22.sh /tmp/k3s-native-autok3s-ubuntu22.sh && \
chmod +x /tmp/k3s-native-autok3s-ubuntu22.sh && \
/bin/bash -c "/tmp/k3s-native-autok3s-ubuntu22.sh"

# Install K3Sup Native-Baremetal
chmod +x k3s-native-k3sup.sh && sh ./k3s-native-k3sup.sh
chmod +x install-k9s.sh && sh ./install-k9s.sh
sudo snap install helm --classic

# Install K3Sup Native-Baremetal
cp k3s-native-k3sup-ubuntu22.sh /tmp/k3s-native-k3sup-ubuntu22.sh && \
chmod +x /tmp/k3s-native-k3sup-ubuntu22.sh && \
/bin/bash -c "/tmp/k3s-native-k3sup-ubuntu22.sh"

to install in lxc:
# curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --flannel-backend=host-gw" sh -

Step 1 — Clean Install (If Current Broken)
k3s-uninstall.sh
rm -rf /var/lib/rancher/k3s
rm -rf /etc/rancher/k3s

Step 2 — Install k3s With Traefik + host-gw Networking
curl -sfL https://get.k3s.io | sh -s - \
  --node-name splatform-poznan-dev.k8s \
  --node-ip 10.10.10.6 \
  --flannel-backend=host-gw \
  --write-kubeconfig-mode 644


Explanation:

Traefik remains enabled (default)

servicelb disabled (you use tunnels/ingress)

host-gw networking (LXC-friendly)

ingress available




# Setup kubectl for non-root user access
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc
mkdir ~/.kube 2> /dev/null
sudo k3s kubectl config view --raw > "$KUBECONFIG"
chmod 600 "$KUBECONFIG"
# Test to make sure non-root kubectl is working
kubectl get nodes


# Install ArgoCD 
   helm repo add argo https://argoproj.github.io/argo-helm
   helm repo update
   kubectl create namespace argocd
   helm install argocd argo/argo-cd   --namespace argocd


to expose nodeport for argo

helm upgrade argocd argo/argo-cd \
  -n argocd \
  --reuse-values \
  --set server.service.type=NodePort \
  --set server.service.nodePort=30080 \
  --set configs.params."server\.insecure"=true

``` 