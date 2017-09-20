# Datasets

This repo contains datasets that we use in our demos.



## Downloading files from datasets repository
We had problem with reading quiz.csv file directly from its GitHub url. Here's the workaround: first download this file and then import to R, see below.

**Get file url**.
Click on the file name you want to download. 
You need to see raw contents of the file. 
Find button "Raw" and click on it, you will see raw text.
Copy url from browser.

**Download file**. 
First, we create folder called "data". 

```
dir.create("data")
```

Function will issue a warning when dir already exists.

First download file into data directory:
``` 
url <- "https://raw.githubusercontent.com/rstats-tartu/datasets/master/quiz.csv"
download.file(url, "data/quiz.csv")
```

Read file:
```
library(readr)
library(dplyr)
quiz <- read_csv("data/quiz.csv")
quiz
colnames(quiz) <- c("time","education", "supervision", "stats_course",
                    "analysed_data", "proficiency", "junk", "plan_before",
                    "decide_after","publication_bias","publish_all",
                    "collect_more","different_method")
## Let's fix education to numeric
quiz <- mutate_at(quiz, "education", parse_number)
```


