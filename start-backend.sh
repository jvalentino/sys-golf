#!/bin/sh
helm delete backend
pkill -f svc/backend
sleep 10
helm install backend config/helm/backend/ --values config/helm/backend/values.yaml
sleep 30
kubectl port-forward --namespace default svc/backend 8080:8080 > build/backend.log 2>&1 &
