#!/bin/sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm delete pg-primary --wait || true
helm install pg-primary \
	--wait \
	--set auth.postgresPassword=postgres \
	--set auth.username=postgres \
	--set auth.database=examplesys \
	bitnami/postgresql
sh -x ./verify-db.sh