###################################
# Download Florida election results precinct level
# Data is from
# https://dos.myflorida.com/elections/data-statistics/elections-data/precinct-level-election-results/
###################################

# Packages used
library(tidyverse)
library(rvest)

data_page <- 'https://dos.myflorida.com/elections/data-statistics/elections-data/precinct-level-election-results/'
webpage <- read_html(data_page)

data_links <- webpage %>% 
  html_nodes('a') %>% 
  html_attr('href')

zip_files <- data_links[grepl(data_links, pattern = '.zip')]

doe_base_url <- 'https://dos.myflorida.com'

results <- paste0(doe_base_url, zip_files)

# nchar('/media/700241/precinctlevelelectionresults')
dest_file_names <- substr(zip_files, start = 43, stop = 53)

download.file(results[1],destfile = file.path('data',dest_file_names[1]))

walk2(
  results,
  dest_file_names,
  ~download.file(.x, destfile = file.path('data',.y))
)
