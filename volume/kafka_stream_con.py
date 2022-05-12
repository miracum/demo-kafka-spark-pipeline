#!/bin/python

appName = "Kafka, Spark and FHIR Data"
kafka_topic = "fhir.post-gateway-kdb"

import pyspark
from pyspark.sql import SparkSession
from pathling.r4 import bundles

if __name__ == "__main__":

    try:
        spark = SparkSession \
            .builder \
            .appName(appName) \
            .master("local[*]") \
            .getOrCreate()

        print("\n\n########################################################")
        print("\nSystem Info\n")
        print("########################################################\n\n")
        print("Java version: {}\n\n".format(spark._jvm.java.lang.Runtime.version().toString()))
        print("Pyspark version: {}\n\n".format(pyspark.__version__))

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

        # close connection after 30 seconds
        query.awaitTermination(30)

        kafka_data = spark.sql("select * from gettable")
        kafka_data.show()
        type(kafka_data)

        resources = bundles.from_json(kafka_data, 'value')
        patients = bundles.extract_entry(spark, resources, 'Patient')
        encounter = bundles.extract_entry(spark, resources, 'Encounter')
        condition = bundles.extract_entry(spark, resources, 'Condition')

        patients.show()
        encounter.show()
        condition.show()
        
    except Exception as e:
        print(e)
