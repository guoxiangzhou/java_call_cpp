#include "java_demo_HelloJNI.h"
#include "add_two.h"

JNIEXPORT jint JNICALL Java_java_1demo_HelloJNI_add
  (JNIEnv *env, jobject obj, jint x, jint y){
    zjx::add_two demo_add;
    demo_add.x = (int)x;
    demo_add.y = (int)y;
    return (jint)demo_add.add();
  }
