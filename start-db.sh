#!/bin/sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm delete pg-primary --wait || true
helm install pg-primary \
	--wait \
	--set auth.postgresPassword=postgres \
	--set auth.username=postgres \
	--set auth.database=examplesys \
	bitnami/postgresql

kubectl port-forward --namespace default svc/pg-primary-postgresql 5432:5432 > build/pg-primary-postgresql.log 2>&1 &
