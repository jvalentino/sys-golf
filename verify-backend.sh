#!/bin/sh

kubectl port-forward --namespace default svc/backend 8080:8080 > build/backend.log 2>&1 &
curl http://localhost:8080/actuator/health

while [ $? -ne 0 ]; do
    kubectl port-forward --namespace default svc/backend 8080:8080 > build/backend.log 2>&1 &
    curl http://localhost:8080/actuator/health
    sleep 5
done
