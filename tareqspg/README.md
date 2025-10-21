- **NGINX Plus** exposes `/api` (management) and `/metrics`
- **Exporter** scrapes metrics from NGINX Plus API
- **Prometheus Operator** collects and stores time series
- **Grafana** visualizes everything with alerts & dashboards

---

## 🧩 1. Helm Deployment Issues & Fixes

| Issue | Root Cause | Resolution |
|-------|-------------|------------|
| `ClusterRole "waitfor-reader" ... cannot be imported` | Helm release ownership mismatch | Reinstall chart under namespace `crapi` or delete old clusterrole |
| `Service "crapi-web" ... NodePort already allocated` | NodePort conflict | Changed NodePort in `values.yaml` (e.g., `30081`) |
| Pod `CrashLoopBackOff` (`crapi-web`) | Missing ConfigMap envs | Re-created `crapi-web-configmap` with correct service variables |

---

## ⚙️ 2. NGINX Configuration Errors

| Error | Cause | Solution |
|-------|--------|----------|
| `add_header not allowed here` | Declared outside `server` / `location` | Moved inside correct block |
| `limit_req_zone not allowed here` | Defined inside `server{}` | Moved to top-level `http{}` |
| 503 on rate-limit overflow | Default behavior = 503 | Added `limit_req_status 429;` |
| CORS failures | Missing OPTIONS handler | Added preflight CORS block |
| 401/404 responses | Wrong upstream targets | Fixed `proxy_pass` endpoints |

---

## 📊 3. Exporter (Pod) Problems

| Symptom | Cause | Fix |
|----------|--------|----|
| `error unmarshalling versions` | `/api/6` not compatible | Switched to `/api` |
| CrashLoop | Wrong flags | Corrected args:<br>`-nginx.plus`, `-nginx.scrape-uri=http://10.1.1.11:8080/api`, `-web.listen-address=:9113` |
| No scrape logs | Network reachability | Verified with `curlimages/curl` test pod |
| Missing curl | Minimal container | Used `curlimages/curl:8.5.0` for testing |

---

## 🧭 4. Prometheus Integration

| Issue | Cause | Solution |
|--------|--------|----------|
| Exporter not discovered | Label selector mismatch | Added `ServiceMonitor` with `app: nginx-plus-exporter` |
| Few metrics | Partial API exposure | Expanded NGINX config:<br>`location /api { api write=on; allow all; }` |
| Target validation | – | Verified via:<br>`curl -s http://prometheus-k8s.monitoring.svc:9090/api/v1/targets` |

---

## 📈 5. Grafana Datasource Lock Issue

| Problem | Root Cause | Solution |
|----------|-------------|-----------|
| “Provisioned data source cannot be modified” | Operator-managed Secret | Edited `grafana-datasources` secret:<br>`kubectl -n monitoring get secret grafana-datasources -o yaml` |
| No ConfigMap found | Datasource stored as Secret | Verified with `kubectl get secret grafana-datasources` |
| Test connectivity | – | `kubectl -n monitoring exec deploy/grafana -- curl -s -o /dev/null -w "%{http_code}\n" http://prometheus-k8s.monitoring.svc:9090/-/healthy → 200` |

---

## 🔍 6. Connectivity Checks

```bash
# From K8s → NGINX Plus
kubectl run curl --rm -it --image=curlimages/curl \
  -- curl -v http://10.1.1.11:8080/api/

# Exporter → NGINX Plus
curl -s http://10.1.1.11:8080/api | jq .

# Prometheus → Exporter
curl -s http://10.43.141.72:9113/metrics | head

# Grafana → Prometheus
kubectl -n monitoring exec deploy/grafana -- \
  curl -s -o /dev/null -w "%{http_code}\n" http://prometheus-k8s.monitoring.svc:9090/-/healthy
