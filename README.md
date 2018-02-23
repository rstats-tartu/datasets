# Datasets

## Estonian statistics databases
Course aims to use datasets published in **Estonian Health Research and Statistics** (TAI) database and also datasets in Statistics Estonia database. [TAI datasets](http://pxweb.tai.ee/PXWeb2015/index_en.html) can be conveniently accessed using boulder package https://tpall.github.io/boulder/. Statistics Estonia data can be downloaded from their [website](http://andmebaas.stat.ee/?lang=et) or accessed using API.

## Downloading files from datasets repository

#### Get file url
Click on the file name you want to download. 
You need to see raw contents of the file. 
Find button "Raw" and click on it, you will see raw text.
Copy url from browser.

#### Download file 
First, we create in our R project folder subdirectory called "data" to host all necessary data files. 

```
dir.create("data")
```

This function will issue a warning when dir already exists.

Download file into "data" directory:
``` 
download.file(url, "data/quiz.csv")
```

#### Import file
```
library(readr)

quiz <- read_csv("data/quiz.csv")
quiz
```
This can be used with all other files too. 
Just change url and file name accordingly.

### Mean annual population

**mean_annual_population.csv**: PO0211 MEAN ANNUAL POPULATION by Sex, Year and Age group dataset is from [Statistics Estonia database](http://pub.stat.ee/px-web.2001/Dialog/varval.asp?ma=PO0211&ti=MEAN+ANNUAL+POPULATION+BY+SEX+AND+AGE+GROUP&path=../I_Databas/Population/01Population_indicators_and_composition/04Population_figure_and_composition/&lang=1).

*"mean_annual_population.csv" was processed from "rawdata/PO0211.csv" using "R/mean_annual_pop.R" script.*

Mean annual population is defined by Statistics Estonia as half the sum number of the population at the beginning and at the end of the year.

#### Download this file

```
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/mean_annual_population.csv"
dir.create("data")
download.file(url, "data/mean_annual_population.csv")
```

#### Import this file
```
library(readr)
pop <- read_csv("data/mean_annual_population.csv")
```

