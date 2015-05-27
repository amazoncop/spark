#!/bin/bash


APP="app1"
[ -n "$1" ] && APP="$1"

/home/ec2-user/spark-1.3.1-bin-hadoop2.6/bin/spark-submit \
    --class robco.SparkSql \
    --master spark://$SPARK_MASTER_ADDRESS:7077 \
    --deploy-mode cluster \
    --driver-memory 6G \
    --executor-memory 6G \
    --jars hdfs://$SPARK_MASTER_ADDRESS:9000/spk1-assembly-1.0.jar \
    hdfs://$SPARK_MASTER_ADDRESS:9000/spk1-assembly-1.0.jar \
    $SPARK_MASTER_ADDRESS \
    $SPARK_MASTER_ADDRESS \
    $APP

