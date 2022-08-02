# The Spark version needs to agree with the version in ./spark/Dockerfile.spark-base, and also the version supported
# by Pathling: https://pathling.csiro.au/docs/server/configuration#spark-compatibility
FROM jupyter/pyspark-notebook:spark-3.3.0
# Use this if you need an ARM-based image:
# FROM jupyter/pyspark-notebook:aarch64-spark-3.3.0

ENV PATHLING_VERSION=5.4.0
ARG SPARK_SCALA_VERSION=2.12
RUN /opt/conda/bin/pip install pathling==${PATHLING_VERSION}

USER root
RUN echo "spark.jars.packages org.apache.spark:spark-sql-kafka-0-10_${SPARK_SCALA_VERSION}:$APACHE_SPARK_VERSION,au.csiro.pathling:library-api:5.4.0" >> /usr/local/spark/conf/spark-defaults.conf

USER ${NB_UID}
RUN /opt/conda/bin/pip install pathling==5.4.0

# This caches the download of the dependencies specified earlier.
RUN source /usr/local/bin/before-notebook.d/spark-config.sh && \
    python -c "from pyspark.sql import SparkSession; SparkSession.builder.getOrCreate()"
