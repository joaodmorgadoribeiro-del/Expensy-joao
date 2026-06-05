# Kubernetes & Helm

This directory contains all Kubernetes manifests and the Helm Chart for deploying Expensy on AKS.

## Structure

```
k8s/
├── expensy-chart/              # Helm Chart
│   ├── Chart.yaml              # Chart metadata
│   ├── values.yaml             # Default values
│   └── templates/              # Kubernetes manifests
│       ├── namespace.yaml
│       ├── secrets.yaml
│       ├── frontend-deployment.yaml
│       ├── frontend-service.yaml
│       ├── backend-deployment.yaml
│       ├── backend-service.yaml
│       ├── mongo-statefulset.yaml
│       ├── mongo-service.yaml
│       ├── redis-deployment.yaml
│       ├── redis-service.yaml
│       ├── ingress.yaml
│       └── network-policy-*.yaml
└── network-policies/           # Network Policies (standalone)
    ├── deny-all.yaml
    ├── allow-frontend.yaml
    ├── allow-backend.yaml
    ├── allow-mongo.yaml
    ├── allow-redis.yaml
    ├── allow-monitoring.yaml
    └── allow-certmanager.yaml
```

## Prerequisites

```bash
# Azure CLI
az login
az aks get-credentials --resource-group joao-rg --name joaocluster

# Helm
helm version

# kubectl
kubectl version
```

## Deploy

```bash
# Install
helm install expensy ./expensy-chart -n expensy

# Upgrade
helm upgrade expensy ./expensy-chart -n expensy

# Uninstall
helm uninstall expensy -n expensy
```

## Configuration

Edit `values.yaml` to configure the deployment:

```yaml
# Image tags
frontend:
  image:
    repository: expensynacr.azurecr.io/expensy-app
    tag: latest

backend:
  image:
    repository: expensynacr.azurecr.io/expensy-backend
    tag: latest

# Secrets
secrets:
  mongoPassword: "your-password"
  redisPassword: "your-password"
  jwtSecret: "your-secret"
  nextauthSecret: "your-secret"
  nextauthUrl: "https://expensy.ironhack.com"

# Ingress
ingress:
  host: expensy.ironhack.com
```

## Network Policies

Network policies restrict communication between pods:

| Source | Destination | Port |
|---|---|---|
| NGINX Ingress | Frontend | 3000 |
| NGINX Ingress | Backend | 5000 |
| Frontend | Backend | 5000 |
| Backend | MongoDB | 27017 |
| Backend | Redis | 6379 |
| Monitoring | All pods | various |

```bash
# Apply network policies
kubectl apply -f network-policies/

# Verify
kubectl get networkpolicies -n expensy
```

## Useful Commands

```bash
# Check all resources
kubectl get all -n expensy

# Check pods
kubectl get pods -n expensy

# Check logs
kubectl logs -n expensy deployment/expensy-backend-deployment
kubectl logs -n expensy deployment/expensy-deployment

# Port forward for local testing
kubectl port-forward svc/expensy-service 3000:80 -n expensy
kubectl port-forward svc/expensy-backend-service 5000:5000 -n expensy
```
