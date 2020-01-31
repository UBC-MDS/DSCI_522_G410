# author: Huayue Lu G410
# date: 2020-01-17

"This script downloads and save the data that are in CSV 
format, from https://www.kaggle.com/karangadiya/fifa19.
This data was kept here :
https://raw.githubusercontent.com/mglu123/live_dash_demo/master/data-2.csv
Save the splited data as name data_fifa_train.csv for training dataset
and data_fifa_test.csv for test dataset in specified path.

Usage: src/save_download_only.r --url=<url> --out_dir=<out_dir>

Options:
--url=<url>           URL link to download data from
--out_dir=<out_dir>   Path to directory where the file should be written
" -> doc


library(tidyverse)
library(testthat)
library(docopt)
library(RCurl)

opt <- docopt(doc)

main <- function(url, out_dir){
  
  # read in data
  data_fifa <- read.csv(url)
  # split into training and test
  set.seed(8888)
  sample_size <- floor(0.75*nrow(data_fifa))
  training_rows = sample(seq_len(nrow(data_fifa)), size = sample_size)
  training_data <- data_fifa %>% slice(training_rows)
  test_data <- data_fifa %>% slice(-training_rows)
  # save to file
  write.csv(training_data, paste0(out_dir, "fifa_data_train.csv"), row.names = TRUE)
  write.csv(test_data, paste0(out_dir, "fifa_data_test.csv"), row.names = TRUE)
}


# test that url exists
test_main <- function(url) {
  test_that("test that url exists", {
    expect_true(url.exists(url))
  })
}

test_main(opt$url)

main(opt$url, opt$out_dir)