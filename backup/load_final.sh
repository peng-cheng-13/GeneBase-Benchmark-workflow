#!/bin/bash
orig_data_path=$3
processed_data_path=$4
# create dir to store input data and hdfs data
echo "--------Made dirs--------"
mkdir -p "$processed_data_path"

# format data for hive
echo "--------Format data for hive--------"
if [ ! -e ${processed_data_path}/GEO-$1-$2.txt ] 
then
	echo "have to format data"
	python format_data_for_hive.py ${orig_data_path}/GEO-$1-$2.txt $processed_data_path
	python format_data_for_hive.py ${orig_data_path}/GeneMetaData-$1-$2.txt $processed_data_path
	python format_data_for_hive.py ${orig_data_path}/PatientMetaData-$1-$2.txt $processed_data_path
	echo "--------Creating tables and loading data into hive"
	./create_hive_loading_script.sh $1 $2 $processed_data_path > loadscript-$1-$2.sql

	#$hive_path -f loadscript-$1-$2.sql
fi
