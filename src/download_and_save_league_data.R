# author: Huayue Lu G410, Holly Williams
# date: 2020-01-24



"This script is for downloading and saving data only.
This was used to download league data from https://github.com/hwilliams10/fifa_data
which was created by myself manually using this website https://www.ea.com/games/fifa/news/fifa-19-leagues-and-teams
Writes the data to a csv file 

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
  data <- read.csv(url)
  # save to file
  write.csv(data, paste0(out_dir, "clubs_and_leagues.csv"), row.names = TRUE)
}


# test that url exists
test_main <- function(url) {
  test_that("test that url exists", {
    expect_true(url.exists(url))
  })
}

test_main(opt$url)

main(opt$url, opt$out_dir)