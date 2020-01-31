# Driver script
# Holly Williams, Jan 2019
#
# This driver script downloads data on FIFA soccer players and 
# international clubs, cleans the data, and then performs 
# statistical analysis to assess whether soccer players are overpaid.
# This script takes no arguments.
#
# usage: make all

# run all analysis
all: doc/report_fifa_overpaid.md doc/eda_report.md

# download fifa data
fifa_data : src/save_download.R
	RScript ./src/save_download.R --url=https://raw.githubusercontent.com/mglu123/live_dash_demo/master/data-2.csv  --out_dir=data/raw/

# download leagues data
league_data : src/download_and_save_league_data.R
	RScript ./src/download_and_save_league_data.r --url=https://raw.githubusercontent.com/hwilliams10/fifa_data/master/clubs_and_leagues.csv --out_dir=data/raw/

# cleans FIFA Training data
clean_fifa_train : src/clean.py fifa_data
	python ./src/clean.py --file_path="data/raw/fifa_data_train.csv" --out_file_path="data/cleaned/clean_train.csv"

# cleans FIFA Test data
clean_fifa_test : src/clean.py fifa_data
	python ./src/clean.py --file_path="data/raw/fifa_data_test.csv" --out_file_path="data/cleaned/clean_test.csv"
	
# cleans and wrangles club data
clean_club_data : src/clean_leagues_table.r clean_fifa_test clean_fifa_train
	Rscript ./src/clean_leagues_table.r --league_raw=data/raw/clubs_and_leagues.csv --fifa_test=data/cleaned/clean_test.csv --fifa_train=data/cleaned/clean_train.csv --out_dir=data/cleaned/

# Performs EDA on FIFA data and exports figures and tables
eda_fifa : clean_fifa_train clean_fifa_test
	python ./src/eda.py --input-file-path="data/cleaned/clean_train.csv" --output-folder-path="results"

# 8. Fits linear models and exports results
run_models : clean_fifa_test clean_fifa_train clean_club_data
	RScript ./src/analysis_overpaid.r --input_file=data/cleaned/combined_league_data.csv --out_dir_p=results/img --out_dir_r=results

# render reports	
doc/eda_report.md : doc/eda_report.Rmd doc/fifa_refs.bib eda_fifa
	Rscript -e "rmarkdown::render('doc/eda_report.Rmd')"
	
doc/report_fifa_overpaid.md : doc/report_fifa_overpaid.Rmd doc/fifa_refs.bib run_models
	Rscript -e "rmarkdown::render('doc/report_fifa_overpaid.Rmd')"

# Clean up intermediate and results files
clean : 
	rm -f results/*.png
	rm -f results/images/*.png
	rm -f results/img/*.png
	rm -f results/img/*.JPG
	rm -f doc/eda_report.md report_fifa_overpaid.md