package robco

import org.apache.spark.{SparkContext, SparkConf}

object DataClasses {
}

object SparkSql {
  // case class Person(firstName: String, lastName: String, gender: String)
  case class Node(nodeId: String)
  case class Port(egressRate: String, nodeId: String, pirHigh: String, pirLow: String, portId: String)
  case class Queue(nodeId: String, portId: String, queueId: String)
  case class Reading(nodeId: String, portId: String, queueId: String, readingId: String, timestamp: String, value: String)

  def main(args: Array[String]) = {

    // val sparkMaster = args(0)
    val sparkMaster = "spark://" + args(0) + ":7077"
    println("spark master: " + sparkMaster)
    val hdfsRoot = "hdfs://" + args(1) + ":9000"
    val startTime = System.currentTimeMillis()/1000
    val conf =
        new SparkConf().setMaster(sparkMaster)
            .set("spark.driver.memory", "6G")
            .set("spark.storage.memoryFraction", "0")
            .set("spark.executor.memory", "6g")
    val dataset = args(2)
    val sc = new SparkContext(conf)
    sys.ShutdownHookThread { sc.stop() }
    val hc = new org.apache.spark.sql.hive.HiveContext(sc)
    import hc.implicits._
    val nodesRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-node.csv").map(_.split(",")).map(n => Node(n(0)))
    val nodes = nodesRDD.toDF
    nodes.registerTempTable("nodes")
    val portsRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-port.csv").map(_.split(",")).map(p => Port(p(0),p(1),p(2),p(3),p(4)))
    val ports = portsRDD.toDF
    ports.registerTempTable("ports")
    val queuesRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-queue.csv").map(_.split(",")).map(q => Queue(q(0),q(1),q(2)))
    val queues = queuesRDD.toDF
    queues.registerTempTable("queues")
    val readingsRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-reading.csv").map(_.split(",")).map(r => Reading(r(0),r(1),r(2),r(3),r(4),r(5)))
    val readings = readingsRDD.toDF
    readings.registerTempTable("readings")
    val dataLoadTime = (System.currentTimeMillis()/1000) - startTime
    println("loading data time: " + dataLoadTime)
    val startTime2 = System.currentTimeMillis()/1000
    val rows = hc.sql("""
        select * from nodes n, ports p, queues q, readings r
          where n.nodeId  = p.nodeId
            and p.nodeId  = q.nodeId
            and q.nodeId  = r.nodeId
            and p.portId  = q.portId
            and q.portId  = r.portId
            and q.queueId = r.queueId
    """)
    val results = rows.collect
    val queryTime = (System.currentTimeMillis()/1000) - startTime2
    println("query time: " + queryTime)
    println("number of results: " + results.length)
    println("total time taken: " + (dataLoadTime + queryTime))
  }
}
