# author: Huayue Lu G410
# date: 2020-01-17
#
# This script download and save the data that are in CSV 
# format, from https://www.kaggle.com/karangadiya/fifa19
#
# Usage: download_save.R

library(tidyverse)
library(testthat)

main <- function(){
  
  # read in data
  data_fifa <- read.csv("https://raw.githubusercontent.com/mglu123/live_dash_demo/master/data-2.csv")
  
  # save the  data
  write.csv(data_fifa,'data_fifa.csv')
}


main()