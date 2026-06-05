# Security & Compliance Documentation

## 1. IAM & Identity Management

### AKS Cluster Identity
The AKS cluster uses **SystemAssigned Managed Identity** instead of root credentials or service principals, eliminating the need to manage secrets for cluster operations.

```hcl
# Terraform - main.tf
identity {
  type = "SystemAssigned"
}
```

### ACR Integration
The AKS cluster is granted **AcrPull** role to pull images from the Azure Container Registry without storing credentials:

```bash
az aks update \
  --name joaocluster \
  --resource-group joao-rg \
  --attach-acr expensynacr
```

### Kubernetes RBAC
- All workloads run under the `default` Service Account with minimal permissions
- No cluster-admin roles assigned to application pods
- Secrets are managed via Kubernetes Secrets, never hardcoded in manifests

---

## 2. Network Security

### Network Policies
All inter-pod communication is restricted via Kubernetes NetworkPolicies:

| Source | Destination | Port | Allowed |
|---|---|---|---|
| Internet | Frontend | 3000 | ✅ |
| Frontend | Backend | 5000 | ✅ |
| Backend | MongoDB | 27017 | ✅ |
| Backend | Redis | 6379 | ✅ |
| Monitoring | All pods | various | ✅ |
| Any | Any (default) | any | ❌ |

Network policies are defined in `k8s/network-policies/`.

### NSG (Network Security Groups)
The AKS cluster is configured with the following inbound rules:

| Priority | Port | Protocol | Source | Action |
|---|---|---|---|---|
| 100 | 443 | TCP | Internet | Allow |
| 110 | 80 | TCP | Internet | Allow (redirect to HTTPS) |
| 65000 | Any | Any | VirtualNetwork | Allow |
| 65500 | Any | Any | Any | Deny |

### TLS/HTTPS
All external traffic is encrypted via TLS using **cert-manager** with **Let's Encrypt**:
- Certificate issuer: Let's Encrypt (production)
- Certificate renewal: Automatic (cert-manager)
- Ingress: NGINX with TLS termination

---

## 3. Secrets Management

### Kubernetes Secrets
All sensitive data is stored as Kubernetes Secrets:
- MongoDB credentials
- Redis password
- JWT secret
- NextAuth secret

Secrets are never committed to the repository. They are managed via:
- **Local development:** `.env` files (in `.gitignore`)
- **CI/CD:** GitHub Actions Secrets
- **Kubernetes:** Helm `--set` flags at deploy time

### GitHub Actions Secrets
| Secret | Purpose |
|---|---|
| `ACR_USERNAME` | Azure Container Registry access |
| `ACR_PASSWORD` | Azure Container Registry access |
| `MONGO_PASSWORD` | MongoDB authentication |
| `REDIS_PASSWORD` | Redis authentication |
| `JWT_SECRET` | Backend JWT signing |
| `NEXTAUTH_SECRET` | Frontend authentication |
| `NEXTAUTH_URL` | Frontend authentication URL |

---

## 4. Data Protection

### Data at Rest
- MongoDB data is stored in Azure Managed Disks (encrypted by default with AES-256)
- No sensitive data is stored in container images

### Data in Transit
- All external traffic is encrypted via TLS 1.2+
- Internal cluster communication uses Kubernetes network policies

### Retention Policy
- Application logs: 7 days (Loki)
- Metrics: 7 days (Prometheus)
- MongoDB backups: Not configured (development environment)

---

## 5. Compliance

### GDPR Considerations
- User data is stored in MongoDB within the Azure East US region
- No data is shared with third parties
- Users can request data deletion via the application API

### Security Checklist
- [x] No root credentials used
- [x] Managed Identity for AKS
- [x] Network Policies configured
- [x] TLS/HTTPS enabled
- [x] Secrets managed via Kubernetes Secrets
- [x] Container images stored in private ACR
- [x] CI/CD secrets stored in GitHub Actions Secrets
- [x] `.env` files in `.gitignore`
- [ ] Pod Security Standards (future improvement)
- [ ] Azure Key Vault integration (future improvement)