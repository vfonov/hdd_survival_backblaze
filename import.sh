#! /bin/sh

# unpack all files
if false;then
  # better do this manually:

  for i in *.zip;do unzip $i;done

  # rearrange all the csv files into subdirectories per year
fi


# create sqlite3 tables
# 2013,2014,2015 are sligtly different, so create separate databases
sqlite3 backblaze_2013.db < docs_2013/create_table.sql
sqlite3 backblaze_2014.db < docs_2014/create_table_2014.sql
sqlite3 backblaze_2015.db < docs_2015/create_table_2015.sql
# starting from 2016 the format is the same
sqlite3 backblaze_2016.db < docs_Q1_2016/create_table_2016.sql


# import individual records for 2013-2015

for i in 2013 2014 2015;do
  for j in $i/????-??-??.csv;do
    sqlite3 backblaze_${i}.db <<END
.mode csv
.import $j drive_stats
delete from drive_stats where model = 'model';
END
  done
done


for i in 2016 2017;do
  for j in $i/????-??-??.csv;do
    sqlite3 backblaze_2016.db <<END
.mode csv
.import $j drive_stats
END
  done
done

sqlite3 backblaze_2016.db <<END
delete from drive_stats where model = 'model';
END




#merge all records into a single one
sqlite3 backblaze_2013_2017.db < docs_Q1_2016/create_table_2016.sql
sqlite3 backblaze_2013_2017.db <<END
attach database "backblaze_2016.db" as bb_2016;
attach database "backblaze_2015.db" as bb_2015;
attach database "backblaze_2014.db" as bb_2014;
attach database "backblaze_2013.db" as bb_2013;

insert into drive_stats select * from bb_2016.drive_stats;
insert into drive_stats select * from bb_2015.drive_stats;


