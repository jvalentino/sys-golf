#!/bin/sh
curl -X POST "http://localhost:5601/api/saved_objects/_import?overwrite=true" -H "kbn-xsrf: true" --form file=@config/helm/kibana/data.ndjson
