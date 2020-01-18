# author: Huayue Lu G410
# date: 2020-01-17
#
# This script download and save the data that are in CSV 
# format, from https://www.kaggle.com/karangadiya/fifa19
#
# Usage: download_save.R

library(tidyverse)
library(testthat)
link <- "https://raw.githubusercontent.com/mglu123/live_dash_demo/master/data-2.csv"
main <- function(){
  # read in data
  data_fifa <- read.csv(link)
  
  # save the  data
  write.csv(data_fifa,'data_fifa.csv')
}

test_main <- function() {
  test_that("url's data type is character", {
    expect_equal(typeof(link), "character")
  })
}
test_main()

main()