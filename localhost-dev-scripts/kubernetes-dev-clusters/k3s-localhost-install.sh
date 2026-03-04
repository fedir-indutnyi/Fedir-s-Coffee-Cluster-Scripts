#!/bin/bash
# run with: bash k3s-localhost-install.sh

# !!!! Need to be run as a normal user, not root, unless you know what you're doing !!!!
################################################################################################
# Created by Fedir Indutnyi                                                                    #
# Note: This script installs and configures k3s.                                               #
# Requires bash. On Alpine, run: apk add bash                                                   #
# Usage: bash k3s-localhost-install.sh                                                         #
################################################################################################


if [ -z "$BASH_VERSION" ]; then
  # Try to install bash if not present
  if ! command -v bash >/dev/null; then
    echo "[INFO] bash not found. Attempting to install bash..."
    if grep -qi 'alpine' /etc/os-release; then
      sudo apk add --no-cache bash
    elif grep -qi 'ubuntu' /etc/os-release; then
      sudo apt update && sudo apt install -y bash
    elif grep -qi 'rhel' /etc/os-release || grep -qi 'centos' /etc/os-release || grep -qi 'almalinux' /etc/os-release; then
      sudo dnf install -y bash || sudo yum install -y bash
    else
      echo "[ERROR] Unknown OS. Please install bash manually and rerun the script."
      exit 1
    fi
  fi
  echo "[INFO] Re-running script with bash..."
  exec bash "$0" "$@"
fi

set -euo pipefail


echo "!!! Important - make sure ending of this file is LF !!!"

echo "Update OS (recommended before install)"
echo "You may want to run: sudo apt update && sudo apt upgrade -y"
echo
# --- Disclaimer about static IP/hostname ---
echo "[DISCLAIMER] For best results, set a static IP and hostname for your VM using 'nmtui' before running this script."
echo "You can run 'sudo nmtui' to configure your network and hostname."
echo

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
elif grep -qi 'alpine' /etc/os-release; then
  OS_TYPE="alpine"
  PKG_UPDATE="sudo apk update"
  PKG_INSTALL="sudo apk add --no-cache"
  FIREWALL_DISABLE="echo '[INFO] Alpine does not use ufw/firewalld by default.'"
  FIREWALL_PERM_DISABLE="echo '[INFO] Alpine does not use ufw/firewalld by default.'"
else
  echo "[WARN] This script is designed for Ubuntu, AlmaLinux/RHEL, and Alpine. Continue? (y/N)"
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

if [ "$OS_TYPE" = "ubuntu" ]; then
  DEPS="curl sudo tar openssl iptables iproute2"
elif [ "$OS_TYPE" = "rhel" ]; then
  DEPS="curl sudo tar openssl iptables iproute"
elif [ "$OS_TYPE" = "alpine" ]; then
  DEPS="curl sudo bash tar openssl iptables iproute2"
else
  DEPS="curl sudo tar openssl iptables iproute2"
fi

for dep in $DEPS; do
  dep_check=$dep
  [ "$dep" = "iproute2" ] && dep_check="ip"
  if ! command -v $dep_check >/dev/null; then
    echo "[INFO] Installing missing dependency: $dep"
    eval "$PKG_INSTALL $dep"
  fi
done

# --- Post-dependency check for networking tools ---
if ! command -v iptables >/dev/null; then
  echo "[WARN] iptables is still missing! Cluster networking may not work."
fi
if ! command -v ip >/dev/null; then
  echo "[WARN] iproute (ip) is still missing! Cluster networking may not work."
fi

# --- Check for existing k3s install ---
if [ -x /usr/local/bin/k3s ]; then
  echo "[WARN] k3s is already installed. Do you want to uninstall and reinstall? [y/N]"
  read -r REINSTALL_K3S
  if [[ $REINSTALL_K3S =~ ^[Yy]$ ]]; then
    if [ -x /usr/local/bin/k3s-uninstall.sh ]; then
      echo "[INFO] Uninstalling existing k3s..."
      sudo /usr/local/bin/k3s-uninstall.sh
      sleep 3
    else
      echo "[ERROR] k3s-uninstall.sh not found. Please uninstall k3s manually."
      exit 1
    fi
  else
    echo "[INFO] Exiting without reinstalling k3s."
    exit 0
  fi
