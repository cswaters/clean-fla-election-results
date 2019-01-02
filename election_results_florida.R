###################################
# Clean Florida election results precinct level
# Raw data is from
# https://dos.myflorida.com/elections/data-statistics/elections-data/precinct-level-election-results/
###################################

# Packages used
library(tidyverse)
library(data.table)
library(rvest)


# Directory containing raw files
# Each election is broken down into seperate folders
# for example, 2016 Primary or 2016 General
f_pri_dir <- 'data'

# List of file names
filez <- dir(f_pri_dir, full.names = TRUE)

# Data columns
p_level_cols <- c(
  'county_code',
  'county',
  'election_number',
  'date',
  'election_name',
  'primary_id',
  'precint_location',
  'tot_reg_voters',
  'tot_reg_reps',
  'tot_reg_dems',
  'tot_reg_other',
  'contest_name',
  'district',
  'contest_code',
  'candidate_or_issue',
  'party',
  'candidate_id',
  'doe',
  'vote_totals'
)


# go through files and read each one using data.table fread
fl_election_results <- filez %>%
  map( ~ fread(.x, col.names = p_level_cols, quote = "") %>%
         as_tibble())
fl_election_results

# set columns as character to prevent load errors
fl_election_results <- fl_election_results %>% 
  map(~mutate(.x,
              primary_id = as.character(primary_id),
              precint_location = as.character(precint_location),
              vote_totals = as.character(vote_totals))) %>% 
  bind_rows()


# convert vote totals back integer
fl_election_results <- fl_election_results %>%
  mutate(vote_totals = as.integer(vote_totals))


# export data
fl_election_results %>% 
  write_csv('results.csv')