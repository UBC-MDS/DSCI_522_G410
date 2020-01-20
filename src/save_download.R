# author: Huayue Lu G410
# date: 2020-01-17

"This script download and save the data that are in CSV 
format, from https://www.kaggle.com/karangadiya/fifa19.
This data was kept here :
https://raw.githubusercontent.com/mglu123/live_dash_demo/master/data-2.csv
Save data as name data_fifa.csv in /data/raw folder
Usage: download_save.R <file_path> <url>
" -> doc

library(tidyverse)
library(testthat)
library(docopt)
library(RCurl)

opt <- docopt(doc)


main <- function(file_path,url){
  # read in data
  data_fifa <- read.csv(url)
  
  # save the  data
  write_csv(data_fifa, file_path)
}

test_main <- function(url) {
  test_that("test url is existed or not", {
    expect_true(url.exists(url))
  })
}
test_main(opt$url)

main(opt$file_path, opt$url)