#!/bin/sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm delete pg-secondary || true
pkill -f svc/pg-secondary-postgresql
sleep 10
helm install pg-secondary \
	--set auth.postgresPassword=postgres \
	--set auth.username=postgres \
	--set auth.database=dw \
	bitnami/postgresql
sleep 30
kubectl port-forward --namespace default svc/pg-secondary-postgresql 5433:5432 > build/pg-secondary-postgresql.log 2>&1 &
