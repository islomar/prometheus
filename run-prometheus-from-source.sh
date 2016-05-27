#!/bin/bash

echo "Starting Prometheus from Docker..."

cd $GOPATH/src/github.com/prometheus/prometheus
./prometheus -config.file=/Users/islomar/workspace/prometheus/prometheus.yml