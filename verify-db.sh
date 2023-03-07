#!/bin/sh

kubectl port-forward --namespace default svc/pg-primary-postgresql 5432:5432 > build/pg-primary-postgresql.log 2>&1 &
psql -d postgresql://postgres:postgres@localhost:5432/examplesys -c "select now()"

while [ $? -ne 0 ]; do
    kubectl port-forward --namespace default svc/pg-primary-postgresql 5432:5432 > build/pg-primary-postgresql.log 2>&1 &
    psql -d postgresql://postgres:postgres@localhost:5432/examplesys -c "select now()"
    sleep 5
done
