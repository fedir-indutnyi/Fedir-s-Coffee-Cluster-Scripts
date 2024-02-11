#!/bin/bash

# Install autok3s
curl -sfL https://get.autok3s.io | sh

# Create a native k3s cluster using autok3s
autok3s create --provider=<provider> --name=<cluster-name> --region=<region> --node=<node-count>
