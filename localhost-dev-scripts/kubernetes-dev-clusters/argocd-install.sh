#!/bin/bash


echo "======== Starting to install ArgoCD using Kubectl =================="

# Define environment variables
export NODE_NAME="localhost"
export LOCALHOST_IP="127.0.0.1"

echo "======== Check Environment Variables =================="
env
   
        echo "======== Installing ArgoCD =================="

      snap install helm --classic
      helm repo add argo https://argoproj.github.io/argo-helm
      helm repo update
      kubectl get namespace | grep -q "argocd" || kubectl create namespace argocd

      helm upgrade --install --debug  --atomic --timeout 600s argocd argo/argo-cd \
      --set server.service.type="NodePort" \
      --set server.service.nodePortHttp=30604 \
      --set configs.params."server\.insecure"="true" \
      --namespace argocd

        kubectl get all -n argocd
        sleep 60; 
        echo "... waiting for all pods go online: "
        until kubectl wait --for condition=available --timeout=600s --all deployments -n argocd; do \
          sleep 120; \
          kubectl get all -n argocd
          echo "... waiting for all pods go online: "
        done        
        kubectl get svc -n argocd
        # kubectl patch service/argocd-server -n argocd --patch '{"spec": {"type": "NodePort", "ports": [{"name": "http", "port": 80, "nodePort": 30604, "targetPort": 8080}]}}'
        echo "... ArgoCD setup completed. Its available at: https://127.0.0.1:30604"
        echo "... admin user and password: "
        echo "admin"
        kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo 
        export ARGO_ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
        echo 'ArgoCD app: https://127.0.0.1:30604' | tee -a ./argocd_credentials.txt 
        echo 'username: admin' | tee -a ./argocd_credentials.txt
        echo 'password: '$ARGO_ADMIN_PASSWORD | tee -a ./argocd_credentials.txt

        echo "======== Installing ArgoCD Completed =================="
