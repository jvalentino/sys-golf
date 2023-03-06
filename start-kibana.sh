#!/bin/sh

kubectl delete deploy kibana-deployment || true
kubectl create -f ./config/helm/kibana/deployment.yaml

kubectl wait pods -l app=kibana --for condition=Ready

sh -x ./verify-kibana.sh