This Taskfile script - is a simplified version of ansible - allows to turn any virtual machine into a full working Localhost Kubernetes Cluster.
Steps to enable:
1. Having a Virtual Machine (WSL, Qemu, Linode, AWS, Bare Metal, etc).
2. Install Taskfile application, using following commands:
``` sh
echo 'Install Brew - to be able to install Task'
cd ~
sudo apt update
sudo apt upgrade
sudo apt-get install build-essential
sudo apt install mc
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/$USER/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew doctor
echo 'Install Taskfile utility: (similar like ansible)'
brew install go-task
task --version
```


for every restart :
sudo chmod +rwx /etc/rancher/k3s/k3s.yaml


3. Install prerequisites:

``` sh
task k3s-install-prerequisites
```

4. To install K3s Cluster - Run from this repository:

``` sh
task k3s-install-localhost-cluster-and-run
```
5. To install ArgoCD - Run from this repository:

``` sh
task k3s-install-argocd
```

6. To install Dashboard - Run from this repository:

``` sh
task k3s-install-dashboard
kubectl -n kubernetes-dashboard create token admin-user
```

6. To delete cluster:

``` sh
task k3s-delete-cluster
```


To access dashboard:
https://127.0.0.1:31191
For Generating token:
kubectl -n kubernetes-dashboard create token admin-user

To access ArgoCD:
username: admin
password:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
https://127.0.0.1:30604


For Loading external docker images to cluster use:

Save from Docker Registry to file:
docker save --output <filename>.tar imagetosave:latest

to Docker Internal Registry:
docker load < image_latest.tar
to k3s cluster:
first copy (for example using mc commander) file to ~
sudo k3s ctr images import <imagename>.tar
sudo k3s ctr images ls




Creating a tunnel (example of most used ports):
``` sh
ssh -L 31191:127.0.0.1:31191 -L 30604:127.0.0.1:30604   -L 8001:127.0.0.1:8001  -L 27017:127.0.0.1:27017  -L 8081:127.0.0.1:8080  -L 6443:127.0.0.1:6443 -L 8443:192.168.67.2:8443 osboxes@127.0.0.1 -p10022 


 ssh -L 34200:127.0.0.1:34200 -L 33000:127.0.0.1:33000 -L 41060:127.0.0.1:41060 -L 41061:127.0.0.1:41061 -L 41062:127.0.0.1:41062 -L 41063:127.0.0.1:41063 -L 8334:127.0.0.1:8334 -L 3306:127.0.0.1:3306 -L 22:127.0.0.1:22 -L 80:127.0.0.1:80 -L 31191:127.0.0.1:31191 -L 30604:127.0.0.1:30604  -L 8001:127.0.0.1:8001 -L 27017:127.0.0.1:27017 -L 8081:127.0.0.1:8080 -L 6443:127.0.0.1:6443 -L 3000:127.0.0.1:3000 -L 4200:127.0.0.1:4200 -L 8443:127.0.0.1:8443 -L 30036:127.0.0.1:30036 -L 32237:127.0.0.1:32237     osboxes@127.0.0.1 -p10022
```