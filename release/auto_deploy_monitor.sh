#!/bin/bash
set -e

# Install Helm vào thư mục local
LATEST_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
curl -LO https://get.helm.sh/helm-${LATEST_VERSION}-linux-amd64.tar.gz
tar -zxvf helm-${LATEST_VERSION}-linux-amd64.tar.gz
chmod +x linux-amd64/helm
export PATH=$PATH:$(pwd)/linux-amd64  # Thêm helm vào PATH tạm thời
helm version
echo "Install helm done"
# Tạo namespace
kubectl create namespace monitoring || true

# Thêm Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Cài Prometheus
helm install prometheus prometheus-community/prometheus --namespace monitoring

# Cài Grafana
helm install grafana grafana/grafana \
  --namespace monitoring \
  --values grafana-values.yaml

# Hiển thị địa chỉ Grafana
kubectl get svc -n monitoring grafana
