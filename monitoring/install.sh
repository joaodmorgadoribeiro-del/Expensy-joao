#!/bin/bash
# install.sh - Install monitoring stack

echo "================================================"
echo "Installing Monitoring Stack for Expensy"
echo "================================================"

# Add Helm repos
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Create namespace
kubectl apply -f namespace.yaml

# Install Prometheus + Grafana
echo "Installing Prometheus + Grafana..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values prometheus-values.yaml \
  --wait \
  --timeout 5m

# Install Loki + Promtail
echo "Installing Loki + Promtail..."
helm upgrade --install loki grafana/loki-stack \
  --namespace monitoring \
  --values loki-values.yaml \
  --wait \
  --timeout 5m

echo "================================================"
echo "✅ Monitoring stack installed!"
echo "================================================"
echo "Access Grafana:"
echo "kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring"
echo "URL: http://localhost:3000"
echo "User: admin"
echo "Password: admin123"
echo "================================================"