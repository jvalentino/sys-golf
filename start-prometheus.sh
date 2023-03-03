#!/bin/sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm delete prometheus || true

sleep 10
helm install -f config/helm/prometheus/values.yaml prometheus prometheus-community/kube-prometheus-stack

# POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=prometheus-pushgateway" -o jsonpath="{.items[0].metadata.name}")
#kubectl --namespace default port-forward $POD_NAME 9091 > build/pushgateway.log 2>&1 &
