# demo-kafka-spark-pipeline


## Description
This is a dockerized demo setup containing:
- a Kafka setup 
    - mock data loader - loading R4 FHIR resources from mock-data-kdb.ndjson into the Kafka topic "fhir.post-gateway-kdb" 
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
This script runs the kafka_stream_con.py script inside the container:
- starts the SparkSession
- reads the Kafka topic into Spark - prints out a key-value table with the R4 FHIR resources inside
- bunsen.r4 stuff fails

(Jupyter lab was used for the bunsen tutorial and some of our experiments)
.
## Stop Container-Framework

```bash
# if not executable, first run "chmod +x stop.sh"
./stop.sh
```