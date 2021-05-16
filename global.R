library(dplyr)                   # this packages is use for data preparation (edit, remove, mutate, etc)
library(stringr)                 # all functions deal with "NA"'s and zero length vectors
library(purrr)                   # requirement packages for Functional Programming Tools
library(rlang)                   # requirement packages for Rmarkdown
library(DT)                      # interface to the JavaScript library DataTables (https://datatables.net/)
library(r2d3)                    # D3 visualization
library(nycflights13)            # all flights that departed from NYC in 2013

airline_list <- airlines %>%
  collect() %>%
  split(.$name) %>%
  map(~ .$carrier)

month_list <- as.list(1:12) %>%
  set_names(month.name)

month_list$`All Year` <- 99
