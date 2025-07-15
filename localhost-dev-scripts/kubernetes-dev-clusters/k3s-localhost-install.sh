#!/bin/bash
# run with bash k3s-localhost-install.sh

set -euo pipefail

# !!!! Need to be run as a normal user, not root, unless you know what you're doing !!!!
################################################################################################
# Created by Fedir Indutnyi                                                                    #
# Note: This script installs and configures k3s.                                               #
################################################################################################

echo "!!! Important - make sure ending of this file is LF !!!"

echo "Update OS (recommended before install)"
echo "You may want to run: sudo apt update && sudo apt upgrade -y"

echo "======== Starting to install Localhost Development K3s Prerequisites =================="

# --- Detect OS and set package manager/firewall ---
if grep -qi 'ubuntu' /etc/os-release; then
  OS_TYPE="ubuntu"
  PKG_UPDATE="sudo apt update"
  PKG_INSTALL="sudo apt install -y"
  FIREWALL_DISABLE="sudo ufw disable"
  FIREWALL_PERM_DISABLE="sudo systemctl disable ufw"
elif grep -qi 'almalinux' /etc/os-release || grep -qi 'centos' /etc/os-release || grep -qi 'rhel' /etc/os-release; then
  OS_TYPE="rhel"
  PKG_UPDATE="sudo dnf makecache || sudo yum makecache"
  PKG_INSTALL="sudo dnf install -y || sudo yum install -y"
  FIREWALL_DISABLE="sudo systemctl stop firewalld"
  FIREWALL_PERM_DISABLE="sudo systemctl disable firewalld"
else
  echo "[WARN] This script is designed for Ubuntu and AlmaLinux/RHEL. Continue? (y/N)"
  read -r ans
  [[ $ans =~ ^[Yy]$ ]] || exit 1
  OS_TYPE="unknown"
fi

# --- Detect user and host ---
USER_NAME="$(whoami)"
HOST_NAME="$(hostname)"
HOME_DIR="$(eval echo ~$USER_NAME)"

# --- Update and install dependencies ---
echo "[INFO] Updating package cache..."
eval "$PKG_UPDATE"

for dep in curl sudo tar; do
  if ! command -v $dep >/dev/null; then
    echo "[INFO] Installing missing dependency: $dep"
    eval "$PKG_INSTALL $dep"
  fi
done

# --- Prompt for firewall ---
echo "[INFO] Firewall may block k3s traffic on localhost."
if [ "$OS_TYPE" = "ubuntu" ]; then
  echo "Do you want to disable ufw now? (recommended for local dev) [y/N]"
  read -r DISABLE_FW
  if [[ $DISABLE_FW =~ ^[Yy]$ ]]; then
    eval "$FIREWALL_DISABLE" || true
    echo "[INFO] ufw disabled."
    echo "Do you want to disable the firewall permanently (across reboots)? [y/N]"
    read -r DISABLE_FW_PERM
    if [[ $DISABLE_FW_PERM =~ ^[Yy]$ ]]; then
      eval "$FIREWALL_PERM_DISABLE"
      echo "[INFO] ufw will not start on boot (permanently disabled)."
    else
      echo "[WARN] ufw is only disabled for this session. It may re-enable after reboot."
    fi
  else
    echo "[INFO] Skipping firewall change."
  fi
elif [ "$OS_TYPE" = "rhel" ]; then
  echo "Do you want to disable firewalld now? (recommended for local dev) [y/N]"
  read -r DISABLE_FW
  if [[ $DISABLE_FW =~ ^[Yy]$ ]]; then
    eval "$FIREWALL_DISABLE" || true
    echo "[INFO] firewalld disabled."
    echo "Do you want to disable the firewall permanently (across reboots)? [y/N]"
    read -r DISABLE_FW_PERM
    if [[ $DISABLE_FW_PERM =~ ^[Yy]$ ]]; then
      eval "$FIREWALL_PERM_DISABLE"
      echo "[INFO] firewalld will not start on boot (permanently disabled)."
    else
      echo "[WARN] firewalld is only disabled for this session. It may re-enable after reboot."
    fi
  else
    echo "[INFO] Skipping firewall change."
  fi
else
  echo "[INFO] Skipping firewall change (unknown OS)."
fi

# --- Prompt for Traefik ---
echo "[INFO] By default, k3s installs Traefik ingress."
echo "Do you want to install Traefik? [y/N]"
read -r INSTALL_TRAEFIK
if [[ $INSTALL_TRAEFIK =~ ^[Yy]$ ]]; then
  K3S_EXTRA_ARGS=""
else
  K3S_EXTRA_ARGS="--k3s-extra-args=--disable=traefik"
fi

# --- Check dependencies ---
echo "======== Check Environment Variables =================="
env
for dep in curl sudo; do
  if ! command -v $dep >/dev/null; then
    echo "[ERROR] Required dependency '$dep' not found. Please install it and rerun."; exit 1
  fi
done

# --- Download k3sup if needed ---
echo "======== Installing k3s =================="
K3SUP_BIN="$HOME_DIR/.k3sup/bin/k3sup"
if ! command -v k3sup >/dev/null; then
  echo "[INFO] Downloading k3sup..."
  curl -sLS --insecure https://get.k3sup.dev | sh
