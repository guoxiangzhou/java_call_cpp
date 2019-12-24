# 如何在Java和Scala中使用JNI调用c++动态库.so
本文所用的全部样例demo已经同步上传至github(https://github.com/zhangjiaxinghust/java_call_cpp)，样例在ubuntu16.04下均有一键运行脚本，可以运行感受一下，下面我们就根据这四个样例来介绍JNI的使用，方便大家后续在Java和Scala工程中直接调用外部动态链接库。
## JNI介绍
众所周知，JAVA和SCALA都运行在`JVM`之上，具有跨平台的特点，给我们编程带来了很大的方便，但是呢这样带来的一个弊病就是他与本地其他代码（c/c++）交互能力非常弱，尤其是一些和操作系统相关的特性（例如cuda很难使用，因为很难调用操作系统级gpu），于是呢JAVA官方为了解决这一问题推出了一个解决方案`Java Native Interface`，即Java本地接口。通过这个接口呢我们就可以调用由c++和c语言生成的库文件，也即是此时外部链接库在本地运行，并不在Java虚拟机内部运行，与此同时这样的Java程序将失去了跨平台特性，JNI接口环境和动态库在不同的环境下是不尽相同的，在不同环境下需要重新编译！JNI对于应用本身来说可以看做一个代理模式，对于开发者来说需要使用c/c++来实现一个代理程序来完成一些操作，JVM呢实际通过jni提供的接口来运行这个代理程序，JNI接口的接口是跟平台有关的，代理程序也是跟平台有关的。所以我们就只需要关注两个点：JVM如何调用jni接口？代理程序如何跟这个接口适配？
## JAVA使用JNI简单样例
具体项目见github目录下`java_demo`工程。现在呢我们想在Java中调用c++的一个库中的`sayhello（）`函数，函数功能就是打印字符串`Hello,you succeed!`。于是呢我们就在Java文件中作如下声明：
```
package java_demo;
public class HelloJNI {
    static {
       System.loadLibrary("hello"); // Load native library at runtime
                                    // hello.dll (Windows) or libhello.so (Unixes)
    }
 
    // Declare a native method sayHello() that receives nothing and returns void
    private native void sayHello();
 
    // Test Driver
    public static void main(String[] args) {
       new HelloJNI().sayHello();  // invoke the native method
    }
 }
```
我们新建了一个class `HelloJNI`，里面声明另一个函数`sayhello`，这个函数加了native限定符，表示函数体不在程序内部，仅作声明，也就是定义了Java与C++通信的接口，我要使用外部动态库的一个名叫`sayhello`的函数了！同时我们采用静态导入库的方法，用了`static`关键字，当然你也可以在后续在具体使用到这个函数的时候加载动态库，都可以！下面定义了一个main函数，做做测试之用，测试这个接口函数是否可以正常被调用！  
好，我们在Java中已经把接口定义好了连库都搞好了我c++程序怎么写呢？难道只需要在动态库中存在同样声明的函数名称和类型就OK么？  
答案是否定的，因为JNI调用的接口必须是按照JNI定义的来，c++那一套他根本不吃。首先呢我们需要用`javah`命令导出JNI定义的`.h`头文件。运行下面命令：
```
javac -d . HelloJNI.java
javah java_demo.HelloJNI
```
你会发现在目录下多了一个`java_demo_HelloJNI.h`的头文件，这个就是JNI预先定义的头文件，也就是说，你这个动态库里面的必须要实现我这个头文件里面定义的函数。打开这个头文件，发现了JNI定义的函数原型，因此我们只需要在我们的动态库中实现这个函数就Ok了。
```
JNIEXPORT void JNICALL Java_java_1demo_HelloJNI_sayHello
  (JNIEnv *, jobject);
```
打开它一看不像一般的c/c++函数声明，我们不用管直接把这个copy进一个cpp文件实现这个函数即可，下面是我的实现：`interface.cpp`
```
#include "java_demo_HelloJNI.h"
#include "hello.h"

JNIEXPORT void JNICALL Java_java_1demo_HelloJNI_sayHello
  (JNIEnv *, jobject){
      zjx::printstring demo;
      demo.x="Hello,you succeed!";
      demo.x_out();
  }
```
剩余的c++头文件和cpp文件实现非常简单，在此不做赘述！  
完成之后我们把我们的c++工程编译为动态库（已经用cmake写好），然后运行Java程序就可以看到输出了！
```
java  -Djava.library.path=src java_demo.HelloJNI
```
值得注意的是，我们在运行Java程序的时候需要指定我们动态库所在的目录，只有这样程序才能够正确找到动态库的位置！  
PS：SCALA用法与JAVA用法大同小异，工程（scala_demo）已经同步上传，可以自行查看`build.sh`的差异，在此不做赘述！
## JAVA稍复杂例子java_demo_cuda
可以看到，上面调用的`sayhello`函数，不需要任何的参数，实在太过简陋，那么我们再实现一个函数来进一步探寻jni的奥义！  
我们实现一个两个数相加的函数`int add( int m, int n)`，并将这个函数使用cuda实现。`HelloJNI.java`
```
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
```
我们使用`javah`命令生成`.h`文件函数定义如下：
```
JNIEXPORT jint JNICALL Java_java_1demo_HelloJNI_add
  (JNIEnv *, jobject, jint, jint);
```
我们实现这样一个函数原型即可，实现非常简单，工程已经给出，但是我们发现以下声明：JNIEnv，jobject，jint，并且通过大量编程我们得知，第一个参数永远是JNIEnv，第二个永远是jobject和jclass的一个，那么这些变量究竟是什么呢？又该如何理解呢？  
### JNIENV
JNIEnv，顾名思义，指代了Java本地接口环境(Java Native Interface Environment），是一个JNI接口指针，指向了本地方法的一个函数表，该函数表中的每一个成员指向了一个JNI函数，本地方法通过JNI函数来访问JVM中的数据结构。


