#!/bin/sh

ES_PASSWORD=`kubectl get secrets --namespace=default elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d`
ES_USERNAME="elastic"

kubectl port-forward --namespace default svc/elasticsearch-master 9200:9200 > build/elasticsearch.log 2>&1 &
curl -k -u "${ES_USERNAME}:${ES_PASSWORD}" https://localhost:9200

while [ $? -ne 0 ]; do
    kubectl port-forward --namespace default svc/elasticsearch-master 9200:9200 > build/elasticsearch.log 2>&1 &
    curl -k -u "${ES_USERNAME}:${ES_PASSWORD}" https://localhost:9200
    sleep 5
done
