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

Download "cancer_incidence_PK30.json" file from this GitHub repo ("rstats-tartu/datasets") similarly as shown above:
```
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/cancer_incidence_PK30.json"
dir.create("data")
download.file(url, "data/cancer_incidence_PK30.json")
```

To import this downloaded file into R you can use "boulder" package function `json_to_df()`:
```
# devtools::install_github("tpall/boulder")
library(boulder)
path <- "data/cancer_incidence_PK30.json"
incidence <- json_to_df(path)
incidence
```

## Average monthly wage with additional payments

healthcare_personnel_salary.tsv contains data about "average monthly wage with additional payments" of full- and part-time health care personnel for different occupations from all age groups [Estonian Health Statistics database](http://pxweb.tai.ee/PXWeb2015/pxweb/en/04THressursid/04THressursid__06THTootajatePalk/TT09.px/table/tableViewLayout2/?rxid=466b62f2-f258-4e9a-9590-4a4ac41c7513).


Download this file
```
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/healthcare_personnel_salary.tsv"
dir.create("data")
download.file(url, "data/healthcare_personnel_salary.tsv")
```

```
library(readr)
salary <- read_tsv("healthcare_personnel_salary.tsv")
```
