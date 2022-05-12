#!/bin/bash

# start container-framework
docker build -f Dockerfile -t jupyter-pathling .
docker-compose -f docker-compose.dev.yml up -d

printf "waiting 30 seconds for mock-data-loader to finish\n\n"
sleep 30

# check logs of bunsen container for getting URL
docker exec -it --user jovyan jupyter-pathling bash -c "python work/kafka_stream_con.py"

# check logs of pathling container for getting URL
# docker logs -f jupyter-pathling
