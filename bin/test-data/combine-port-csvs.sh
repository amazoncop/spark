#!/bin/bash

cat data-schema-app1-port-msb.csv data-schema-app1-port-sbp.csv > data-schema-app1-port.csv
rm -f data-schema-app1-port-msb.csv data-schema-app1-port-sbp.csv
