package robco

import org.apache.spark.{SparkContext, SparkConf}
import org.apache.spark.sql.functions._

object SparkSql2 {
  // case class Person(firstName: String, lastName: String, gender: String)
  case class CvcInfo(cvcId: String, description: String)
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
            .set("spark.driver.maxResultSize", "4G")
    val dataset = args(2)
    val sc = new SparkContext(conf)
    sys.ShutdownHookThread { sc.stop() }
    val hc = new org.apache.spark.sql.hive.HiveContext(sc)
    import hc.implicits._
    val cvcInfoRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-cvcInfo.csv").map(_.split(",")).map(a => CvcInfo(a(0),a(1)))
    val avcInfoRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-avcInfo.csv").map(_.split(",")).map(a => AvcInfo(a(0),a(1)))
    val avcDataRDD = sc.textFile(s"$hdfsRoot/data-schema-$dataset-avcData.csv").map(_.split(",")).map(a => AvcData(a(0),a(1),a(2)))
    val cvcInfo = cvcInfoRDD.toDF
    val avcInfo = avcInfoRDD.toDF
    val avcData = avcDataRDD.toDF
    cvcInfo.registerTempTable("cvcInfo")
    avcInfo.registerTempTable("avcInfo")
    avcData.registerTempTable("avcData")
    val dataLoadTime = (System.currentTimeMillis()/1000) - startTime
    println("loading data time: " + dataLoadTime)
    val startTime2 = System.currentTimeMillis()/1000
    val rows = hc.sql("""
        SELECT ai.*, ad.*, ci.*
        FROM avcInfo ai, avcData ad, cvcInfo ci
        WHERE ad.avcId = ai.avcId AND
              ai.cvcId = ci.cvcId
    """)
    val results = rows.groupBy(cvcInfo.col("cvcId")).agg(cvcInfo.col("cvcId"), sum(avcData.col("octetsOut"))).collect
    val queryTime = (System.currentTimeMillis()/1000) - startTime2
    println("query time: " + queryTime)
    println("total time taken: " + (dataLoadTime + queryTime))
    results.foreach(println)
    println("number of results: " + results.length)
  }
}




