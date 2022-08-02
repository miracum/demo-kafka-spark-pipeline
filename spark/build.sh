#!/bin/bash
set -e

# https://www.kdnuggets.com/2020/07/apache-spark-cluster-docker.html

docker build -f Dockerfile.cluster-base -t cluster-base .
docker build -f Dockerfile.spark-base -t spark-base .
docker build -f Dockerfile.spark-master -t spark-master .
docker build -f Dockerfile.spark-worker -t spark-worker .
