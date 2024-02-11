#!/bin/bash

# Install k3sup
curl -sLS https://get.k3sup.dev | sh

# Add k3sup to PATH
export PATH=$PATH:$HOME/.k3sup/bin

# Verify installation
k3sup version
