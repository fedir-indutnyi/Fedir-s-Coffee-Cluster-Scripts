#!/bin/bash

# Install k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

# Create k3d cluster
k3d cluster create mycluster

# Install autok3s
curl -sSL https://get.autok3s.io | sh

# Configure autok3s
autok3s init

# Add k3d cluster to autok3s
autok3s add k3d mycluster

# Start the cluster
autok3s start mycluster
