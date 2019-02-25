#' Load libraries.
#+ 
library(httr)
library(glue)
library(purrr)
library(tidyr)
library(here)

#' Cleaned-up virus and host database from https://www.genome.jp/viptree.
#+
url <- "https://www.genome.jp/viptree/data/set/{type}/All/set.ordered.lst"
type <- c("dsDNA", "ssDNA", "dsRNA", "ssRNA", "Retrovirus", "Satellite-virophage")
urls <- glue(url)
genome_tables <- tibble(url = urls) %>% 
    mutate(r = map(url, GET))
genome_tables <- genome_tables %>% 
    mutate(status = map_chr(r, status_code),
           cont = map(r, content, as = "text", encoding = "UTF-8"),
           cont = map(cont, read_tsv, col_types = paste0(rep("c", 13), collapse = ""))) %>% 
    select(cont) %>% 
    unnest()
write_csv(genome_tables, "virus_genome_tables.csv")

#' Original source for the cleaned-up tables from ftp://ftp.genome.jp.
#+
ftp <- "ftp://ftp.genome.jp/pub/db/virushostdb/virushostdb.tsv"
destfile <- here(basename(ftp))
download.file(url = ftp, destfile = destfile)
virushostdb <- read_tsv(destfile, 
                        col_types = cols(
                            `virus tax id` = col_character(),
                            `virus name` = col_character(),
                            `virus lineage` = col_character(),
                            `refseq id` = col_character(),
                            `KEGG GENOME` = col_character(),
                            `KEGG DISEASE` = col_character(),
                            DISEASE = col_character(),
                            `host tax id` = col_character(),
                            `host name` = col_character(),
                            `host lineage` = col_character(),
                            pmid = col_character(),
                            evidence = col_character(),
                            `sample type` = col_character(),
                            `source organism` = col_character()
                        ))
virushostdb
