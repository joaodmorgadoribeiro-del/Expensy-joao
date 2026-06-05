#!/bin/bash
# cert-manager-install.sh

echo "Installing cert-manager..."

# Add Helm repo
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install cert-manager
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true \
  --wait \
  --timeout 5m

echo "✅ cert-manager installed!"