insert into drive_stats(
    date ,
    serial_number ,
    model ,
    capacity_bytes,
    failure ,
    smart_1_normalized ,
    smart_1_raw ,
    smart_2_normalized ,
    smart_2_raw ,
    smart_3_normalized ,
    smart_3_raw ,
    smart_4_normalized ,
    smart_4_raw ,
    smart_5_normalized ,
    smart_5_raw ,
    smart_7_normalized ,
    smart_7_raw ,
    smart_8_normalized ,
    smart_8_raw ,
    smart_9_normalized ,
    smart_9_raw ,
    smart_10_normalized ,
    smart_10_raw ,
    smart_11_normalized ,
    smart_11_raw ,
    smart_12_normalized ,
    smart_12_raw ,
    smart_13_normalized ,
    smart_13_raw ,
    smart_15_normalized ,
    smart_15_raw ,
    smart_183_normalized ,
    smart_183_raw ,
    smart_184_normalized ,
    smart_184_raw ,
    smart_187_normalized ,
    smart_187_raw ,
    smart_188_normalized ,
    smart_188_raw ,
    smart_189_normalized ,
    smart_189_raw ,
    smart_190_normalized ,
    smart_190_raw ,
    smart_191_normalized ,
    smart_191_raw ,
    smart_192_normalized ,
    smart_192_raw ,
    smart_193_normalized ,
    smart_193_raw ,
    smart_194_normalized ,
    smart_194_raw ,
    smart_195_normalized ,
    smart_195_raw ,
    smart_196_normalized ,
    smart_196_raw ,
    smart_197_normalized ,
    smart_197_raw ,
    smart_198_normalized ,
    smart_198_raw ,
    smart_199_normalized ,
    smart_199_raw ,
    smart_200_normalized ,
    smart_200_raw ,
    smart_201_normalized ,
    smart_201_raw ,
    smart_223_normalized ,
    smart_223_raw ,
    smart_225_normalized ,
    smart_225_raw ,
    smart_240_normalized ,
    smart_240_raw ,
    smart_241_normalized ,
    smart_241_raw ,
    smart_242_normalized ,
    smart_242_raw ,
    smart_250_normalized ,
    smart_250_raw ,
    smart_251_normalized ,
    smart_251_raw ,
    smart_252_normalized ,
    smart_252_raw ,
    smart_254_normalized ,
    smart_254_raw ,
    smart_255_normalized ,
    smart_255_raw )
    select 
    date ,
    serial_number ,
    model ,
    capacity_bytes,
    failure ,
    smart_1_normalized ,
    smart_1_raw ,
    smart_2_normalized ,
    smart_2_raw ,
    smart_3_normalized ,
    smart_3_raw ,
    smart_4_normalized ,
    smart_4_raw ,
    smart_5_normalized ,
    smart_5_raw ,
    smart_7_normalized ,
    smart_7_raw ,
    smart_8_normalized ,
    smart_8_raw ,
    smart_9_normalized ,
    smart_9_raw ,
    smart_10_normalized ,
    smart_10_raw ,
    smart_11_normalized ,
    smart_11_raw ,
    smart_12_normalized ,
    smart_12_raw ,
    smart_13_normalized ,
    smart_13_raw ,
    smart_15_normalized ,
    smart_15_raw ,
    smart_183_normalized ,
    smart_183_raw ,
    smart_184_normalized ,
    smart_184_raw ,
    smart_187_normalized ,
    smart_187_raw ,
    smart_188_normalized ,
    smart_188_raw ,
    smart_189_normalized ,
    smart_189_raw ,
    smart_190_normalized ,
    smart_190_raw ,
    smart_191_normalized ,
    smart_191_raw ,
    smart_192_normalized ,
    smart_192_raw ,
    smart_193_normalized ,
    smart_193_raw ,
    smart_194_normalized ,
    smart_194_raw ,
    smart_195_normalized ,
    smart_195_raw ,
    smart_196_normalized ,
    smart_196_raw ,
    smart_197_normalized ,
    smart_197_raw ,
    smart_198_normalized ,
    smart_198_raw ,
    smart_199_normalized ,
    smart_199_raw ,
    smart_200_normalized ,
    smart_200_raw ,
    smart_201_normalized ,
    smart_201_raw ,
    smart_223_normalized ,
    smart_223_raw ,
    smart_225_normalized ,
    smart_225_raw ,
    smart_240_normalized ,
    smart_240_raw ,
    smart_241_normalized ,
    smart_241_raw ,
    smart_242_normalized ,
    smart_242_raw ,
    smart_250_normalized ,
    smart_250_raw ,
    smart_251_normalized ,
    smart_251_raw ,
    smart_252_normalized ,
    smart_252_raw ,
    smart_254_normalized ,
    smart_254_raw ,
    smart_255_normalized ,
    smart_255_raw
    from bb_2014.drive_stats;

    insert into drive_stats(
        date ,
        serial_number ,
        model ,
        capacity_bytes,
        failure ,
        smart_1_normalized ,
        smart_1_raw ,
        smart_2_normalized ,
        smart_2_raw ,
        smart_3_normalized ,
        smart_3_raw ,
        smart_4_normalized ,
        smart_4_raw ,
        smart_5_normalized ,
        smart_5_raw ,
        smart_7_normalized ,
        smart_7_raw ,
        smart_8_normalized ,
        smart_8_raw ,
        smart_9_normalized ,
        smart_9_raw ,
        smart_10_normalized ,
        smart_10_raw ,
        smart_11_normalized ,
        smart_11_raw ,
        smart_12_normalized ,
        smart_12_raw ,
        smart_13_normalized ,
        smart_13_raw ,
        smart_15_normalized ,
        smart_15_raw ,
        smart_183_normalized ,
        smart_183_raw ,
        smart_184_normalized ,
        smart_184_raw ,
        smart_187_normalized ,
        smart_187_raw ,
        smart_188_normalized ,
        smart_188_raw ,
        smart_189_normalized ,
        smart_189_raw ,
        smart_190_normalized ,
        smart_190_raw ,
        smart_191_normalized ,
        smart_191_raw ,
        smart_192_normalized ,
        smart_192_raw ,
        smart_193_normalized ,
        smart_193_raw ,
        smart_194_normalized ,
        smart_194_raw ,
        smart_195_normalized ,
        smart_195_raw ,
        smart_196_normalized ,
        smart_196_raw ,
        smart_197_normalized ,
        smart_197_raw ,
        smart_198_normalized ,
        smart_198_raw ,
        smart_199_normalized ,
        smart_199_raw ,
        smart_200_normalized ,
        smart_200_raw ,
        smart_201_normalized ,
        smart_201_raw ,
        smart_223_normalized ,
        smart_223_raw ,
        smart_225_normalized ,
        smart_225_raw ,
        smart_240_normalized ,
        smart_240_raw ,
        smart_241_normalized ,
        smart_241_raw ,
        smart_242_normalized ,
        smart_242_raw ,
        smart_250_normalized ,
        smart_250_raw ,
        smart_251_normalized ,
        smart_251_raw ,
        smart_252_normalized ,
        smart_252_raw ,
        smart_254_normalized ,
        smart_254_raw ,
        smart_255_normalized ,
        smart_255_raw )
        select 
        date ,
        serial_number ,
        model ,
        capacity_bytes,
        failure ,
        smart_1_normalized ,
        smart_1_raw ,
        smart_2_normalized ,
        smart_2_raw ,
        smart_3_normalized ,
        smart_3_raw ,
        smart_4_normalized ,
        smart_4_raw ,
        smart_5_normalized ,
        smart_5_raw ,
        smart_7_normalized ,
        smart_7_raw ,
        smart_8_normalized ,
        smart_8_raw ,
        smart_9_normalized ,
        smart_9_raw ,
        smart_10_normalized ,
        smart_10_raw ,
        smart_11_normalized ,
        smart_11_raw ,
        smart_12_normalized ,
        smart_12_raw ,
        smart_13_normalized ,
        smart_13_raw ,
        smart_15_normalized ,
        smart_15_raw ,
        smart_183_normalized ,
        smart_183_raw ,
        smart_184_normalized ,
        smart_184_raw ,
        smart_187_normalized ,
        smart_187_raw ,
        smart_188_normalized ,
        smart_188_raw ,
        smart_189_normalized ,
        smart_189_raw ,
        smart_190_normalized ,
        smart_190_raw ,
        smart_191_normalized ,
        smart_191_raw ,
        smart_192_normalized ,
        smart_192_raw ,
        smart_193_normalized ,
        smart_193_raw ,
        smart_194_normalized ,
        smart_194_raw ,
        smart_195_normalized ,
        smart_195_raw ,
        smart_196_normalized ,
        smart_196_raw ,
        smart_197_normalized ,
        smart_197_raw ,
        smart_198_normalized ,
        smart_198_raw ,
        smart_199_normalized ,
        smart_199_raw ,
        smart_200_normalized ,
        smart_200_raw ,
        smart_201_normalized ,
        smart_201_raw ,
        smart_223_normalized ,
        smart_223_raw ,
        smart_225_normalized ,
        smart_225_raw ,
        smart_240_normalized ,
        smart_240_raw ,
        smart_241_normalized ,
        smart_241_raw ,
        smart_242_normalized ,
        smart_242_raw ,
        smart_250_normalized ,
        smart_250_raw ,
        smart_251_normalized ,
        smart_251_raw ,
        smart_252_normalized ,
        smart_252_raw ,
        smart_254_normalized ,
        smart_254_raw ,
        smart_255_normalized ,
        smart_255_raw
        from bb_2013.drive_stats;
