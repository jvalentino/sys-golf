#!/bin/sh
helm delete etl
helm install etl config/helm/etl/ --values config/helm/etl/values.yaml
