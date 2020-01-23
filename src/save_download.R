# author: Huayue Lu G410
# date: 2020-01-17

"This script download and save the data that are in CSV 
format, from https://www.kaggle.com/karangadiya/fifa19.
This data was kept here :
https://raw.githubusercontent.com/mglu123/live_dash_demo/master/data-2.csv
Save the splited data as name data_fifa_train.csv for training dataset
and data_fifa_test.csv for test dataset in specified absolute path.
Usage: download_save.R <file_path_train> <file_path_test> <url>
" -> doc

# example to run: Rscript src/save_download.R 
# '/Users/huayuelu/Desktop/DSCI_522_G410/data/fifa_data_train.csv' 
# '/Users/huayuelu/Desktop/DSCI_522_G410/data/fifa_data_test.csv' 
# https://raw.githubusercontent.com/mglu123/live_dash_demo/master/data-2.csv

library(feather)
library(caret)
library(tidyverse)
library(testthat)
library(docopt)
library(RCurl)
set.seed(8888)
opt <- docopt(doc)


main <- function(file_path_train, file_path_test, url){
  # read in data
  data_fifa <- read.csv(url)
  training_rows <- data_fifa %>% 
    select(X) %>% 
    pull() %>%
    createDataPartition(p = 0.75, list = FALSE)
  training_data <- data_fifa %>% slice(training_rows)
  test_data <- data_fifa %>% slice(-training_rows)
#  num_rows <- dim(data_fifa)[1] - dim(data_fifa)[[1]]%/%5
#  data_fifa_train <- data_fifa[1:num_rows,]
#  data_fifa_test <- data_fifa[num_rows:dim(data_fifa)[1],]
  # save the  data
  write.csv(training_data, file_path_train, row.names = TRUE)
  write.csv(test_data, file_path_test, row.names = TRUE)
}

test_main <- function(url) {
  test_that("test url is existed or not", {
    expect_true(url.exists(url))
  })
}
test_main(opt$url)

main(opt$file_path_train, opt$file_path_test, opt$url)