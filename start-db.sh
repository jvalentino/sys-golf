#!/bin/sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm delete pg-primary || true
sleep 10
helm install pg-primary \
	--set auth.postgresPassword=postgres \
	--set auth.username=postgres \
	--set auth.database=examplesys \
	bitnami/postgresql
