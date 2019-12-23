scalac Sample.scala
export SCALA_LIB_HOME=/usr/share/scala-2.11/lib/
export SCALA_CP=$SCALA_LIB_HOME/scala-library.jar:$SCALA_LIB_HOME/scala-reflect.jar  
javah -cp $SCALA_CP:. Sample
cd src
cmake ./
make 
cd ..
scala -Djava.library.path=src Sample