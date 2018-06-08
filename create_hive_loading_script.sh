#!/bin/bash

# args: size1 size2 directory_with_processed_data
echo "set hive.auto.convert.join=true;"
#echo "set mapred.child.java.opts=-Xmx4096m;"
#echo "set hive.mapred.local.mem=4000;"
#echo "set hive.auto.convert.join=true;"
echo "set mapred.child.java.opts=-Xmx4096m;"
echo "set hive.mapred.local.mem=2000;"
echo "set mapred.max.split.size=536870912;"
echo "set hive.exec.mode.local.auto=true;"
echo "set hive.exec.parallel=true;"
echo "set mapred.job.reuse.jvm.num.tasks=10;"

echo "drop table if exists geo;"
echo "drop table if exists genes;"
echo "drop table if exists patients;"

# geo data table
echo "create table geo(geneid INT, patientid INT, expr_value FLOAT) clustered by (geneid) sorted by (geneid) into 100 buckets row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;"

echo "create index geneid_geo_index on table geo(geneid) as 'compact' with deferred rebuild stored as rcfile;"

echo "create index patientid_geo_index on table geo(patientid) as 'compact' with deferred rebuild stored as rcfile;"

echo "load data local inpath '${3}/GEO_merge.txt' overwrite into table geo;"

#echo "alter index geneid_geo_index on geo rebuild;"

#echo "alter index patientid_geo_index on geo rebuild;"

# gene metadata table
echo "create table genes(geneid INT, target INT, pos BIGINT, len INT, func INT) clustered by (geneid) sorted by (geneid) into 100 buckets row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;"

echo "create index geneid_genes_index on table genes(geneid) as 'compact' with deferred rebuild stored as rcfile;"

echo "load data local inpath '${3}/GM_merge.txt' overwrite into table genes;"

#echo "alter index geneid_genes_index on genes rebuild;"

# patient metadata table
echo "create table patients(patientid INT, age INT, gender INT, zipcode INT, disease INT, response FLOAT) clustered by (patientid) sorted by (patientid) into 100 buckets row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;"

echo "create index patientid_patients_index on table patients(patientid) as 'compact' with deferred rebuild stored as rcfile;"

echo "load data local inpath '${3}/PM_merge.txt' overwrite into table patients;"

#echo "alter index patientid_patients_index on patients rebuild;"

# get the indexes
#echo 'insert overwrite directory "/tmp/patientid_geo_index" select `_bucketname`, `_offsets` from default__geo_patientid_geo_index__;'

#echo 'insert overwrite directory "/tmp/geneid_geo_index" select `_bucketname`, `_offsets` from default__geo_geneid_geo_index__;'
