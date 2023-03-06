#!/bin/sh
minikube addons enable default-storageclass
minikube addons enable storage-provisioner

helm repo add elastic https://helm.elastic.co
helm delete elasticsearch || true

# 
   # --set discovery.type=single-node \
sleep 10
helm install \
    --set replicas=1 \
    --set discovery.type=single-node \
    --wait --timeout=1200s \
    elasticsearch elastic/elasticsearch --values ./config/helm/elastic/values.yaml

# helm upgrade --wait --timeout=1200s --install --values ./config/helm/elastic/values.yaml helm-es-minikube .

sh -x ./verify-elastic.sh
