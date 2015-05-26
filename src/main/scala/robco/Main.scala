package robco

/**
 * Created by robert on 11/05/2015
 */

import java.net.URI
import org.apache.hadoop.conf._
import org.apache.hadoop.fs._

object Main {
  def main(args: Array[String]) = {
    val conf = new Configuration()
    val hdfsRoot = args(0)
    val fileSystem = FileSystem.get(URI.create(hdfsRoot), conf)
    val fs = fileSystem
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
}
