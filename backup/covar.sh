echo "--------Subsetting data--------"
processed_data_path=./processed_data
hdfs_data_path=/genbase
hive_path=hive
start_time=$(date +%s)
echo "Start time: ${start_time}" >> $result_file
$hive_path -e "${hive_setup}drop table if exists geo_subset;drop table if exists expr_avgs;set hive.index.compact.file=/tmp/patientid_geo_index;create table geo_subset as select geo.* from patients join geo on (geo.patientid=patients.patientid) where patients.disease = 5;"

echo "--------Normalize data--------"
$hive_path -e "${hive_setup}set hive.index.compact.file=/tmp/geneid_geo_index;create table expr_avgs as select geneid, avg(expr_value) as avg_expr_value from geo_subset group by geneid; select g.patientid, g.geneid, g.expr_value-y.avg_expr_value from geo_subset g join expr_avgs y on (g.geneid=y.geneid);" > "${processed_data_path}/GEO-$1-$2-covar.txt"
end_time=$(date +%s)
echo "Time for data management : subsetting and normalize : $(($end_time - $start_time))" >> $result_file

echo "--------Format data for mahout--------"
if [ ! -e ${processed_data_path}GEO-$1-$2-covar.txt_mahout ]; then
        python format_data_for_mahout.py "${processed_data_path}/GEO-$1-$2-covar.txt" "${processed_data_path}"
fi


#$hadoop_path dfs -rmr ${hdfs_data_path}*result
#$hadoop_path dfs -copyFromLocal ${processed_data_path}GEO-$1-$2-covar.txt_mahout ${hdfs_data_path}GEO-$1-$2-covar.txt_mahout
alluxio fs copyFromLocal ${processed_data_path}/GEO-$1-$2-covar.txt_mahout ${hdfs_data_path}/GEO-$1-$2-covar.txt_mahout
start_time=$(date +%s)
echo "--------Spark-matrix-svd----"
spark-submit genbase-spark.jar  -app=covar -inputFile=${hdfs_data_path}/GEO-$1-$2-covar.txt_mahout
end_time=$(date +%s)
echo "Time for spark: covar: $(($end_time - $start_time))" >> $result_file
