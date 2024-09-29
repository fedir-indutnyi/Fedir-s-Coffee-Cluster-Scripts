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

# Install ArgoCD 
chmod +x argocd-install.sh && sh ./argocd-install.sh

``` 