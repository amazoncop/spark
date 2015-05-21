package robco

/**
 * Created by robert on 11/05/2015
 */

import java.net.URI
import org.apache.hadoop.conf._
import org.apache.hadoop.fs._

object HDFSFileService {
  val conf = new Configuration()
  val fileSystem = FileSystem.get(URI.create("hdfs://localhost:9000/"), conf)
}

object Main extends App {
  val fs = HDFSFileService.fileSystem
  val iterator = fs.listFiles(new Path("/"), true)

  println("Files:")
  while (iterator.hasNext) { println(iterator.next.getPath.getName) }

  val src = new Path("/hosts")
  fs.delete(src, true)

  println("Files:")
  while (iterator.hasNext) { println(iterator.next.getPath.getName) }
  fs.copyFromLocalFile(new Path("/etc/hosts"), new Path("/hosts"))

  println("Files:")
  while (iterator.hasNext) { println(iterator.next.getPath.getName) }
}
