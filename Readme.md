Fedir's Coffee Cluster Scripts


!!!!!!!!!!!! Dont forget line endings LF

``` sh

# Install K3Sup Native-Baremetal
chmod +x k3s-native-k3sup.sh && sh ./k3s-native-k3sup.sh
chmod +x install-k9s.sh && sh ./install-k9s.sh
sudo snap install helm --classic

# Install Prerequisites (not needed for baremetal)
chmod +x install-prerequisites-ubuntu22.sh && sh ./install-prerequisites-ubuntu22.sh

# Install AutoK3s Native-Baremetal (doesnt work - dont use it as it is not ready - debugging needed)
cp k3s-native-autok3s-ubuntu22.sh /tmp/k3s-native-autok3s-ubuntu22.sh && \
chmod +x /tmp/k3s-native-autok3s-ubuntu22.sh && \
/bin/bash -c "/tmp/k3s-native-autok3s-ubuntu22.sh"

# If kubectl doesnt work after reboot, then use:
KUBECONFIG=/home/$USER/kubeconfig

# Install ArgoCD 
chmod +x argocd-install.sh && sh ./argocd-install.sh

``` 