#!/bin/bash


for file in schema*.pl; do
    csvfile=data-`basename $file .pl`.csv
    echo $file
    time perl generate-data.pl $file > $csvfile;
    echo
    ls -al $csvfile
    echo
done

