# demo-kafka-spark-pipeline


## Description
This is a dockerized demo setup containing:
- a Kafka setup 
    - mock data loader - loading FHIR resources from mock-data-kdb.ndjson into the Kafka topic "fhir.post-gateway-kdb" 
    - GUI AkHQ on http://localhost:8082)
- a SPARK setup
    - master on http://localhost:8083/ 
- a bunsen container built with Dockerfile.bunsen (defines important pyspark submit args)

## Start Container

In order to start the containers with kafka and mock-data-loader + bunsen container with tutorial + jupyter lab run the following command:

```bash
# if not executable, first run "chmod +x start.sh"
./start.sh
```

(Jupyter lab was used for the bunsen tutorial and some of our experiments)
.
## Stop Container-Framework

```bash
# if not executable, first run "chmod +x stop.sh"
./stop.sh
```