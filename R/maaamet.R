# https://speakerdeck.com/jennybc/new-tools-and-workflows-for-data-analysis?slide=8
# https://speakerdeck.com/jennybc/new-tools-and-workflows-for-data-analysis?slide=10
# 
library(tidyverse)
library(rvest)
library(stringr)
library(lubridate)

baseurl <- "http://www.maaamet.ee/kinnisvara/htraru/Start.aspx?aru=%s&ehak=%s&algus=%s&lopp=%s"

# T13 Korteriomandi (eluruumide) tehingud
aru <- "T13"
# ehak (Eesti haldus- ja asustusjaotuse klassifikaator) - piirkonna kood
# EEMK Kõik maakonnad
ehak <- "EEMK"
# algus - algus kuupäev
 
# lopp - lõpp kuupäev

# tehingu_liik - üldise statistika päringute korral on võimalik valida ainult 
# ostu-müügitehingud. Selleks lisatakse URL-i parameeter nimega tehingu_liik=OM 
# ja kui parameeter puudub, siis kuvatakse trükisel kõigi tehingute andmed.
# loika - lõikeprotsent, kasutatakse vaid hinnastatistika päringute korral. 
# Võimalikud väärtused on vahemikus 0 kuni 49.
# lang - keelevalik. Et näha aruandeid inglise keeles, tuleks lisada lang=ENG.
algus <- seq(dmy('01-01-2005'), dmy('01-12-2006'), by = '1 month')
lopp <- ceiling_date(algus, "month") - days(1)
reformat_date <- function(x) format(x, "%d.%m.%Y")
pull_maaamet <- . %>% 
  mutate_all(reformat_date) %>% 
  mutate(url = map2_chr(algus, lopp, ~sprintf(baseurl, aru, ehak, .x, .y)),
         resp = map(url, ~ {message(str_trunc(.x, 80, "center")); try(read_html(.x))}))



# Alt pull_maaamet --------------------------------------------------------



# Download data in smaller splits  ----------------------------------------

# 2005-6
residential_apartments_0506 <- data_frame(algus, lopp) %>% pull_maaamet()
# 2007-8
algus <- seq(dmy('01-01-2007'), dmy('01-12-2008'), by = '1 month')
lopp <- ceiling_date(algus, "month") - days(1)
residential_apartments_0708 <- data_frame(algus, lopp) %>% pull_maaamet()
# 2009-10
algus <- seq(dmy('01-01-2009'), dmy('01-12-2010'), by = '1 month')
lopp <- ceiling_date(algus, "month") - days(1)
residential_apartments_0910 <- data_frame(algus, lopp) %>% pull_maaamet()
# 2011-12
algus <- seq(dmy('01-01-2011'), dmy('01-12-2012'), by = '1 month')
lopp <- ceiling_date(algus, "month") - days(1)
residential_apartments_1112 <- data_frame(algus, lopp) %>% pull_maaamet()
# 2013-14
algus <- seq(dmy('01-01-2013'), dmy('01-12-2014'), by = '1 month')
lopp <- ceiling_date(algus, "month") - days(1)
residential_apartments_1314 <- data_frame(algus, lopp) %>% pull_maaamet()
# 2014-15
algus <- seq(dmy('01-01-2014'), dmy('01-12-2015'), by = '1 month')
lopp <- ceiling_date(algus, "month") - days(1)
residential_apartments_1415 <- data_frame(algus, lopp) %>% pull_maaamet()
# 2015-16
algus <- seq(dmy('01-01-2015'), dmy('01-12-2016'), by = '1 month')
lopp <- ceiling_date(algus, "month") - days(1)
residential_apartments_1516 <- data_frame(algus, lopp) %>% pull_maaamet()

# 2017
algus <- seq(dmy('01-01-2017'), dmy('01-12-2018'), by = '1 month')
lopp <- ceiling_date(algus, "month") - days(1)
residential_apartments_17 <- data_frame(algus, lopp) %>% pull_maaamet()


# alt download ------------------------------------------------------------

#' T13 Korteriomandi (eluruumide) tehingud
aru <- "T13"
#' ehak (Eesti haldus- ja asustusjaotuse klassifikaator) - piirkonna kood
#' EEMK Kõik maakonnad
ehak <- "EEMK"
start <- dmy('01-01-2005')
end <- dmy('01-12-2006')

maaamet_url <- function(start, end, by = '1 month', type = "T13", municip = "EEMK") {
  start <- seq(start, end, by = by)
  end <- lubridate::ceiling_date(start, "month") - days(1)
  
  baseurl <- "http://www.maaamet.ee/kinnisvara/htraru/Start.aspx?aru=%s&ehak=%s&algus=%s&lopp=%s"
  
  data_frame(start, end) %>%
  mutate(start_date = format(start, "%d.%m.%Y"),
         end_date = format(end, "%d.%m.%Y"),
    url = map2_chr(start_date, end_date, ~ sprintf(baseurl, type, municip, .x, .y))) %>% 
    select(start_month = start, end_month = end, url)
}

periods <- data_frame(start = seq(dmy('01-01-2005'), dmy('01-01-2018'), by = '2 years'),
           end = seq(dmy('01-12-2006'), dmy('01-12-2018'), by = '2 years'))
periods <- periods %>% 
  mutate(resp = map2(start, end, maaamet_url)) %>% 
  unnest()

safe_read_html <- safely(read_html)
transactions <- periods %>% 
  mutate(resp = map(url, ~ {message(str_trunc(.x, 80, "center")); safe_read_html(.x)}))
res <- transactions %>% 
  mutate(result = map(resp, "result")) %>% 
  pull(result)


get_maaamet_tab(res[[160]], ehak = ehak)

# end alt download --------------------------------------------------------



residential_apartments <- ls()[str_detect(ls(), "resid")] %>% 
  lapply(get) %>% 
  bind_rows()

devtools::source_gist("https://gist.github.com/tpall/ac0dad53d90112a82e9129f0ac028142", filename = "get_maaamet_tab.R")

residential_apartments <- residential_apartments %>% 
  mutate(tab = map(resp, get_maaamet_tab, ehak = ehak))

res_ap <- residential_apartments %>% 
  mutate(Month = month(dmy(lopp), label = TRUE),
         Year = year(dmy(lopp))) %>% 
  select(Year, Month, tab) %>% 
  unnest(tab) %>% 
  filter(!str_detect(`Pindala(m2)`, "KOKKU"))

newcolnames <- c("year", "month", "county", "area", "transactions", 
                 "area_total", "area_mean", "price_total", "price_min",
                 "price_max", "price_unit_area_min", "price_unit_area_max", 
                 "price_unit_area_median", "price_unit_area_mean", 
                 "price_unit_area_sd", "title", "subtitle")
colnames(res_ap) <- newcolnames

write_csv(res_ap, "transactions_residential_apartments.csv")
## Test file for import
# test <- read_csv("transactions_residential_apartments.csv")
# test
# Import consumer index data
library(foreign)
consumer_index <- read.dbf("rawdata/XO02320171017484539.dbf")
colnames(consumer_index) <- c("total", "year", month.abb)
consumer_index <- consumer_index[,-1]
write.csv(consumer_index, "consumer_index.csv")
