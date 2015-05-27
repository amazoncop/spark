#!/bin/bash

/root/ephemeral-hdfs/bin/hdfs dfs -rm  /spk1-assembly-1.0.jar
/root/ephemeral-hdfs/bin/hdfs dfs -put /home/ec2-user/opt/src/git/spark/target/scala-2.10/spk1-assembly-1.0.jar /

