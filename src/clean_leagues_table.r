# author: Holly Williams
# date: 2020-01-24


"Cleans the league data (from https://github.com/hwilliams10/fifa_data/blob/master/clubs_and_leagues.csv, 
originally sourced from https://www.ea.com/games/fifa/news/fifa-19-leagues-and-teams).
Writes the training and test data to separate feather files.

Usage: src/clean_leagues_table.r --league_raw=<league_raw> --fifa_test=<fifa_test> --fifa_train=<fifa_train> --out_dir=<out_dir>

Options:
--league_raw=<league_raw>     Path (including filename) to raw league data (csv file)
--fifa_test=<fifa_test>       Path (including filename) to cleaned fifa test data (csv file)
--fifa_train=<fifa_train>      Path (including filename) to cleaned fifa train data (csv file)
--out_dir=<out_dir>   Path to directory where the processed data should be written
" -> doc

library(tidyverse)
library(docopt)
library(testthat)

opt <- docopt(doc)
main <- function(league_raw, fifa_test, fifa_train, out_dir){
  # reads in data and cleans up team names (only focusses on top 5 leagues)
  league_data <- read_csv(league_raw) %>% 
    mutate(Club = str_replace(Club, "\\bUtd\\b", "United"),
           Club = case_when(Club == 'Dortmund' ~ 'Borussia Dortmund',
                            Club == 'OL' ~ 'Olympique Lyonnais',
                            Club == 'Schalke' ~ 'FC Schalke 04',
                            Club == 'OM' ~ 'Olympique de Marseille',
                            Club == 'Leverkusen' ~ 'Bayer 04 Leverkusen',
                            Club == 'Dalian Yifang' ~ 'Dalian YiFang FC',
                            Club == 'Shanghai SIPG' ~ 'Shanghai SIPG FC',
                            Club == 'TSG Hoffenheim' ~ 'TSG 1899 Hoffenheim',
                            Club == 'Athletic Club' ~ 'Athletic Club de Bilbao',
                            Club == 'Beijing Guoan' ~ 'Beijing Sinobo Guoan FC',
                            Club == 'CSKA Moscow' ~ 'PFC CSKA Moscow',
                            Club == 'Werder Bremen' ~ 'SV Werder Bremen',
                            Club == 'Fenerbahçe' ~ 'Fenerbahçe SK',
                            Club == "M'gladbach" ~ 'Borussia Mönchengladbach',
                            Club == 'LAFC' ~ 'Los Angeles FC',
                            Club == 'Wolves' ~ 'Wolverhampton Wanderers',
                            Club == 'Frankfurt' ~ 'Eintracht Frankfurt',
                            Club == 'Düsseldorf' ~ 'Fortuna Düsseldorf',
                            Club == 'Frankfurt' ~ 'Eintracht Frankfurt',
                            Club == 'Köln' ~ '1. FC Köln',
                            Club == 'D. Alavés' ~ 'Deportivo Alavés',
                            Club == 'R. Valladolid CF' ~ 'Real Valladolid CF',
                            Club == 'Paderborn' ~ 'SC Paderborn 07',
                            Club == 'Union Berlin' ~ '1. FC Union Berlin',
                            Club == 'ASSE' ~ 'AS Saint-Étienne',
                            Club == 'Girondins de Bx' ~ 'FC Girondins de Bordeaux',
                            Club == 'RC Strasbourg' ~ 'RC Strasbourg Alsace',
                            Club == 'Stade Brestois' ~ 'Stade Brestois 29',
                            Club == 'Stade Rennais' ~ 'Stade Rennais FC',
                            Club == 'Toulouse FC' ~ 'Toulouse Football Club',
                            Club == 'AFC Bournemouth' ~ 'Bournemouth',
                            Club == 'Brighton' ~ 'Brighton & Hove Albion',
                            TRUE ~ Club))
    # reads in fifa data
    fifa_test_df <- read_csv(fifa_test)
    fifa_train_df <- read_csv(fifa_train)
    fifa_data <- rbind(fifa_test_df, fifa_train_df)
    # only includes top 5 leagues
    league_data_top_5 <- league_data %>% 
      filter(League %in% c('Premier League', 'LaLiga', 'Bundesliga', 'Serie A', 'Ligue 1'))
    # combines league and fifa data into one clean dataframe
    combined_df <- inner_join(league_data_top_5, fifa_data, by='Club') %>% 
      select('Club', 'League', 'Country', 'Name', 'Age', 'Nationality', 'Overall', 'Wage') %>% 
      mutate('Salary (M)' = Wage * 52 / 1000,
             'Domestic' = ifelse(Nationality == Country, 1, 0),
             'Overpaid_Index' = (`Salary (M)` / Overall * 1000))
    
    test_that("if out put data has right shape", {
      expect_equal(length(combined_df), 11)
    })
    
    # save the data
    write.csv(combined_df, paste0(out_dir, "combined_league_data.csv"))
}

main(opt[["--league_raw"]], opt[["--fifa_test"]], opt[["--fifa_train"]], opt[["--out_dir"]])