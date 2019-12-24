class Sample {
    // --- Native methods
    @native def add(n: Int,m: Int): Int
}
//伴生对象 ，staic
object Sample {
    //此处相当于java的 static方法块
    System.loadLibrary("add")
    
    def main(args: Array[String]) {
        val sample = new Sample
        val result = sample.add(333,333)
        print(result)
        println("! You succeed!")
    }
}