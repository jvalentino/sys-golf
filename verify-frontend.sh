#!/bin/sh

kubectl port-forward --namespace default svc/frontend 3000:80 > build/frontend.log 2>&1 &
curl http://localhost:3000/

while [ $? -ne 0 ]; do
    kubectl port-forward --namespace default svc/frontend 3000:80 > build/frontend.log 2>&1 &
    curl http://localhost:3000/
    sleep 5
done
