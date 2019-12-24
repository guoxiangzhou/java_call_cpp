javac -d . HelloJNI.java
javah java_demo.HelloJNI
cd src
cmake ./
make 
cd ..
java  -Djava.library.path=src java_demo.HelloJNI