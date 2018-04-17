library(tidyverse)
library(glue)
library(rvest)
library(crul)
library(stringr)
library(lubridate)

al <- format(start, "%d.%m.%Y")
lo <- format(end, "%d.%m.%Y")

maaamet_query <- function(start, end, by = c('month', 'day'), aru = "T13", ehak = "EEMK") {
  by <- match.arg(by)
  start <- seq(start, end, by = by)
  
  if (by == 'month') {
    end <- start + months(1) - days(1)
  } else {
    end <- start + days(1)
  }
  url <- "http://www.maaamet.ee/kinnisvara/htraru/Start.aspx"
  x <- HttpClient$new(url = url)
  pmap(list(aru, ehak, format(start, "%d.%m.%Y"), format(end, "%d.%m.%Y")), 
       ~x$get(query = list(aru = ..1, ehak = ..2, algus = ..3, lopp = ..4), timeout_ms = 10000))
}

periods <- data_frame(start = seq(dmy('01-01-2005'), dmy('01-01-2018'), by = '2 years'),
                      end = seq(dmy('01-12-2006'), dmy('01-12-2018'), by = '2 years'))
periods <- periods %>% 
  mutate(resp = map2(start, end, maaamet_query))

periods_unnested <- periods %>% 
  unnest()

resp <- periods_unnested$resp[[1]]$parse()
tabs <- readHTMLTable(resp)
tabel <- tabs$aruTable[-1,]

header <- tabs$aruTable[1,]
headers <- sapply(header, as.character)
headers[1] <- "Maakond"
colnames(tabel) <- make.names(headers)
tabel
