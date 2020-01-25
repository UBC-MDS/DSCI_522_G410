"""This script does ML analysis on the Fifa Soccer dataset and return 
a plot of weight of different features.

Usage: clean.py --file_path_train=<file_path_train> --file_path_test=<file_path_test> --file_path_output=<file_path_output> 

Options:
--file_path_train=<file_path_train>           file path for train data set
--file_path_test=<file_path_test>   file path for train data set
--file_path_output=<file_path_output> file path for save png plot end file name with .png
"""
import numpy as np
import pandas as pd
import altair as alt
from sklearn.pipeline import Pipeline, make_pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.metrics import mean_squared_error, make_scorer
import time
import os
from sklearn.linear_model import LinearRegression
from docopt import docopt

opt = docopt(__doc__)

def main(file_path_train, file_path_test, file_path_output):
    fifa_data_train = pd.read_csv("file_path_train", index_col=0)
    fifa_data_test = pd.read_csv("file_path_train", index_col=0)
    X = fifa_data_train.drop(columns=['Name','Club','Preferred.Foot','Real.Face',
                                  'Work.Rate.Former','Work.Rate.Later','Wage',
                                  'Release.Clause','Nationality', 'Position','GKDiving', 'GKHandling',
                                  'GKKicking', 'GKPositioning', 'GKReflexes'])
    y = fifa_data_train['Wage']

    X_real_test = fifa_data_test.drop(columns=['Name','Club','Preferred.Foot','Real.Face',
                                  'Work.Rate.Former','Work.Rate.Later','Wage',
                                  'Release.Clause','Nationality', 'Position','GKDiving', 'GKHandling',
                                  'GKKicking', 'GKPositioning', 'GKReflexes'])

    y_real_test = fifa_data_test['Wage']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

    lgr = LinearRegression()

    lgr.fit(X_train,y_train)
    lgr.score(X_test, y_test)

    lgr.score(X_real_test, y_real_test)
    print("MSE for this model is", mean_squared_error(y_real_test, lgr.predict(X_real_test)))
    source = pd.DataFrame({
    'Features': list(X.columns),
    'Weight': abs(lgr.coef_)})

    p = alt.Chart(source).mark_bar().encode(
    x='Features',
    y='Weight')
    p.save(file_path_output)

if __name__ == "__main__":
    main(opt["--file_path_train"], opt["--file_path_test"],opt["--file_path_output"])  