#!/bin/sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm delete pg-secondary || true
helm install pg-secondary \
	--set auth.postgresPassword=postgres \
	--set auth.username=postgres \
	--set auth.database=dw \
	bitnami/postgresql
