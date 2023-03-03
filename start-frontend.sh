#!/bin/sh
helm delete frontend
helm install frontend config/helm/frontend/ --values config/helm/frontend/values.yaml
