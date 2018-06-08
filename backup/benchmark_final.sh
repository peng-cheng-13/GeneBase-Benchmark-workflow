#!/bin/bash  

# run as follows: 
# benchmark_final.sh geomatrix_rows geomatrix_cols covar|svd
 
result_file=run-$1-$2-$3.txt
hive_path=hive
orig_data_path=./data/
#processed_data_path=/hive/
processed_data_path=./processed_data
#class_path=hadoop-core-1.2.1.jar:mahout-core-0.7.jar:mahout-math-0.7.jar:commons-logging-1.1.1.jar:commons-configuration-1.6.jar:commons-lang-2.4.jar:guava-r09.jar:.
class_path=.:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/hadoop-common-2.7.3.jar:$HADOOP_HOME/share/hadoop/hdfs/hadoop-hdfs-2.7.3.jar:$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.7.3.jar:$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-common-2.7.3.jar:$MAHOUT_HOME/mahout-core-0.8.jar:$MAHOUT_HOME/mahout-math-0.13.jar:$HADOOP_HOME/share/hadoop/common/lib/commons-configuration-1.6.jar:$HADOOP_HOME/share/hadoop/common/lib/commons-lang-2.6.jar:$HADOOP/share/hadoop/common/lib/guava-11.0.2.jar
hadoop_path=alluxio
mahout_path=mahout
hdfs_data_path=/genbase
hive_setup="${hive_setup}set mapred.max.split.size=67108864;set hive.exec.mode.local.auto=true;set hive.exec.parallel=true;set mapred.job.reuse.jvm.num.tasks=10;set hive.mapred.local.mem=4000;set hive.auto.convert.join=true;"

# load data
source ./load_final.sh

if [ $3 == "covar" ]
  then
    source ./covar.sh
fi

if [ $3 == "svd" ]
  then
    source ./svd.sh
fi

if [ $3 == "qr" ]
then
	source ./qr.sh
fi
