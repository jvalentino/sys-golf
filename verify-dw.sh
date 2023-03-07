#!/bin/sh

kubectl port-forward --namespace default svc/pg-secondary-postgresql 5433:5432 > build/pg-secondary-postgresql.log 2>&1 &
psql -d postgresql://postgres:postgres@localhost:5433/dw -c "select now()"

while [ $? -ne 0 ]; do
    kubectl port-forward --namespace default svc/pg-secondary-postgresql 5433:5432 > build/pg-secondary-postgresql.log 2>&1 &
    psql -d postgresql://postgres:postgres@localhost:5433/dw -c "select now()"
    sleep 5
done
