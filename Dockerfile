FROM jupyter/pyspark-notebook:latest

RUN /opt/conda/bin/pip install pathling==5.0.3.dev0

ENV PYSPARK_SUBMIT_ARGS=" \
    --packages org.apache.spark:spark-sql-kafka-0-10_2.12:$APACHE_SPARK_VERSION,au.csiro.pathling:encoders:5.0.2-SNAPSHOT \
    --repositories https://oss.sonatype.org/content/repositories/snapshots \
    pyspark-shell"

# This caches the download of the dependencies specified earlier.
RUN source /usr/local/bin/before-notebook.d/spark-config.sh && \
    python -c "from pyspark.sql import SparkSession; SparkSession.builder.getOrCreate()"