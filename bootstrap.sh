#!/bin/bash

mkdir -p opt/robco
mkdir -p opt/src
cd opt/src

sudo yum -y install sbt git mercurial iotop wget vim
wget http://mirror.ventraip.net.au/apache/spark/spark-1.2.2/spark-1.2.2-bin-hadoop2.4.tgz &
wget http://mirror.ventraip.net.au/apache/spark/spark-1.3.1/spark-1.3.1-bin-hadoop2.6.tgz &
waitall
tar xfz spark-1.2.2-bin-hadoop2.4.tgz
tar xfz spark-1.3.1-bin-hadoop2.6.tgz

curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo

mkdir git
cd git
git clone https://github.com/amazoncop/spark
sbt compile
sbt package

