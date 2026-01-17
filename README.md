# Kepler Module

```bash
# book minikube
minikube start --kubernetes-version=v1.32.0
# minikube addons enable ingress
kubectl config use-context minikube && kubectl config current-context

terraform apply

# Import in grafana
# https://raw.githubusercontent.com/sustainable-computing-io/kepler-operator/main/hack/dashboard/assets/kepler/dashboard.json
# https://raw.githubusercontent.com/sustainable-computing-io/kepler-operator/main/hack/dashboard/assets/prometheus/dashboard.json
# https://raw.githubusercontent.com/ariewald/kepler-grafana-dashboard/refs/heads/main/kepler.json
# https://raw.githubusercontent.com/bernardodon/energy-k8s-experiments/refs/heads/main/grafana-setup.json

kubectl --namespace monitoring get secrets prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80 # admin user
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090
kubectl port-forward -n opencost svc/opencost 9090
```
