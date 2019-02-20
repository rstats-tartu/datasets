
library(tidyverse)
index <- read_tsv("rawdata/XO023m.csv", col_names = FALSE, na = "..")
index <- index[-1]
colnames(index) <- c("aasta", "jaanuar", "veebruar", "märts", "aprill", "mai", "juuni", "juuli", "august", "september", "oktoober", "november", "detsember")
write_csv(index, path = "consumer_price_index.csv")
