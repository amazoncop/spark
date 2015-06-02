package robco

import org.apache.spark.{SparkContext, SparkConf}
import org.apache.spark.sql.functions._

object SparkSql3 {
  case class Info(node: String, port: String, id: String)
  case class Data(id: String, timestamp: String, value: String)

  def main(args: Array[String]) = {
    val sparkMaster = "spark://" + args(0) + ":7077"
    val hdfsRoot = "hdfs://" + args(1) + ":9000"
    val conf = new SparkConf().setMaster(sparkMaster)
    val sc = new SparkContext(conf)
    println("sparMaster: " + sparkMaster)
    println("hdfsroot: " + hdfsRoot)
    sys.ShutdownHookThread { sc.stop() }
    val hc = new org.apache.spark.sql.hive.HiveContext(sc)
    import hc.implicits._
    sc.textFile(s"$hdfsRoot/data-schema-app2-info.csv").map(_.split(",")).map(i => Info(i(0),i(1),i(2))).toDF.registerTempTable("info")
    sc.textFile(s"$hdfsRoot/data-schema-app2-data.csv").map(_.split(",")).map(d => Data(d(0),d(1),d(2))).toDF.registerTempTable("data")
    val startTime2 = System.currentTimeMillis()/1000
    val rows = hc.sql("""
        SELECT i.*, d.*
        FROM info i, data d
        WHERE i.id = d.id
    """)
    val results = rows.collect()
    println("number of results: " + results.length)
  }
}

