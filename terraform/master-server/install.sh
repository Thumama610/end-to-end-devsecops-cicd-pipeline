#!/bin/bash

set -e

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Adding Kubernetes official GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Adding Kubernetes apt repository...
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

# Updating apt...
sudo apt-get update -y

# Installing kubectl, kubeadm, kubelet...
sudo apt-get install -y kubectl kubeadm kubelet

# Holding versions (recommended for stability)..."
sudo apt-mark hold kubectl kubeadm kubelet


# Install kubeaudit (latest release)


# Installing kubeaudit...

KUBEAUDIT_VERSION=$(curl -s https://api.github.com/repos/Shopify/kubeaudit/releases/latest | grep tag_name | cut -d '"' -f 4)

curl -L -o kubeaudit.tar.gz https://github.com/Shopify/kubeaudit/releases/download/${KUBEAUDIT_VERSION}/kubeaudit_${KUBEAUDIT_VERSION#v}_linux_amd64.tar.gz

tar -xzf kubeaudit.tar.gz
chmod +x kubeaudit
sudo mv kubeaudit /usr/local/bin/

rm -f kubeaudit.tar.gz

# Verify installations

#kubectl version --client
#kubeadm version
#kubelet --version
#kubeaudit version
