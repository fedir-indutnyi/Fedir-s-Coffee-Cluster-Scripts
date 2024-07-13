
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

echo "Check k3s proxy settings"
sudo cat /etc/systemd/system/k3s.service.env
sudo cat /etc/systemd/system/k3s-agent.service.env