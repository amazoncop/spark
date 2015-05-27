#!/bin/bash

APP="app1"
[ -n "$1" ] && APP="$1"

for file in data*$APP*.csv; do
    echo $file
    /root/ephemeral-hdfs/bin/hdfs dfs -rm /$file
    /root/ephemeral-hdfs/bin/hdfs dfs -put $file /$file 
    echo
done
