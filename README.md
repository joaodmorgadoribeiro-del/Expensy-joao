# Expensy - End-to-End DevOps Project

Expensy is a full-stack expense tracker application deployed on Azure Kubernetes Service (AKS) using a complete DevOps pipeline.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Azure Cloud                           │
│                                                         │
│  ┌─────────┐    ┌─────────────────────────────────┐    │
│  │   ACR   │    │         AKS Cluster              │    │
│  │ (Images)│    │                                  │    │
│  └─────────┘    │  ┌──────────┐  ┌─────────────┐  │    │
│                 │  │ Frontend │  │   Backend   │  │    │
│  ┌─────────┐    │  │ Next.js  │  │Node/Express │  │    │
│  │ GitHub  │    │  └──────────┘  └─────────────┘  │    │
│  │ Actions │    │  ┌──────────┐  ┌─────────────┐  │    │
│  │ CI/CD   │    │  │ MongoDB  │  │    Redis    │  │    │
│  └─────────┘    │  └──────────┘  └─────────────┘  │    │
│                 └─────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Next.js 14, Tailwind CSS |
| Backend | Node.js, Express, TypeScript |
| Database | MongoDB 7.0 |
| Cache | Redis 7.2 |
| Container Runtime | Docker |
| Orchestration | Kubernetes (AKS) |
| Package Manager | Helm |
| IaC | Terraform |
| CI/CD | GitHub Actions |
| Registry | Azure Container Registry (ACR) |
| Monitoring | Prometheus, Grafana, Loki |
| Ingress | NGINX Ingress Controller |
| TLS | cert-manager + Let's Encrypt |

## Project Structure

```
Expensy-Joao/
├── .github/
│   └── workflows/
│       └── ci-cd.yaml          # GitHub Actions pipeline
├── expensy_frontend/           # Next.js frontend
│   ├── Dockerfile
│   └── ...
├── expensy_backend/            # Node/Express backend
│   ├── Dockerfile
│   └── ...
├── k8s/
│   ├── expensy-chart/          # Helm Chart
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   └── network-policies/       # Network Policies
├── Terraform/                  # AKS Infrastructure
├── monitoring/                 # Prometheus, Grafana, Loki
├── security/                   # cert-manager, SECURITY.md
├── docker-compose.yaml         # Local development
└── README.md
```

## Quick Start

### Local Development

```bash
# Clone the repository
git clone https://github.com/joaodmorgadoribeiro-del/Expensy-joao
cd Expensy-joao

# Copy and configure environment variables
cp expensy_backend/.env.example expensy_backend/.env

# Start all services
docker-compose up -d

# Access the application
# Frontend: http://localhost:3000
# Backend:  http://localhost:5000
```

### Deploy to AKS

```bash
# 1. Provision infrastructure
cd Terraform
terraform init
terraform apply

# 2. Install NGINX Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace

# 3. Install cert-manager
cd security/cert-manager
./cert-manager-install.sh

# 4. Install monitoring stack
cd monitoring
./install.sh

# 5. Deploy Expensy
helm install expensy ./k8s/expensy-chart -n expensy

# 6. Apply network policies
kubectl apply -f k8s/network-policies/
```

## CI/CD Pipeline

The GitHub Actions pipeline runs on every push:

| Branch | Jobs |
|---|---|
| `develop` | Build & Test |
| `main` | Build & Test + Docker Push to ACR |

## Documentation

- [Kubernetes & Helm](k8s/README.md)
- [Monitoring](monitoring/README.md)
- [Terraform](Terraform/README.md)
- [Security](security/SECURITY.md)

## Author

João Ribeiro — IT Recruiter turned Cloud/DevOps Engineer
Ironhack Cloud & DevOps Bootcamp — 2026
