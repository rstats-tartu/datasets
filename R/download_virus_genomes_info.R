
#' Download virus genome summary from ncbi ftp site
ftpurl <- "ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/viruses.txt"

download.file(ftpurl, destfile = basename(ftpurl))

#' Update viruses table column names
library(readr)
library(dplyr)
library(stringr)

viruses <- read_tsv("viruses.txt")

viruses <- rename_all(viruses, str_replace_all, "^[[:punct:]]", "") %>% 
    rename_all(str_to_lower) %>% 
    rename_all(str_replace_all, "\\/", " ") %>%  
    rename_all(str_replace_all, "[[:punct:]]", "") %>% 
    rename_all(str_replace_all, "\\s+", "_") %>% 
    rename_all(str_replace, "segmemts", "segments") %>% 
    rename(tax_id = taxid)

write_csv(viruses, path = "viruses.csv")
file.remove("viruses.txt")
