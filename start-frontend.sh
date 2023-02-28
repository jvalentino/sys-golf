#!/bin/sh
helm delete frontend
pkill -f svc/frontend
sleep 10
helm install frontend config/helm/frontend/ --values config/helm/frontend/values.yaml
sleep 30
kubectl port-forward --namespace default svc/frontend 3000:80 > build/frontend.log 2>&1 &