END


sqlite3 backblaze_2013_2017.db <<END
create index serial_idx on drive_stats(serial_number);
create index date_idx on drive_stats(date);
create index model_idx on drive_stats(model);

-- total number of drives in db
.echo on
select count(distinct serial_number) from drive_stats;

-- total number of drives with capacity above 1.5T (not boot drives)
select count(distinct serial_number) from drive_stats where 1500000000000 <= capacity_bytes;
END



# summarize the data
sqlite3 backblaze_2013_2017.db <<END
.echo on
CREATE INDEX serial_model_cap ON drive_stats(serial_number,model,capacity_bytes);


-- create summary table
CREATE TABLE drives(
serial_number TEXT NOT NULL primary key,
model TEXT NOT NULL,
capacity_bytes INTEGER (8) NOT NULL,
start,status,age_hrs);

-- PL1331LAGTGMVH corresponds to two models (strangely)

insert into drives(serial_number,model,capacity_bytes) 
    SELECT distinct serial_number, model, max(capacity_bytes)  
    FROM drive_stats 
    WHERE capacity_bytes!='' AND 
          capacity_bytes IS NOT NULL AND 
          capacity_bytes >= 100000000000 AND
          model!='' AND
          serial_number!='' AND
          serial_number!='PL1331LAGTGMVH'
    GROUP BY 1,2;

