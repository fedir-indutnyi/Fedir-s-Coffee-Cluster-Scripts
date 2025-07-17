#!/bin/bash

set -e

echo "📡 Interfaces with IPv4 addresses (excluding some virtual interfaces):"

# Show interfaces except lo and these virtual types, but allow enp* etc
interfaces=$(ip -4 -o addr show | grep -vE ' lo | docker | cni | flannel | kube | dummy | veth | br- ' | awk '{print $2, $4}')

if [[ -z "$interfaces" ]]; then
  echo "❌ No suitable network interfaces with IPv4 found."
  exit 1
fi

echo "$interfaces" | nl -w2 -s'. '

# Pick the first interface whose subnet is NOT /32 (to avoid dummy0 etc)
selected_line=$(echo "$interfaces" | grep -v '/32' | head -n1)

if [[ -z "$selected_line" ]]; then
  echo "❌ No suitable interface with a non-/32 subnet found."
  exit 1
fi

iface=$(echo "$selected_line" | awk '{print $1}')
subnet=$(echo "$selected_line" | awk '{print $2}')

# Convert subnet to /24 scanning subnet, e.g. 192.168.2.115/24 => 192.168.2.0/24
subnet_prefix=$(echo "$subnet" | cut -d. -f1-3)
scan_subnet="${subnet_prefix}.0/24"

echo "🔍 Scanning for Ollama on interface '$iface' subnet '$scan_subnet'..."

found="no"

mapfile -t hosts < <(nmap -p 11434 --open -n -oG - "$scan_subnet" | grep "Ports: 11434/open" | awk '{print $2}')

for ip in "${hosts[@]}"; do
  if curl -s --max-time 2 "http://$ip:11434" | grep -q "Ollama is running"; then
    echo "✅ Ollama found at $ip"
    echo "curl -s --max-time 2 http://$ip:11434 | grep -q 'Ollama is running'"
    found="yes"
  fi
done

if [[ $found == "no" ]]; then
  echo "❌ Ollama not found in $scan_subnet"
fi
