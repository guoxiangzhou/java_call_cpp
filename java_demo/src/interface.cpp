#include "java_demo_HelloJNI.h"
#include "hello.h"

JNIEXPORT void JNICALL Java_java_1demo_HelloJNI_sayHello
  (JNIEnv *, jobject){
      zjx::printstring demo;
      demo.x="Hello,you succeed!";
      demo.x_out();
  }
