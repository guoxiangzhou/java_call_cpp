package java_demo;

public class HelloJNI {
    static {
       System.loadLibrary("add"); // Load native library at runtime
                                    // hello.dll (Windows) or libhello.so (Unixes)
    }
 
    // Declare a native method sayHello() that receives nothing and returns void
    private native int add( int m, int n);
 
    // Test Driver
    public static void main(String[] args) {
      HelloJNI demo = new HelloJNI();
      System.out.println(demo.add(333,333)+"! you have succeed");  // invoke the native method

    }
 }