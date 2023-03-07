#!/bin/sh
helm delete etl --wait
helm install etl --wait config/helm/etl/ --values config/helm/etl/values.yaml
sh -x ./verify-etl.sh