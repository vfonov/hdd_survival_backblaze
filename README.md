# HDD Survival analysis, based on data from BackBlaze 2013-2017 

## Data preprocessing

Raw data from <https://www.backblaze.com/b2/hard-drive-test-data.html> , was downloaded and summarized with  `import.sh` , the result is stored in `backblaze_2013_2017_hdd_survival.csv`. It contains survival summary of each hard drive found in the database, in the form: `serial_number`,`make`,`model`,`status`,`age_days`,`capacity`,`start` , where 

* `serial_number` - serial number of the hard drive
* `make` - hard drive manufacturer
* `model` - model number
* `status` - `1`: hard drive failed , `0`: hard drive survived past observation window (i.e it was *censored*)
* `age_days` - how old was hard drive in the end, based on smart_9_raw parameter, converted to number of days 
* `capacity` - capacity in TB, rounded to the one significant digit
* `start` - observation start (i.e the earliest day the drive was found in DB)

## Dependencies
* `install.packages(c('tidyverse','survival','survminer','scales'))`

## Survival Analysis

