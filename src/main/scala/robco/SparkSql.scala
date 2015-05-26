package robco

import org.apache.spark.{SparkContext, SparkConf}

object DataClasses {
}

object SparkSql {
  // case class Person(firstName: String, lastName: String, gender: String)
  case class Node(nodeId: String)
  case class Port(egressRate: String, nodeId: String, pirHigh: String, pirLow: String, portId: String)
  case class Queue(nodeId: String, portId: String, queueId: String)
  case class Reading(readingId: String, timestamp: String, value: String)

  def main(args: Array[String]) = {
    val sparkMaster = args(0)
    val hdfsRoot = "hdfs://" + args(1) + ":9000"
    val startTime = System.currentTimeMillis()/1000
    val conf = new SparkConf().setMaster(sparkMaster).set("spark.driver.memory", "2G")
    val sc = new SparkContext(conf)
    val hc = new org.apache.spark.sql.hive.HiveContext(sc)
    import hc.implicits._
    val nodesRDD = sc.textFile(s"$hdfsRoot/data-schema-app1-node.csv").map(_.split(",")).map(n => Node(n(0)))
    val nodes = nodesRDD.toDF
    nodes.registerTempTable("nodes")
    val portsRDD = sc.textFile(s"$hdfsRoot/data-schema-app1-port.csv").map(_.split(",")).map(p => Port(p(0),p(1),p(2),p(3),p(4)))
    val ports = portsRDD.toDF
    val queuesRDD = sc.textFile(s"$hdfsRoot/data-schema-app1-queue.csv").map(_.split(",")).map(q => Queue(q(0),q(1),q(2)))
    val queues = queuesRDD.toDF
    queues.registerTempTable("ports")
    val rows = hc.sql("select * from nodes, ports, queues where nodes.nodeId = ports.nodeId and ports.nodeId = queues.nodeId and port.portId = queues.portId")
    val results = rows.collect
    val endTime = System.currentTimeMillis()/1000
    println("number of results: " + results.length)
    println(endTime - startTime)
  }
}
