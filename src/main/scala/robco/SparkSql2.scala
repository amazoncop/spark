package robco

import org.apache.spark.{SparkContext, SparkConf}

object SparkSql2 {
  // case class Person(firstName: String, lastName: String, gender: String)
  case class AvcInfo(avcId: String, cvcId: String)
  case class AvcData(avcId: String, octetsIn: String, octetsOut: String)

  def main(args: Array[String]) = {
    val sparkMaster = "spark://" + args(0) + ":7077"
    val hdfsRoot = "hdfs://" + args(1) + ":9000"
    val startTime = System.currentTimeMillis()/1000
    val conf =
        new SparkConf().setMaster(sparkMaster)
            .set("spark.driver.memory", "6G")
            .set("spark.storage.memoryFraction", "0.6")
            .set("spark.executor.memory", "6G")
    val dataset = args(2)
    val sc = new SparkContext(conf)
    sys.ShutdownHookThread { sc.stop() }
    val hc = new org.apache.spark.sql.hive.HiveContext(sc)
    import hc.implicits._
    val avcsRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-avcInfo.csv").map(_.split(",")).map(a => AvcInfo(a(0),a(1)))
    val avcs = avcsRDD.toDF
    avcs.registerTempTable("avcs")
    val avcDataRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-avcData.csv").map(_.split(",")).map(a => AvcData(a(0),a(1),a(2)))
    val avcData = avcDataRDD.toDF
    avcData.registerTempTable("avcData")
    val dataLoadTime = (System.currentTimeMillis()/1000) - startTime
    println("loading data time: " + dataLoadTime)
    val startTime2 = System.currentTimeMillis()/1000
    val rows = hc.sql("""
        SELECT a.*, ad.*
        FROM avcs a, avcData ad
        WHERE a.avcId = ad.avcId
    """)
    val results = rows.collect
    val queryTime = (System.currentTimeMillis()/1000) - startTime2
    println("query time: " + queryTime)
    println("number of results: " + results.length)
    println("total time taken: " + (dataLoadTime + queryTime))
  }
}
