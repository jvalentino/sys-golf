#!/bin/sh
helm delete backend --wait
helm install backend --wait config/helm/backend/ --values config/helm/backend/values.yaml
kubectl port-forward --namespace default svc/backend 8080:8080 > build/backend.log 2>&1 &
