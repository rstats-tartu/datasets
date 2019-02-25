# Datasets

This repo contains datasets that we use in our demos.

## Downloading files from datasets repository
We had problem with reading quiz.csv file directly from its GitHub url:

```
library(readr)
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/quiz.csv"
quiz <– read_csv(url)
```
For some people using `read_csv()` directly with url gave an error.
Here's simple workaround: first download this quiz.csv file and then import to R, see below. 

**Get file url**.
Click on the file name you want to download. 
You need to see raw contents of the file. 
Find button "Raw" and click on it, you will see raw text.
Copy url from browser.

**Download file**. 
First, we create folder called "data" to host all necessary data files. 

```
dir.create("data")
```

Function will issue a warning when dir already exists.

First download file into "data" directory:
``` 
download.file(url, "data/quiz.csv")
```

**Read file**:
```
library(readr)
library(dplyr)

quiz <- read_csv("data/quiz.csv")
quiz
```
This can be used with all other files too. 
Just change url and file name accordingly.


Imported **quiz data** needs some munging:
```
colnames(quiz) <- c("time","education", "supervision", "stats_course",
                    "analysed_data", "proficiency", "junk", "plan_before",
                    "decide_after","publication_bias","publish_all",
                    "collect_more","different_method")

## Let's fix education to numeric
quiz <- mutate_at(quiz, "education", parse_number)

## Remove one non-question
quiz <- select(quiz, -junk)
quiz
```

**Download and import json file**:

