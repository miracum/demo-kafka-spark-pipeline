#!/bin/python

appName = "Kafka, Spark and FHIR Data"
master = "spark://spark:7077"
kafka_topic = "fhir.post-gateway-kdb"

# https://engineering.cerner.com/bunsen/0.5.10-SNAPSHOT/
from bunsen.r4.bundles import from_json, extract_entry
from pyspark.sql import SparkSession

if __name__ == "__main__":

    spark = SparkSession \
        .builder \
        .appName(appName) \
        .master(master) \
        .getOrCreate()

    df = spark \
        .readStream  \
        .format("kafka") \
        .option("kafka.bootstrap.servers", "kafka1:19092") \
        .option("subscribe", kafka_topic) \
        .option("startingOffsets", "earliest") \
        .load()

    df.printSchema()

    query = df.selectExpr("CAST(key AS STRING)", "CAST(value AS STRING)") \
            .writeStream \
            .queryName("gettable")\
            .format("memory")\
            .start()

    # close connection after 15 seconds
    query.awaitTermination(15)

    mydf = spark.sql("select * from gettable")
    mydf.show()
    type(mydf)

    df = mydf.toPandas()
    df

    mydf_rdd = mydf.rdd
    type(mydf_rdd) # convert to javaRDD for bunsen

    # the bunsen part is failing due to using old pyspark=2.4.4
    #bundles = from_json(mydf_rdd, 'value')
