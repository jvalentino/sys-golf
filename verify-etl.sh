#!/bin/sh

kubectl port-forward --namespace default svc/etl 8081:8080 > build/etl.log 2>&1 &
curl http://localhost:8081/actuator/health

while [ $? -ne 0 ]; do
    kubectl port-forward --namespace default svc/etl 8081:8080 > build/etl.log 2>&1 &
    curl http://localhost:8081/actuator/health
    sleep 5
done
