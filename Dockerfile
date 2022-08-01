FROM jupyter/pyspark-notebook:spark-3.2.1

ENV PATHLING_VERSION=5.4.0
ENV PYSPARK_VERSION=3.2.1
RUN /opt/conda/bin/pip install \
    pathling==${PATHLING_VERSION} \
    pyspark==${PYSPARK_VERSION}

ARG SPARK_SCALA_VERSION=2.12

ENV PYSPARK_SUBMIT_ARGS=" \
    --packages org.apache.spark:spark-sql-kafka-0-10_${SPARK_SCALA_VERSION}:$APACHE_SPARK_VERSION,au.csiro.pathling:encoders:${PATHLING_VERSION} \
    --repositories https://oss.sonatype.org/content/repositories/snapshots \
    pyspark-shell"

# This caches the download of the dependencies specified earlier.
RUN source /usr/local/bin/before-notebook.d/spark-config.sh && \
    python -c "from pyspark.sql import SparkSession; SparkSession.builder.getOrCreate()"
