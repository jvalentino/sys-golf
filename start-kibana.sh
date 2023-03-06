#!/bin/sh

helm delete kibana || true

sleep 10
helm install kibana \
  elastic/kibana \
  --wait \
  --values ./config/helm/kibana/values.yaml