fi

# Find k3sup location
if command -v k3sup >/dev/null; then
  K3SUP_BIN="$(command -v k3sup)"
else
  echo "[ERROR] k3sup installation failed."
  exit 1
fi

echo "[INFO] Using k3sup at $K3SUP_BIN"

# --- Install k3s with k3sup ---
echo "======== Running install command =================="
export K3S_KUBECONFIG_MODE="644"
echo "[INFO] Installing k3s on localhost (127.0.0.1) as $USER_NAME..."
$K3SUP_BIN install --local --ip 127.0.0.1 --user "$USER_NAME" $K3S_EXTRA_ARGS

# --- Check for k3s.yaml ---
if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
  echo "[ERROR] k3s did not install correctly. /etc/rancher/k3s/k3s.yaml not found."
  exit 1
fi

echo "======== Installation of k3s finished =================="

# --- Set up kubeconfig ---
echo "======== Setting default kubeconfig =================="
KUBECONFIG_PATH="$HOME_DIR/.kube/config"
mkdir -p "$HOME_DIR/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$KUBECONFIG_PATH"
sudo chown "$USER_NAME":"$USER_NAME" "$KUBECONFIG_PATH"
sudo chmod 600 "$KUBECONFIG_PATH"

# --- Set environment variable ---
if ! grep -q 'export KUBECONFIG=' "$HOME_DIR/.bashrc"; then
  echo "export KUBECONFIG=\"$HOME_DIR/.kube/config\"" >> "$HOME_DIR/.bashrc"
fi
export KUBECONFIG="$HOME_DIR/.kube/config"

echo "... listing updated environment variables: "
sudo cat /etc/environment || true
sudo cat "$HOME_DIR/.bashrc" || true

kubectl config use-context default
kubectl get node -o wide

echo "======== Restarting Cluster =================="
/usr/local/bin/k3s-killall.sh || true
sudo systemctl start k3s || true
sudo chmod +rwx /etc/rancher/k3s/k3s.yaml || true

# --- Test cluster ---
echo "======== Waiting for the node to boot ...  =================="
echo "[INFO] Waiting for node to register with the cluster..."
for i in {1..60}; do
  NODE_NAME="$(kubectl get node -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
  if [ -n "$NODE_NAME" ]; then
    break
  fi
  sleep 2
done

if [ -z "$NODE_NAME" ]; then
  echo "[ERROR] No node registered with the cluster after waiting. Please check k3s logs."
  exit 1
fi

echo "[INFO] Waiting for node $NODE_NAME to be ready..."
kubectl wait --for=condition=ready --timeout=600s node "$NODE_NAME"
kubectl get node -o wide
kubectl get pods -A

echo "======== K3s version =================="
echo "[INFO] k3s version:"
k3s --version
$K3SUP_BIN version

# --- Print version and summary ---
echo "======== Cluster Successfully installed =================="
echo "[SUCCESS] k3s cluster installed and bound to 127.0.0.1."
echo "[INFO] KUBECONFIG is set to $KUBECONFIG_PATH."
echo "[INFO] You may need to restart your shell for KUBECONFIG to take effect."
echo "[INFO] To access the cluster: kubectl get nodes"
echo "======== Cluster Successfully installed =================="
echo "======== For WSL, a reboot is needed for kubectl and variables to take effect =================="
echo "To access WSL under Windows use: wsl hostname -I " 

echo "======== Optional Tools Installation =================="
# --- Prompt for k9s ---
echo "Do you want to install k9s (terminal UI for Kubernetes)? [y/N]"
read -r INSTALL_K9S
if [[ $INSTALL_K9S =~ ^[Yy]$ ]]; then
  if ! command -v curl >/dev/null; then
    echo "[WARN] curl is required for k9s install. Skipping k9s."
  else
    echo "[INFO] Installing k9s using webinstall.dev..."
    curl -sS https://webinstall.dev/k9s | bash
    if [ -f "$HOME/.config/envman/PATH.env" ]; then
      source "$HOME/.config/envman/PATH.env"
      if ! grep -q 'source ~/.config/envman/PATH.env' "$HOME/.bashrc"; then
        echo 'source ~/.config/envman/PATH.env' >> "$HOME/.bashrc"
      fi
      echo "[INFO] k9s is now available in this session and future terminals."
    fi
    echo "[INFO] k9s installed. Run 'k9s' to start the UI."
  fi
else
  echo "[INFO] Skipping k9s installation."
fi

# --- Prompt for helm ---
echo "Do you want to install helm (Kubernetes package manager)? [y/N]"
read -r INSTALL_HELM
if [[ $INSTALL_HELM =~ ^[Yy]$ ]]; then
  if ! command -v curl >/dev/null; then
    echo "[WARN] curl is required for helm install. Skipping helm."
  else
    echo "[INFO] Installing helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "[INFO] helm installed. Run 'helm version' to verify."
  fi
else
  echo "[INFO] Skipping helm installation."
fi 