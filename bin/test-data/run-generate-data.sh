#!/bin/bash

app=$1
[ -z "$1" ] && app="app1"

for file in schema*-$app-*.pl; do
    csvfile=data-`basename $file .pl`.csv
    echo $file
    time perl generate-data.pl $file > $csvfile;
    echo
    ls -al $csvfile
    echo
done

cat data-schema-$app-port-msb.csv data-schema-$app-port-sbp.csv > data-schema-$app-port.csv
rm -f data-schema-$app-port-msb.csv data-schema-$app-port-sbp.csv
