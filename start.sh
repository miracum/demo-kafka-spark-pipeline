#!/bin/bash

# start container-framework, always rebuild bunsen container
docker-compose -f docker-compose.dev.yml up -d --build

# check logs of bunsen container for getting URL
docker exec -it bunsen bash -c "python work/kafka_stream_con.py"