fi

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

# --- Prompt for dummy interface for stable cluster IP ---
echo "Do you want to create a dummy network interface for a stable cluster IP? [y/N]"
read -r CREATE_DUMMY_IF
USE_DUMMY_IF=false
DUMMY_IF_NAME="dummy0"
DUMMY_IP="192.168.100.100/32"
DUMMY_NODE_NAME="k3s-localhost"
if [[ $CREATE_DUMMY_IF =~ ^[Yy]$ ]]; then
  USE_DUMMY_IF=true
  echo "Enter the IP address for the dummy interface [default: $DUMMY_IP]:"
  read -r USER_DUMMY_IP
  if [ -n "$USER_DUMMY_IP" ]; then
    DUMMY_IP="$USER_DUMMY_IP"
  fi
  echo "Enter the node name for k3s [default: $DUMMY_NODE_NAME]:"
  read -r USER_DUMMY_NODE_NAME
  if [ -n "$USER_DUMMY_NODE_NAME" ]; then
    DUMMY_NODE_NAME="$USER_DUMMY_NODE_NAME"
  fi
  # Check if dummy0 exists
  if ip link show "$DUMMY_IF_NAME" >/dev/null 2>&1; then
    echo "[INFO] $DUMMY_IF_NAME already exists. Do you want to recreate it? [y/N]"
    read -r RECREATE_DUMMY
    if [[ $RECREATE_DUMMY =~ ^[Yy]$ ]]; then
      echo "[INFO] Deleting existing $DUMMY_IF_NAME..."
      if command -v nmcli >/dev/null; then
        nmcli connection delete "$DUMMY_IF_NAME" || true
      fi
      sudo ip link delete "$DUMMY_IF_NAME" || true
    else
      echo "[INFO] Keeping existing $DUMMY_IF_NAME."
    fi
  fi
  echo "[INFO] Creating $DUMMY_IF_NAME with IP $DUMMY_IP..."
  if command -v nmcli >/dev/null; then
    nmcli connection add type dummy ifname "$DUMMY_IF_NAME" con-name "$DUMMY_IF_NAME" ipv4.addresses "$DUMMY_IP" ipv4.method manual ipv6.method ignore
    nmcli connection up "$DUMMY_IF_NAME"
  else
    sudo ip link add "$DUMMY_IF_NAME" type dummy || true
    sudo ip addr flush dev "$DUMMY_IF_NAME" || true
    sudo ip addr add "$DUMMY_IP" dev "$DUMMY_IF_NAME"
    sudo ip link set "$DUMMY_IF_NAME" up
  fi
  ip addr show "$DUMMY_IF_NAME"
fi

# --- Prompt for static IP specification ---
echo "Do you want to specify a static host IP address for k3s? [y/N]"
read -r SPECIFY_STATIC_IP
USE_STATIC_IP=false
if [[ $SPECIFY_STATIC_IP =~ ^[Yy]$ ]]; then
  USE_STATIC_IP=true
fi

INSTALL_K3S_EXEC="server"
if $USE_DUMMY_IF; then
  # Use dummy interface IP and custom node name for k3s
  DUMMY_IP_ADDR="${DUMMY_IP%%/*}"
  INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --node-ip=$DUMMY_IP_ADDR --node-name=$DUMMY_NODE_NAME"
elif $USE_STATIC_IP; then
  echo "Enter the cluster IP to bind to [default: 127.0.0.1, or your real network IP]:"
  read -r CLUSTER_IP
  if [ -z "$CLUSTER_IP" ]; then
    CLUSTER_IP="127.0.0.1"
  fi
  INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --tls-san $CLUSTER_IP --bind-address=$CLUSTER_IP"
fi

