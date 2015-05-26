name := "spk1"

version := "1.0"

val hadoopVersion = "2.0.0-cdh4.2.0"

resolvers += "Cloudera Repository" at "https://repository.cloudera.com/artifactory/cloudera-repos/"

libraryDependencies ++= Seq(
  "org.apache.hadoop" % "hadoop-client" % hadoopVersion % "provided" exclude("commons-daemon", "commons-daemon"),
  "org.apache.hadoop" % "hadoop-hdfs" % hadoopVersion % "provided" exclude("commons-daemon", "commons-daemon"),
  "org.apache.hadoop" % "hadoop-common" % hadoopVersion % "provided" exclude("commons-daemon", "commons-daemon"),
  "org.apache.spark" %% "spark-core" % "1.3.1" % "provided" exclude("commons-daemon", "commons-daemon"),
  "org.apache.spark" %% "spark-streaming" % "1.3.1" % "provided" exclude("commons-daemon", "commons-daemon"),
  "org.apache.spark" %% "spark-sql" % "1.3.1" % "provided" exclude("commons-daemon", "commons-daemon"),
  "org.apache.spark" %% "spark-hive" % "1.3.1" % "provided" exclude("commons-daemon", "commons-daemon"),
  "commons-daemon" % "commons-daemon" % "1.0.3" from "http://repo1.maven.org/maven2/commons-daemon/commons-daemon/1.0.3/commons-daemon-1.0.3.jar" exclude("commons-daemon", "commons-daemon"),
  "com.typesafe" % "config" % "1.2.0" exclude("commons-daemon", "commons-daemon")
)
