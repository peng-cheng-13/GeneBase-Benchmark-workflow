#!/bin/bash
echo "QR"

$hadoop_path fs rm -R ${hdfs_data_path}*result
$hadoop_path fs copyFromLocal ${processed_data_path}GEO-$1-$2-svd.txt_mahout ${hdfs_data_path}GEO-$1-$2-svd.txt_mahout

start_time=$(date +%s)
echo "--------Spark-matrix-qr----"
spark-submit genbase-spark.jar -master=spark://172.18.11.5:7077 -app=qr -inputFile=${hdfs_data_path}GEO-$1-$2-svd.txt_mahout
end_time=$(date +%s)
echo "Time for spark: covar: $(($end_time - $start_time))" >> $result_file
