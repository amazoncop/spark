# SBT Project for Spark Demo

This repository contains an SBT project with an example application which can be run on Spark cluster. The example application requires some test data to be available via HDFS, and will read the test data in CSV format, convert them to DataFrames and then use a HiveContext to query the data with simple SQL statements

## Prerequisites

This setup has been developed on top of a cluster of Amazon EC2 nodes, built using the spark-ec2 application. In our case, we used spark-1.3.1 with hadoop-cdh4.2.0.

## What's in the box

This repository includes an SBT configuration with these plugins:

* gen-idea - for generating an IntelliJ 13 IDEA configuration
* sbt-assembly - for generating fat JAR files with all dependencies, which will be deployed to run on a Spark Cluster (--deploy-mode cluster)

It also includes other helper scripts, which have been designed to run on a Spark cluster node (master or slave).

* A bootstrap script (bootstrap.sh) for downloading and installing essential packages onto a new cluster
* A script for uploading the example application to a HDFS cluster, so that Spark worker nodes can fetch and run the application.
* A script for submitting the example application to a spark cluster (bin/run-spark-sql.sh)
* A script for generating sets of test data of different sizes

