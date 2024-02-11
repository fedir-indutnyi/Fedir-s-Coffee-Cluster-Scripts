Fedir's Coffee Cluster Scripts


Prepare environment - these cations are not mandatory, but can be helpful:
``` sh
cd ~
sudo apt update
echo sudo apt upgrade
sudo apt install curl
sudo apt install nano
echo 'Install Brew - to be able to install Task'
sudo apt-get install build-essential
sudo apt install mc
echo 'Install git:'
sudo apt install git -y
```


Creating a tunnel (example of most used ports):
``` sh
ssh -L 31191:127.0.0.1:31191 -L 30604:127.0.0.1:30604   -L 8001:127.0.0.1:8001  -L 27017:127.0.0.1:27017  -L 8081:127.0.0.1:8080  -L 6443:127.0.0.1:6443 -L 8443:192.168.67.2:8443 osboxes@127.0.0.1 -p10022 


 ssh -L 34200:127.0.0.1:34200 -L 33000:127.0.0.1:33000 -L 41060:127.0.0.1:41060 -L 41061:127.0.0.1:41061 -L 41062:127.0.0.1:41062 -L 41063:127.0.0.1:41063 -L 8334:127.0.0.1:8334 -L 3306:127.0.0.1:3306 -L 22:127.0.0.1:22 -L 80:127.0.0.1:80 -L 31191:127.0.0.1:31191 -L 30604:127.0.0.1:30604  -L 8001:127.0.0.1:8001 -L 27017:127.0.0.1:27017 -L 8081:127.0.0.1:8080 -L 6443:127.0.0.1:6443 -L 3000:127.0.0.1:3000 -L 4200:127.0.0.1:4200 -L 8443:127.0.0.1:8443 -L 30036:127.0.0.1:30036 -L 32237:127.0.0.1:32237     osboxes@127.0.0.1 -p10022
```



Fedir's Coffee Cluster Scripts:
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
cp k3s-native-k3sup-ubuntu22.sh /tmp/k3s-native-k3sup-ubuntu22.sh && \
chmod +x /tmp/k3s-native-k3sup-ubuntu22.sh && \
/bin/bash -c "/tmp/k3s-native-k3sup-ubuntu22.sh"

# Every time after reboot:
KUBECONFIG=/home/$USER/kubeconfig

# Install ArgoCD 
chmod +x argocd-install.sh && sh ./argocd-install.sh

``` 