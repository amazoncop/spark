#!/bin/bash

mkdir -p opt/robco
mkdir -p opt/src
cd opt/src

curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo yum -y install sbt git mercurial iotop wget vim bzip2 tcpdump gcc gcc-c++ make cmake ant fuse autoconf automake libtool sharutils xmlto strace

wget http://mirror.ventraip.net.au/apache/spark/spark-1.2.2/spark-1.2.2-bin-hadoop2.4.tgz &
wget http://mirror.ventraip.net.au/apache/spark/spark-1.3.1/spark-1.3.1-bin-hadoop2.6.tgz &
wget http://mirror.ventraip.net.au/apache/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz &
wget http://nodejs.org/dist/v0.12.2/node-v0.12.2-linux-x64.tar.gz &
wait

tar xfz spark-1.2.2-bin-hadoop2.4.tgz &
tar xfz spark-1.3.1-bin-hadoop2.6.tgz &
tar xfz apache-maven-3.3.3-bin.tar.gz &
tar xfz node-v0.12.2-linux-x64.tar.gz &
wait

mkdir git
cd git
git clone https://github.com/amazoncop/spark
sbt compile
sbt package

export PATH=$PATH:~/opt/src/node-v0.12.2-linux-x64/bin
#cd ~/opt/src/
#git clone https://github.com/apache/incubator-zeppelin
#cd incubator-zeppelin/
#export JAVA_HOME=/usr/lib/jvm/jre-1.7.0/
#~/opt/src/apache-maven-3.3.3/bin/mvn install -DskipTests -Dspark.version=1.3.1 -Dhadoop.version=2.6.0


#############################
# HADOOP
#############################

sudo bash
useradd hadoop
su - hadoop
ssh-keygen -t rsa

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

cat >> ~/.bashrc <<EOF
export JAVA_HOME=/usr/lib/jvm/jre-1.7.0/
export HADOOP_HOME=$HOME/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
EOF
source ~/.bashrc

wget http://mirror.ventraip.net.au/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz
tar xfz hadoop-2.6.0.tar.gz
ln -s hadoop-2.6.0 hadoop
cd hadoop

cat > etc/hadoop/core-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
      <name>fs.default.name</name>
        <value>hdfs://0.0.0.0:9000</value>
    </property>
</configuration>
EOF

cat > etc/hadoop/hdfs-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
   <name>dfs.replication</name>
   <value>1</value>
  </property>
  <property>
    <name>dfs.name.dir</name>
      <value>file:///home/hadoop/hadoopdata/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.data.dir</name>
      <value>file:///home/hadoop/hadoopdata/hdfs/datanode</value>
  </property>
</configuration>
EOF

hdfs namenode -format
cd $HADOOP_HOME/sbin
start-dfs.sh
# bin/hdfs dfs -ls hdfs://localhost:9000/
# bin/hdfs dfs -put /etc/hosts hdfs://localhost:9000/hosts
# bin/hdfs dfs -ls hdfs://localhost:9000/

