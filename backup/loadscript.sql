set hive.auto.convert.join=true;
set mapred.child.java.opts=-Xmx4096m;
set hive.mapred.local.mem=2000;
set mapred.max.split.size=536870912;
set hive.exec.mode.local.auto=true;
set hive.exec.parallel=true;
set mapred.job.reuse.jvm.num.tasks=10;
drop table if exists geo;
drop table if exists genes;
drop table if exists patients;
create table geo(geneid INT, patientid INT, expr_value FLOAT) clustered by (geneid) sorted by (geneid) into 100 buckets row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;
create index geneid_geo_index on table geo(geneid) as 'compact' with deferred rebuild stored as rcfile;
create index patientid_geo_index on table geo(patientid) as 'compact' with deferred rebuild stored as rcfile;
load data local inpath '/home/condor/alluxio-data/workflows/GenBase-1528255363/scratch/GenBase-1528255363/processed_file/GEO_merge.txt' overwrite into table geo;


create table genes(geneid INT, target INT, pos BIGINT, len INT, func INT) clustered by (geneid) sorted by (geneid) into 100 buckets row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;
create index geneid_genes_index on table genes(geneid) as 'compact' with deferred rebuild stored as rcfile;
load data local inpath '/home/condor/alluxio-data/workflows/GenBase-1528255363/scratch/GenBase-1528255363/processed_file/GM_merge.txt' overwrite into table genes;

create table patients(patientid INT, age INT, gender INT, zipcode INT, disease INT, response FLOAT) clustered by (patientid) sorted by (patientid) into 100 buckets row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;
create index patientid_patients_index on table patients(patientid) as 'compact' with deferred rebuild stored as rcfile;
load data local inpath '/home/condor/alluxio-data/workflows/GenBase-1528255363/scratch/GenBase-1528255363/processed_file/PM_merge.txt' overwrite into table patients;



