#!/bin/sh
helm delete backend
sleep 10
helm install backend config/helm/backend/ --values config/helm/backend/values.yaml
