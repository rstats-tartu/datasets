
library(tidyverse)
#' PO0211.csv was generated and downloaded from 
#' [Statistics Estonia](http://pub.stat.ee/px-web.2001/Dialog/varval.asp?ma=PO0211&ti=MEAN+ANNUAL+POPULATION+BY+SEX+AND+AGE+GROUP&path=../I_Databas/Population/01Population_indicators_and_composition/04Population_figure_and_composition/&lang=1)

## extract data
pop <- read_delim("rawdata/PO0211.csv",
                  "\t", 
                  escape_double = FALSE, 
                  trim_ws = TRUE,
                  skip = 2)

colnames(pop)[2] <- c("Year")
vars <- which(!is.na(pop$X1))[1:2]
Sex <- rep(pop$X1[vars], each = diff(vars))
pop1 <- pop[1:length(Sex), ]

pop1$Sex <- Sex 
pop1 <- select(pop1, Sex, Year, matches("^[[:digit:]]")) %>% 
  filter(complete.cases(.))
pop1 <- mutate(pop1, Sex = if_else(Sex == "Males", "Men", "Women"))
write_csv(pop1, "mean_annual_population.csv")
