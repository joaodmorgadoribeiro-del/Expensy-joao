# ============================================================
# 1. VERIFICAR SE O MONITORING ESTÁ A CORRER
# ============================================================
kubectl get pods -n monitoring

# ============================================================
# 2. ACEDER AO GRAFANA
# ============================================================
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
# Abre: http://localhost:3000
# User: admin
# Password: admin123

# ============================================================
# 3. ACEDER AO PROMETHEUS
# ============================================================
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
# Abre: http://localhost:9090

# ============================================================
# 4. ACEDER AO LOKI
# ============================================================
kubectl port-forward svc/loki 3100:3100 -n monitoring
# Abre: http://localhost:3100

# ============================================================
# 5. VER MÉTRICAS DOS PODS DO EXPENSY
# ============================================================
kubectl top pods -n expensy
kubectl top nodes

# ============================================================
# 6. QUERIES ÚTEIS NO PROMETHEUS (http://localhost:9090)
# ============================================================
# CPU usage por pod no namespace expensy:
# sum(rate(container_cpu_usage_seconds_total{namespace="expensy"}[5m])) by (pod)

# Memory usage por pod:
# sum(container_memory_usage_bytes{namespace="expensy"}) by (pod)

# Número de restarts por pod:
# kube_pod_container_status_restarts_total{namespace="expensy"}

# Pods em running:
# kube_pod_status_phase{namespace="expensy", phase="Running"}

# ============================================================
# 7. ADICIONAR LOKI COMO DATASOURCE NO GRAFANA
# ============================================================
# Settings -> Data Sources -> Add data source -> Loki
# URL: http://loki:3100

# ============================================================
# 8. VER LOGS DO EXPENSY NO LOKI (Grafana -> Explore)
# ============================================================
# {namespace="expensy"}
# {namespace="expensy", pod=~"expensy-backend.*"}
# {namespace="expensy", pod=~"expensy-frontend.*"}
# {namespace="expensy"} |= "error"