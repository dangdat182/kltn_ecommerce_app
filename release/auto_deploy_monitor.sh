#!/bin/bash
# Install Helm
set -e
LATEST_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
curl -LO https://get.helm.sh/helm-${LATEST_VERSION}-linux-amd64.tar.gz
tar -zxvf helm-${LATEST_VERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64 helm-${LATEST_VERSION}-linux-amd64.tar.gz
helm version

# Tạo namespace
kubectl create namespace monitoring

# Thêm Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Cài Prometheus
helm install prometheus prometheus-community/prometheus \
  --namespace monitoring

# Cài Grafana với cấu hình từ values.yaml
helm install grafana grafana/grafana \
  --namespace monitoring \
  --values grafana-values.yaml

# Hiển thị địa chỉ Grafana
kubectl get svc -n monitoring grafana

#install network tools
sudo apt update && sudo apt install iperf3 -y

#Intall iperf3 curl wrk inside pod
#apk update && apk add iperf3
#apk update && apk add curl
#apk update && apk add wrk 
