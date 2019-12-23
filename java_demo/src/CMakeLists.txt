cmake_minimum_required(VERSION 3.15)

PROJECT(test_hello)
add_compile_options(-fPIC)
if(NOT DEFINED ENV{JAVA_HOME})
    message(FATAL_ERROR "not defined environment variable:JAVA_HOME")  
endif()
set(JNI_INCLUDE "$ENV{JAVA_HOME}/include")
include_directories(${JNI_INCLUDE})
include_directories("${JNI_INCLUDE}/linux")
INCLUDE_DIRECTORIES(
_code/header
../
)
add_subdirectory(_code _interface)
AUX_SOURCE_DIRECTORY(. DIR_INTERFACE)
SET(TEST_HELLO
${DIR_INTERFACE}
)

ADD_LIBRARY(hello SHARED ${TEST_HELLO})
TARGET_LINK_LIBRARIES( hello Test1 )