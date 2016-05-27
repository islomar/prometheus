#!/bin/bash

echo "Starting Prometheus from Docker..."


docker build -t my-prometheus .
docker run --name my-prometheus -d -p 9090:9090 my-prometheus