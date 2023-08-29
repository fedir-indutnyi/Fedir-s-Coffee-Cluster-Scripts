This Taskfile script - is a simplified version of ansible - allows to turn any virtual machine into a full working Localhost Kubernetes Cluster.
Steps to enable:
1. Having a Virtual Machine (WSL, Qemu, Linode, AWS, Bare Metal, etc).
2. Install Taskfile application, using following commands:
``` sh
echo 'Install Brew - to be able to install Task'
cd ~
sudo apt update
sudo apt-get install build-essential
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/$USER/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew doctor
echo 'Install Taskfile utility: (similar like ansible)'
brew install go-task
task --version
```
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