# --- Prompt for Traefik ---
echo "[INFO] By default, k3s installs Traefik ingress."
echo "Do you want to install Traefik? [y/N]"
read -r INSTALL_TRAEFIK
if [[ ! $INSTALL_TRAEFIK =~ ^[Yy]$ ]]; then
  INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC --disable=traefik"
fi

ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N ""

echo "======== Installing k3s =================="
export INSTALL_K3S_EXEC
export K3S_KUBECONFIG_MODE="644"
echo "[INFO] Running: curl -sfL https://get.k3s.io | sh -"
curl -sfL https://get.k3s.io | sh -

# --- Wait for k3s.yaml to exist ---
echo "Waiting for /etc/rancher/k3s/k3s.yaml to be created by k3s..."
for i in {1..30}; do
  if [ -f /etc/rancher/k3s/k3s.yaml ]; then
    break
  fi
  sleep 2
done

if [ ! -f /etc/rancher/k3s/k3s.yaml ]; then
  echo "[ERROR] k3s did not start correctly. /etc/rancher/k3s/k3s.yaml not found after waiting."
  exit 1
fi

# --- Set up kubeconfig ---
echo "======== Setting default kubeconfig =================="
KUBECONFIG_PATH="$HOME_DIR/.kube/config"
mkdir -p "$HOME_DIR/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$KUBECONFIG_PATH"
sudo chown "$USER_NAME":"$USER_NAME" "$KUBECONFIG_PATH"
sudo chmod 600 "$KUBECONFIG_PATH"

if ! grep -q 'export KUBECONFIG=' "$HOME_DIR/.bashrc"; then
  echo "export KUBECONFIG=\"$KUBECONFIG_PATH\"" >> "$HOME_DIR/.bashrc"
fi
export KUBECONFIG="$KUBECONFIG_PATH"

kubectl config use-context default || true
kubectl get node -o wide || true

# --- Wait for node to be ready ---
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
k3s --version

echo "======== Cluster Successfully installed =================="
echo "[SUCCESS] k3s cluster installed."
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
  echo "[INFO] Installing k9s using webinstall.dev..."
  curl -sS https://webinstall.dev/k9s | bash
  if [ -f "$HOME/.config/envman/load.sh" ]; then
    source "$HOME/.config/envman/load.sh"
    if ! grep -q 'source ~/.config/envman/load.sh' "$HOME/.bashrc"; then
      echo 'source ~/.config/envman/load.sh' >> "$HOME/.bashrc"
    fi
    echo "[INFO] k9s command is now available in this session and future terminals."
  fi
  export PATH="$HOME/.local/bin:$PATH"
  echo "[INFO] k9s installed. Run 'k9s' to start the TUI."
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

# --- Print version and summary ---
echo "======== Installed Tool Versions =================="
if command -v k3s >/dev/null; then
  echo -n "k3s: "; k3s --version | head -n1
fi
if command -v kubectl >/dev/null; then
  KUBECTL_VER=$(kubectl version --client=true 2>/dev/null | grep -E 'GitVersion|Client Version' | head -n1 | awk -F: '{print $2}' | xargs)
  if [ -z "$KUBECTL_VER" ]; then
    KUBECTL_VER=$(kubectl version --client=true 2>/dev/null | head -n1)
  fi
  echo "kubectl: $KUBECTL_VER"
fi
if command -v helm >/dev/null; then
  echo -n "helm: "; helm version --short
fi
if command -v k9s >/dev/null; then
  K9S_VER=$(k9s version 2>/dev/null | grep -E '^Version:' | awk '{print $2}')
  if [ -n "$K9S_VER" ]; then
    echo "k9s: $K9S_VER"
  else
    echo -n "k9s: "; k9s version | head -n1
  fi
fi
if command -v curl >/dev/null; then
  echo -n "curl: "; curl --version | head -n1
fi
if command -v openssl >/dev/null; then
  echo -n "openssl: "; openssl version
fi
if command -v tar >/dev/null; then
  echo -n "tar: "; tar --version | head -n1
fi

