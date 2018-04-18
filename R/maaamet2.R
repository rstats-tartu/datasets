library(tidyverse)
library(glue)
library(rvest)
library(crul)
library(stringr)
library(lubridate)

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
  data_frame(start, end) %>% 
    mutate(resp = map2(start, end, ~x$get(query = list(aru = aru, 
                                                       ehak = ehak, 
                                                       algus = format(.x, "%d.%m.%Y"), 
                                                       lopp = format(.y, "%d.%m.%Y")), 
                                          timeout_ms = 10000)))
}

periods <- data_frame(start = seq(dmy('01-01-2005'), dmy('01-01-2018'), by = '2 years'),
                      end = seq(dmy('01-12-2006'), dmy('01-12-2018'), by = '2 years'))
periods <- periods %>% 
  mutate(resp = map2(start, end, maaamet_query))

#' @param resp html response from maaamet
resp_to_table <- function(resp) {
  tab <- xml2::read_html(resp) %>% 
    rvest::html_nodes(css = "#aruTable") %>% 
    rvest::html_table() %>% 
    .[[1]]
  headers <- stringr::str_trim(stringr::str_c(colnames(tab), tab[1,], sep = " "))
  headers[1] <- "Maakond"
  tab <- tab[-1,]
  colnames(tab) <- headers
  tab <- dplyr::as_data_frame(tab)
  tab <- dplyr::mutate_at(tab, 4:13, stringr::str_remove_all, pattern = "\\s") %>% 
    dplyr::mutate_all(readr::parse_character, na = '***')
  tab <- readr::type_convert(tab, locale = readr::locale(decimal_mark = ","))
  tab %>% 
    mutate(Arv = parse_integer(Arv)) %>% 
    tidyr::fill(Maakond) %>% 
    dplyr::filter(`Pindala(m2)` != "KOKKU")
}

periods_unnested <- periods %>% 
  select(resp) %>% 
  unnest()

periods_unnested <- periods_unnested %>% 
  mutate(resp = map_chr(resp, ~ .x$parse(encoding = 'UTF-8')),
         tab = map(resp, safely(resp_to_table)),
         tab = map(tab, "result")) %>% 
  select(tab, everything())

transactions <- periods_unnested %>% 
  filter(!map_lgl(tab, is.null)) %>% 
  select(Kuu = start, tab) %>% 
  unnest()

write_csv(transactions, "transactions_residential_apartments.csv")
