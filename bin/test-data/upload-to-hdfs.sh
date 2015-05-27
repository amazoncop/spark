#!/bin/bash

for file in data*.csv; do
    echo $file
    /root/ephemeral-hdfs/bin/hdfs dfs -rm /$file
    /root/ephemeral-hdfs/bin/hdfs dfs -put $file /$file 
    echo
done
