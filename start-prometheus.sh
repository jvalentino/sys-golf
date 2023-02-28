#!/bin/sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm delete prometheus || true

pkill -f 9090
pkill -f 9093
pkill -f 9091

sleep 10
helm install -f config/helm/prometheus/values.yaml prometheus prometheus-community/kube-prometheus-stack
sleep 60

POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=prometheus" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 9090 > build/prometheus-server.log 2>&1 &

POD_NAME=$(kubectl get pods --namespace default -l "alertmanager=prometheus-kube-prometheus-alertmanager" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace default port-forward $POD_NAME 9093 > build/alert-manager.log 2>&1 &

# POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=prometheus-pushgateway" -o jsonpath="{.items[0].metadata.name}")
#kubectl --namespace default port-forward $POD_NAME 9091 > build/pushgateway.log 2>&1 &
