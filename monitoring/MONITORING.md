# ============================================================
# ============================================================
# 1. CHECK IF MONITORING IS RUNNING
# ============================================================
kubectl get pods -n monitoring
# ============================================================
# 2. ACCESS GRAFANA
# ============================================================
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
# Open: http://localhost:3000
# User: admin
# Password: admin123
# ============================================================
# 3. ACCESS PROMETHEUS
# ============================================================
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
# Open: http://localhost:9090
# ============================================================
# 4. ACCESS LOKI
# ============================================================
kubectl port-forward svc/loki 3100:3100 -n monitoring
# Open: http://localhost:3100
# ============================================================
# 5. VIEW EXPENSY POD METRICS
# ============================================================
kubectl top pods -n expensy
kubectl top nodes
# ============================================================
# 6. USEFUL PROMETHEUS QUERIES (http://localhost:9090)
# ============================================================
# CPU usage per pod in the expensy namespace:
# sum(rate(container_cpu_usage_seconds_total{namespace="expensy"}[5m])) by (pod)
# Memory usage per pod:
# sum(container_memory_usage_bytes{namespace="expensy"}) by (pod)
# Number of restarts per pod:
# kube_pod_container_status_restarts_total{namespace="expensy"}
# Pods in running state:
# kube_pod_status_phase{namespace="expensy", phase="Running"}
# ============================================================
# 7. ADD LOKI AS A DATASOURCE IN GRAFANA
# ============================================================
# Settings -> Data Sources -> Add data source -> Loki
# URL: http://loki:3100
# ============================================================
# 8. VIEW EXPENSY LOGS IN LOKI (Grafana -> Explore)
# ============================================================
# {namespace="expensy"}
# {namespace="expensy", pod=~"expensy-backend.*"}
# {namespace="expensy", pod=~"expensy-frontend.*"}
# {namespace="expensy"} |= "error"
