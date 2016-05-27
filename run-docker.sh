#!/bin/bash

echo "Starting Prometheus..."


docker build -t my-prometheus .
docker run --name my-prometheus -d -p 9090:9090 my-prometheus