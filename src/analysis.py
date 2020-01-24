# author: DSCI 522-Group 410
# date: January 24, 2020

'''This script does ML analysis on the Fifa Soccer dataset and performs calculation on MSE for the training and validation sets.
Usage: analysis.py --train_data_path=<train_data_path> --test_data_path=<test_data_path> --results_path=<results_path>
Options:
--train_data_path=<train_data_path> location to obtain the training data set
--test_data_path=<test_data_path> location to obtain the testing data set
--results_path=<results_path>  location to save results
'''

# example to run: python analysis.py --train_data_path="../data/cleaned/clean_train.csv" --test_data_path="../data/cleaned/clean_test.csv" --results_path="../results"

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


from docopt import docopt

opt = docopt(__doc__)

#main function
def main(train_data_path, test_data_path, results_path):
    #Loading clean data set
    fifa_data_train = pd.read_csv(train_data_path, index_col=0)
    fifa_data_test = pd.read_csv(test_data_path, index_col=0)

    X_train = fifa_data_train.drop(columns=['Wage', 'Name','Club','Nationality', 'GKDiving', 'GKHandling',
           'GKKicking', 'GKPositioning', 'GKReflexes', 'Release.Clause','Preferred.Foot','International.Reputation'])
    y_train = fifa_data_train[['Wage']]

    X_test = fifa_data_test.drop(columns=['Wage', 'Name','Club','Nationality', 'GKDiving', 'GKHandling',
           'GKKicking', 'GKPositioning', 'GKReflexes', 'Release.Clause','Preferred.Foot','International.Reputation'])
    y_test = fifa_data_test[['Wage']]
    
    
    #features
    categorical, numerical = get_preprocessing_features(X_train)

    #Preprocessing Train Data

    preprocessor = ColumnTransformer(
        transformers=[
            ('scale', StandardScaler(), numerical),
            ('ohe', OneHotEncoder(drop="first"), categorical)])


    X_train_prep = preprocessor.fit_transform(X_train)
    X_test_prep = preprocessor.fit_transform(X_test)

    X_train_prep = pd.DataFrame(X_train_prep)
    X_train_prep= X_train_prep.iloc[:, :63]
    X_train_prep = X_train_prep.to_numpy()



    X_train_subset, X_valid, y_train_subset, y_valid = train_test_split(X_train_prep, y_train,test_size = 0.2,random_state = 123)

    lgr = LogisticRegression(solver='lbfgs',  max_iter=4000)

    t = time.time()
    lgr.fit(X_train_subset, y_train_subset);
    y_train_pred = lgr.predict(X_train_subset)
    y_valid_pred = lgr.predict(X_valid)
    mse = mean_squared_error(y_train_subset, y_train_pred)
    valid_mse = mean_squared_error(y_valid, y_valid_pred)
    elapsed = time.time() - t
    results = [round(mse,4), round(valid_mse,4), round(elapsed,4)]

    results_df = pd.DataFrame(results).T
    results_df.columns = ["Training MSE", "Validation MSE", "Time (seconds)"]
    results_df.to_csv(os.path.join(results_path, 'MSE_results.csv'))


    # Predicting for X_test data

    y_train_predict = lgr.predict(X_train_prep)
    y_test_predict = lgr.predict(X_test_prep)

    y_test = np.array(y_test).ravel()
    y_test_predict = np.array(y_test_predict).ravel()


    test_residuals = y_test_predict - y_test

    test_comparison = pd.DataFrame({'actual': y_test, 'predicted': y_test_predict, 'residuals': test_residuals})

    # creating bar chart for predict vs actual
    pred_plot = alt.Chart(test_comparison).mark_bar(size=4).encode(
      alt.X('actual',
            title='Actual'),
      alt.Y('predicted',
           title='Predicted')
    ).properties(title='Actual vs Predicted plot for logistic regression')


    pred_plot.save(os.path.join(results_path, 'pred_plot.png'))

#Identifying the categorical and numeric columns
def get_preprocessing_features(x):
    """ Retrieves a list of categorical and numerical
    features using fifa train data set (X) 
    using data type. 

    Parameters
    ----------
    x : DateFrame
        Fifa Training data.

    Returns
    -------
    categorical and numerical features: tuple

    """
    d_types = x.dtypes
    categorical = []
    numerical = []
    for data_type, features in zip(d_types, d_types.index):
        if data_type == "object":
            categorical.append(features)
        else:
            numerical.append(features)

    return categorical, numerical

if __name__ == "__main__":
  main(opt["--train_data_path"], opt["--test_data_path"], opt["--results_path"])
