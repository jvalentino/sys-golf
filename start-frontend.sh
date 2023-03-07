#!/bin/sh
helm delete frontend --wait
helm install frontend --wait config/helm/frontend/ --values config/helm/frontend/values.yaml
sh -x ./verify-frontend.sh