Cancer datasets from [Estonian Health Statistics database](http://pxweb.tai.ee/PXWeb2015/index_en.html):

- "cancer_newcases_PK10.json", PK10: New cases of malignant neoplasms by specified site, sex and age group.

- "cancer_incidence_PK30.json", PK30: Age-specific incidence rate of malignant neoplasms per 100 000 inhabitants by site and sex.

**Download** "cancer_newcases_PK10.json" file from this GitHub repo ("rstats-tartu/datasets") similarly as shown above:
```
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/cancer_newcases_PK10.json"
dir.create("data")
download.file(url, "data/cancer_newcases_PK10.json")
```

**To import** this downloaded file into R you can use "boulder" package function `json_to_df()`:
```
# devtools::install_github("tpall/boulder")
library(boulder)
path <- "data/cancer_newcases_PK10.json"
incidence <- json_to_df(path)
incidence
```

## Average monthly wage with additional payments

**healthcare_personnel_salary.tsv** contains data about "average monthly wage with additional payments" of full- and part-time health care personnel for different occupations from all age groups [Estonian Health Statistics database](http://pxweb.tai.ee/PXWeb2015/pxweb/en/04THressursid/04THressursid__06THTootajatePalk/TT09.px/table/tableViewLayout2/?rxid=466b62f2-f258-4e9a-9590-4a4ac41c7513). Values are in euros.


**Download this file**:
```
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/healthcare_personnel_salary.tsv"
dir.create("data")
download.file(url, "data/healthcare_personnel_salary.tsv")
```
**Import this file**:
```
library(readr)
salary <- read_tsv("data/healthcare_personnel_salary.tsv")
```

## Mean annual population

**mean_annual_population.csv**: PO0211 MEAN ANNUAL POPULATION by Sex, Year and Age group dataset is from [Statistics Estonia database](http://pub.stat.ee/px-web.2001/Dialog/varval.asp?ma=PO0211&ti=MEAN+ANNUAL+POPULATION+BY+SEX+AND+AGE+GROUP&path=../I_Databas/Population/01Population_indicators_and_composition/04Population_figure_and_composition/&lang=1).

*"mean_annual_population.csv" was processed from "rawdata/PO0211.csv" using "R/mean_annual_pop.R" script.*

Mean annual population is defined by Statistics Estonia as half the sum number of the population at the beginning and at the end of the year.

**Download this file**:

```
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/mean_annual_population.csv"
dir.create("data")
download.file(url, "data/mean_annual_population.csv")
```
**Import this file**:
```
library(readr)
pop <- read_csv("data/mean_annual_population.csv")
```

## Transactions with residential apartments
The source of this dataset is Estonian Land Board transactions database: http://www.maaamet.ee/kinnisvara/htraru/FilterUI.aspx. 
Dataset was downloaded and processed using 'R/maaamet.R' script.

Download this file to your projects data folder.
```
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/transactions_residential_apartments.csv"
dir.create("data")
download.file(url, "data/transactions_residential_apartments.csv")
```

```
library(readr)
apartments <- read_csv("data/transactions_residential_apartments.csv")
```

## Virus datasets

`viruses.csv` virus genome summary dataset was downloaded from NCBI ftp site ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/viruses.txt and cleaned up with `R/download_virus_genomes_info.R` script.   

```
> viruses
# A tibble: 28,740 x 15
   organism_name tax_id bioproject_acce~ bioproject_id group subgroup size_kb    gc host 
   <chr>          <int> <chr>                    <int> <chr> <chr>      <dbl> <dbl> <chr>
 1 Escherichia ~ 1.44e6 PRJNA485481             485481 dsDN~ Podovir~   76.2   42.4 bact~
 2 Enterovirus J 1.33e6 PRJNA485481             485481 ssRN~ Picorna~    7.35  45.3 vert~
 3 Bacilladnavi~ 2.27e6 PRJNA393166             393166 ssDN~ Bacilla~    5.27  45.9 diat~
 4 Invertebrate~ 1.30e6 PRJNA485481             485481 dsDN~ Iridovi~  205.    30.3 inve~
 5 Invertebrate~ 3.46e5 PRJNA485481             485481 dsDN~ Iridovi~  199.    28.1 inve~
 6 Bacillus pha~ 1.41e6 PRJNA485481             485481 dsDN~ Siphovi~   80.4   35.2 bact~
 7 Salmonella p~ 1.41e6 PRJNA485481             485481 dsDN~ Ackerma~  155.    45.6 bact~
 8 Brevibacillu~ 1.30e6 PRJNA485481             485481 dsDN~ Myoviri~   45.8   39.1 bact~
 9 Mycobacteriu~ 1.08e6 PRJNA485481             485481 dsDN~ Siphovi~   59.7   66.6 bact~
10 Mycobacteriu~ 1.07e6 PRJNA485481             485481 dsDN~ Siphovi~   57.4   61.4 bact~
# ... with 28,730 more rows, and 6 more variables: segments <chr>, genes <chr>, proteins <chr>,
#   release_date <date>, modify_date <date>, status <chr>
```

`virus_genome_tables.csv` is cleaned up virus and host database from https://www.genome.jp/viptree.    

```
> genome_tables
# A tibble: 9,274 x 13
   ID     taxid  taxid2  length name     nuctype Htaxid Hname    Vfamily Hgroup  hosttype seq_ids order
   <chr>  <chr>  <chr>   <chr>  <chr>    <chr>   <chr>  <chr>    <chr>   <chr>   <chr>    <chr>   <chr>
 1 KF981~ 14533~ 145333~ 95702  Mycobac~ dsDNA   1762   -        Siphov~ -       Prokary~ KF9818~ 1    
 2 NC_02~ 13279~ 132795~ 95705  Mycobac~ dsDNA   1762   -        Siphov~ -       Prokary~ NC_023~ 2    
 3 NC_00~ 173824 173824~ 31007  Methano~ dsDNA   145261 Methano~ Siphov~ Euryar~ Prokary~ NC_002~ 3    
 4 NC_00~ 77048  77048-1 26111  Methano~ dsDNA   2159   -        Siphov~ -       Prokary~ NC_001~ 4    
 5 NC_03~ 16472~ 164728~ 83324  Gordoni~ dsDNA   410332 Gordoni~ Siphov~ Actino~ Prokary~ NC_030~ 5    
 6 NC_02~ 15669~ 156699~ 71200  Arthrob~ dsDNA   1667   Arthrob~ Myovir~ Actino~ Prokary~ NC_026~ 6    
 7 NC_03~ 17969~ 179699~ 51290  Arthrob~ dsDNA   17719~ Arthrob~ Myovir~ Actino~ Prokary~ NC_031~ 7    
 8 NC_01~ 11832~ 118323~ 43788  Salisae~ dsDNA   10897~ Salisae~ -       Bacter~ Prokary~ NC_017~ 8    
 9 NC_01~ 491893 491893~ 34952  Abalone~ dsDNA   37770  Halioti~ -       Mollus~ Eukaryo~ NC_011~ 9    
10 NC_03~ 18159~ 181596~ 103445 Salmone~ dsDNA   286783 Salmone~ Myovir~ Gammap~ Prokary~ NC_031~ 10   
# ... with 9,264 more rows
```


`virushostdb.tsv` is the original source for the `virus_genome_tables.csv` data, downloaded from ftp://ftp.genome.jp.   


`virus_genome_tables.csv` and `virushostdb.tsv` were generated with `R/download_virus_genome_tables.R` script.


