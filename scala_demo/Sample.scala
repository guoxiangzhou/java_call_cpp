class Sample {
    // --- Native methods
    @native def Sayhello()
}
//伴生对象 ，staic
object Sample {
    //此处相当于java的 static方法块
    System.loadLibrary("hello")
    
    def main(args: Array[String]) {
        val sample = new Sample
        sample.Sayhello()
    }
}