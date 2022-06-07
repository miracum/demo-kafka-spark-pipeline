FROM jupyter/pyspark-notebook:latest

ARG SPARK_SCALA_VERSION=2.12

USER root
RUN echo "spark.jars.packages org.apache.spark:spark-sql-kafka-0-10_${SPARK_SCALA_VERSION}:$APACHE_SPARK_VERSION,au.csiro.pathling:encoders:5.1.0" >> /usr/local/spark/conf/spark-defaults.conf

USER ${NB_UID}
RUN /opt/conda/bin/pip install pathling==5.1.0

# This caches the download of the dependencies specified earlier.
RUN source /usr/local/bin/before-notebook.d/spark-config.sh && \
    python -c "from pyspark.sql import SparkSession; SparkSession.builder.getOrCreate()"
