#!/bin/sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm delete --wait pg-secondary || true
helm install pg-secondary \
	--wait \
	--set auth.postgresPassword=postgres \
	--set auth.username=postgres \
	--set auth.database=dw \
	bitnami/postgresql
sh -x ./verify-dw.sh