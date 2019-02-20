#' ## Downloading GADM data for Estonia

#' Loading here library for easy setup of project paths.
#+
library(here)

#' Setup URL to gadm36_EST_0_sp.rds file at https://gadm.org/download_country_v3.html.
#+
url <- "https://biogeo.ucdavis.edu/data/gadm3.6/Rsp/gadm36_EST_0_sp.rds"

#' Fetch file to data folder.
download.file(url = url, destfile = here("data", basename(url)))