-- status=0 when drive is censored (didn't fail)
UPDATE drives SET status=0;

-- create index to speed things up
CREATE INDEX serial_smart_9 ON drive_stats(serial_number,smart_9_raw);

-- extract drive life from SMART variable 
CREATE TABLE drive_hours AS 
    SELECT serial_number, max(smart_9_raw) AS age_hrs 
    FROM drive_stats  
    WHERE smart_9_raw is not NULL AND smart_9_raw!='' AND smart_9_raw>0
    GROUP BY 1;

CREATE INDEX drive_hours_serial ON drive_hours(serial_number);
CREATE INDEX drive_serial  ON drive_stats(serial_number);

UPDATE drives SET age_hrs=(SELECT age_hrs FROM drive_hours WHERE drive_hours.serial_number=drives.serial_number);

-- extract info if it failed

CREATE TABLE drive_failure_hrs (serial_number TEXT NOT NULL, age_hrs INTEGER) ;

-- 
INSERT INTO drive_failure_hrs(serial_number,age_hrs) 
  SELECT serial_number, min(smart_9_raw) AS age_hrs 
  FROM drive_stats  
  WHERE smart_9_raw is not NULL AND 
        smart_9_raw!='' AND 
        smart_9_raw>0 AND 
        failure=1 
  GROUP BY 1;
CREATE INDEX drive_failure_hrs_sn ON drive_failure_hrs(serial_number);


-- set age_hrs to the first failure

UPDATE drives SET status=1 WHERE EXISTS 
  (SELECT serial_number FROM drive_failure_hrs WHERE drive_failure_hrs.serial_number=drives.serial_number);

UPDATE drives 
  SET age_hrs=(SELECT age_hrs FROM drive_failure_hrs 
               WHERE drive_failure_hrs.serial_number=drives.serial_number) 
      WHERE drives.status=1;

-- extract the first day of operation


CREATE TABLE starts as SELECT serial_number,MIN(date) FROM drive_stats GROUP BY 1;
CREATE INDEX starts_sn ON starts(serial_number);

UPDATE drives SET start=(SELECT MIN(date) FROM drive_stats WHERE drive_stats.serial_number=drives.serial_number);


-- FIX seagate model name
update drives set model='SEAGATE '||model where model like 'ST%';

END



# extract csv file for future analysis

sqlite3 -csv -header backblaze_2013_2017.db \
   "select serial_number,substr(model,1,instr(model,' ')-1) as make,substr(model,instr(model,' ')+1) as model,status,age_hrs/24.0 as age_days,round(capacity_bytes/1000000000000.0,1) as capacity,start from drives where 1500000000000 <= capacity_bytes" > \
     backblaze_2013_2017_hdd_survival.csv



