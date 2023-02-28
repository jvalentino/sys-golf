#!/bin/sh
helm delete etl
pkill -f svc/etl
sleep 10
helm install etl config/helm/etl/ --values config/helm/etl/values.yaml
sleep 30
kubectl port-forward --namespace default svc/etl 8081:8080 > build/etl.log 2>&1 &
