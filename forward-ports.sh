#!/bin/sh

kubectl port-forward --namespace default svc/backend 8080:8080 > build/backend.log 2>&1 &
kubectl port-forward --namespace default svc/pg-primary-postgresql 5432:5432 > build/pg-primary-postgresql.log 2>&1 &
kubectl port-forward --namespace default svc/pg-secondary-postgresql 5433:5432 > build/pg-secondary-postgresql.log 2>&1 &
kubectl port-forward --namespace default svc/etl 8081:8080 > build/etl.log 2>&1 &
kubectl port-forward --namespace default svc/frontend 3000:80 > build/frontend.log 2>&1 &
kubectl port-forward --namespace default svc/prometheus-operated 9090:9090 > build/prometheus-server.log 2>&1 &
kubectl port-forward --namespace default svc/alertmanager-operated 9093:9093 > build/alertmanager.log 2>&1 &
kubectl port-forward --namespace default svc/elasticsearch-master 9200:9200 > build/elasticsearch.log 2>&1 &
kubectl port-forward --namespace default svc/kibana 5601:5601 > build/kibana.log 2>&1 &

sleep 5
ps -ef | grep port-forward