#!/bin/sh
helm delete backend --wait
helm install backend --wait config/helm/backend/ --values config/helm/backend/values.yaml
sh -x ./verify-backend.sh
