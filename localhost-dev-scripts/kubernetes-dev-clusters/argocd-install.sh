#!/bin/bash


echo "======== Starting to install ArgoCD using Kubectl =================="

# Define environment variables
export LINUX_USERNAME=$USER
export NODE_NAME="localhost"
export LOCALHOST_IP="127.0.0.1"

echo "======== Check Environment Variables =================="
env
   
        echo "======== Installing ArgoCD =================="
        kubectl get namespace | grep -q "argocd" || kubectl create namespace argocd
        # rm -rf argocd-installation
        [ -d 'argocd-installation' ] ||  mkdir 'argocd-installation'
        [ -d 'argocd-installation/crds' ] ||  mkdir 'argocd-installation/crds'
        echo "... downloading argocd installation files 1/5"
        # curl -fsSL --insecure 'https://github.com/argoproj/argo-cd/manifests/crds\?ref\=stable' './argocd-installation'
        echo "... downloading argocd installation files 1/5"
        [ -f 'argocd-installation/crds/application-crd.yaml' ] || curl -sLS --insecure 'https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/application-crd.yaml' --output './argocd-installation/crds/application-crd.yaml'
        echo "... downloading argocd installation files 2/5"
        [ -f 'argocd-installation/crds/applicationset-crd.yaml' ] || curl -sLS --insecure 'https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/applicationset-crd.yaml' --output './argocd-installation/crds/applicationset-crd.yaml'
        echo "... downloading argocd installation files 3/5"
        [ -f 'argocd-installation/crds/appproject-crd.yaml' ] || curl -sLS --insecure 'https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/appproject-crd.yaml' --output './argocd-installation/crds/appproject-crd.yaml'
        echo "... downloading argocd installation files 4/5"
        [ -f 'argocd-installation/crds/kustomization.yaml' ] || curl -sLS --insecure 'https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/crds/kustomization.yaml' --output './argocd-installation/crds/kustomization.yaml'
        echo "... downloading argocd installation files 5/5"
        # kubectl apply -n argocd -f 'https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml'
        [ -f 'argocd-installation/install.yaml' ] || curl -sLS --insecure 'https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml' --output './argocd-installation/install.yaml'
        echo "... installation files downloaded"
        echo "... Applying downloaded files to cluster"
        kubectl apply -n argocd -k './argocd-installation/crds'
        kubectl apply -n argocd -f './argocd-installation/install.yaml'
        kubectl get all -n argocd
        sleep 60; 
        echo "... waiting for all pods go online: "
        until kubectl wait --for condition=available --timeout=600s --all deployments -n argocd; do \
          sleep 120; \
          kubectl apply -n argocd -k './argocd-installation/crds'
          kubectl apply -n argocd -f './argocd-installation/install.yaml'
          kubectl get all -n argocd
          echo "... waiting for all pods go online: "
        done        
        kubectl get svc -n argocd
        kubectl patch service/argocd-server -n argocd --patch '{"spec": {"type": "NodePort", "ports": [{"name": "http", "port": 80, "nodePort": 30604, "targetPort": 8080}]}}'
        echo "... ArgoCD setup completed. Its available at: https://127.0.0.1:30604"
        echo "... admin user and password: "
        echo "admin"
        kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo 
        export ARGO_ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
        echo 'ArgoCD app: https://127.0.0.1:30604' | tee -a ./argocd_credentials.txt 
        echo 'username: admin' | tee -a ./argocd_credentials.txt
        echo 'password: '$ARGO_ADMIN_PASSWORD | tee -a ./argocd_credentials.txt

        echo "======== Installing ArgoCD Completed =================="
