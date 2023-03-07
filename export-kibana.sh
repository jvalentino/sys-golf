#!/bin/sh
curl -X POST http://localhost:5601/api/saved_objects/_export -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '
{
  "type": ["index-pattern", "config", "search"]
}' > config/helm/kibana/data.ndjson

