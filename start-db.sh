#!/bin/sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm delete pg-primary || true
pkill -f svc/pg-primary-postgresql
sleep 10
helm install pg-primary \
	--set auth.postgresPassword=postgres \
	--set auth.username=postgres \
	--set auth.database=examplesys \
	bitnami/postgresql
sleep 30
kubectl port-forward --namespace default svc/pg-primary-postgresql 5432:5432 > build/pg-primary-postgresql.log 2>&1 &
