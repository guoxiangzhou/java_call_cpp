#include "Sample.h"
#include "hello.h"

JNIEXPORT void JNICALL Java_Sample_Sayhello
  (JNIEnv *, jobject){
      zjx::printstring demo;
      demo.x="Hello,you succeed!";
      demo.x_out();
  }
