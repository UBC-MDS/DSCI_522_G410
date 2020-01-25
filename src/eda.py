"""
This script reads cleaned and preprocessed data and generates images and tables to be used in further analysis.

Usage: eda.py --input-file-path=<input_file_path> --output-folder-path=<output_folder_path>

Options:
--input-file-path=<input_file_path>     file path for input csv file
--output-folder-path=<output_folder_path>   folder path to write images and tables
"""

# example to run: python eda.py --input-file-path="../data/cleaned/clean_train.csv" --output-folder-path="../results"

import sys
import os
import numpy as np
import pandas as pd
import altair as alt
import matplotlib.pyplot as plt
import seaborn as sns
from selenium import webdriver
from pathlib import Path
from docopt import docopt
from pylab import savefig

from altair import pipe, limit_rows, to_values

t = lambda data: pipe(data, limit_rows(max_rows=20000), to_values)
alt.data_transformers.register('custom', t)
alt.data_transformers.enable('custom')

IMAGE_FOLDER = 'images'
DATA_FOLDER = 'data'


def validate_and_read_input_file(input_file_path):
    """
    Validates input file path.

    Parameters:
    -----------
    input_file_path : str
        input path to be verified
        
    Returns:
    -----------
    pandas.DataFrame
        if path is valid and verified
    """
    if not os.path.isfile(input_file_path):
        print("Input file does not exist.")
        sys.exit()

    try:
        data_frame = pd.read_csv(input_file_path, index_col=0)
        print('Input file has been imported.')
    except:
        print('Data import has failed. Please check your input file at ' + input_file_path)
        sys.exit()

    required_columns = ['Age', 'BMI', 'Overall', 'Wage', 'Club', 'Value']

    if not all([item in data_frame.columns for item in required_columns]):
        print("Input file should contain these columns: " + str(required_columns))
        sys.exit()

    print('Input file has been verified.')
    return data_frame


def generate_age_overall_and_bmi_distribution_chart(data_frame, output_folder, file_name):
    """
    Generates an Altair chart in which 'age, overall and bmi distribution' can be seen.
    Also saves resulting chart as png file in given output folder.

    Parameters:
    -----------
    data_frame : pandas.DataFrame
        input path to be verified
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated chart image
        
    Returns:
    -----------
    str
        saved file path
    """
    p_age = alt.Chart(data_frame).mark_bar().encode(
        alt.X("Age", bin=alt.Bin(maxbins=30)), y='count()', ).properties(width=300, height=200,
                                                                         title='Distribution of Age')
    p_bmi = alt.Chart(data_frame).mark_bar().encode(
        alt.X("BMI", bin=alt.Bin(maxbins=30)), y='count()', ).properties(width=300, height=200,
                                                                         title='Distribution of BMI')
    p_overall = alt.Chart(data_frame).mark_bar().encode(
        alt.X("Overall", bin=True), y='count()', ).properties(width=300, height=200,
                                                              title='Distribution of Overall Score')

    chart = p_age | p_bmi | p_overall

    return save_altair_chart(chart, output_folder, file_name)


def generate_age_overall_and_bmi_vs_wage_chart(data_frame, output_folder, file_name):
    """
    Generates an Altair chart in which 'how wage changes by age, overall and bmi' can be seen.
    Also saves resulting chart as png file in given output folder.

    Parameters:
    -----------
    data_frame : pandas.DataFrame
        input path to be verified
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated chart image
        
    Returns:
    -----------
    str
        saved file path
    """
    
    p_age = alt.Chart(data_frame).mark_point().encode(
        x=alt.X('Age', title='Age of the player'),
        y=alt.Y('Wage', title='Wage(in K)')
    ).properties(width=400, height=300, title='The relationship between Age and Salary')
    p_bmi = alt.Chart(data_frame).mark_point().encode(
        x=alt.X('BMI', title='Body mass index (BMI) of the player'),
        y=alt.Y('Wage', title='Wage(in K)')
    ).properties(width=400, height=300, title='The relationship between Age and Salary')
    p_overall = alt.Chart(data_frame).mark_point().encode(
        x=alt.X('Overall', title='Overall rating of the player'),
        y=alt.Y('Wage', title='Wage(in K)')
    ).properties(width=400, height=300, title='The relationship between Overall and Salary')

    chart = p_age | p_bmi | p_overall

    return save_altair_chart(chart, output_folder, file_name)


def generate_wage_histogram(data_frame, output_folder, file_name):
    """
    Generates an Altair chart in which 'wage histogram' can be seen.
    Also saves resulting chart as png file in given output folder.

    Parameters:
    -----------
    data_frame : pandas.DataFrame
        input path to be verified
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated chart image
        
    Returns:
    -----------
    str
        saved file path
    """

    chart = alt.Chart(data_frame).mark_bar().encode(
        x=alt.X("Wage", bin=alt.Bin(maxbins=40), title='Wage(in K)'),
        y=alt.Y('count()', title='Number of players')
    ).properties(title='Distribution of Wage')

    return save_altair_chart(chart, output_folder, file_name)


def generate_wage_distribution_in_the_richest_clubs(data_frame, output_folder, file_name):
    """
    Generates an Altair chart in which 'how wages are distributed on the most richest clubs' can be seen.
    Also saves resulting chart as png file in given output folder.

    Parameters:
    -----------
    data_frame : pandas.DataFrame
        input path to be verified
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated chart image
        
    Returns:
    -----------
    str
        saved file path
    """

    rich_clubs = ('FC Barcelona', 'Real Madrid', 'Arsenal', 'Manchester City', 'Juventus')
    df_club = data_frame.loc[data_frame['Club'].isin(rich_clubs) & data_frame['Wage']]

    fig, ax = plt.subplots()
    fig.set_size_inches(20, 10)
    ax = sns.boxplot(x="Club", y="Wage", data=df_club)
    ax.set_xlabel("Club",fontsize=30)
    ax.set_ylabel("Weekly Wage ($1000's)",fontsize=20)
    #ax.set_title(label='Distribution of wage in the richest clubs', fontsize=20)

    full_output_path = os.path.join(output_folder, IMAGE_FOLDER, file_name + '.png')

    figure = ax.get_figure()
    figure.savefig(full_output_path, dpi=400)
    print("Saved " + full_output_path)

    return full_output_path


def generate_wage_distribution_in_random_clubs(data_frame, output_folder, file_name):
    """
    Generates an Altair chart in which 'how wages are distributed on random clubs' can be seen.
    Also saves resulting chart as png file in given output folder.

    Parameters:
    -----------
    data_frame : pandas.DataFrame
        input path to be verified
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated chart image
        
    Returns:
    -----------
    str
        saved file path
    """

    random_clubs = tuple(data_frame['Club'].sample(n=5, random_state=20))
    df_club = data_frame.loc[data_frame['Club'].isin(random_clubs) & data_frame['Wage']]

    fig, ax = plt.subplots()
    fig.set_size_inches(20, 10)
    ax = sns.boxplot(x="Club", y="Wage", data=df_club)
    ax.set_title(label='Distribution of wage in  clubs', fontsize=20)

    full_output_path = os.path.join(output_folder, IMAGE_FOLDER, file_name + '.png')

    figure = ax.get_figure()
    figure.savefig(full_output_path, dpi=400)
    print("Saved " + full_output_path)

    return full_output_path


def generate_club_value_vs_wage_chart(data_frame, output_folder, file_name):
    """
    Generates an Altair chart in which 'how wage is changing by total club value' can be seen.
    Also saves resulting chart as png file in given output folder.

    Parameters:
    -----------
    data_frame : pandas.DataFrame
        input path to be verified
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated chart image
        
    Returns:
    -----------
    str
        saved file path
    """

    club_df = data_frame.groupby(['Club'])['Value'].agg('sum').reset_index()
    data_frame['Club_Value'] = data_frame['Club'].apply(lambda x: club_df[club_df['Club'] == x]['Value'].values[0])

    p_coverall = alt.Chart(data_frame).mark_point().encode(
        x=alt.X('Club_Value', title='Total player value of the Club'),
        y=alt.Y('Wage', title='Wage(in K)')
    ).properties(width=400, height=300,
                 title='The relationship between total player value of the Club overall and Salary')

    return save_altair_chart(p_coverall, output_folder, file_name)


def generate_and_save_wage_correlation_matrix(data_frame, output_folder, file_name):
    """
    Generates data frame in which 'top 20 most correlated attributes to Wage' can be seen.
    Also saves resulting chart as png file in given output folder.

    Parameters:
    -----------
    data_frame : pandas.DataFrame
        input path to be verified
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated chart image
        
    Returns:
    -----------
    str
        saved file path
    """

    correlation = data_frame.corr().abs()
    largest = pd.DataFrame(correlation.nlargest(20, 'Wage')['Wage'])

    full_file_name = file_name + '_largest_20.csv'

    return save_data_frame_as_csv(largest, output_folder, full_file_name)


def save_altair_chart(chart, output_folder, file_name):
    """
    Saves given chart as png file in given output folder.

    Parameters:
    -----------
    chart : Altair.Chart
        chart to be saved
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated chart image
        
    Returns:
    -----------
    str
        saved file path
    """

    image_output_folder = os.path.join(output_folder, IMAGE_FOLDER)
    Path(image_output_folder).mkdir(parents=True, exist_ok=True)

    full_output_path = os.path.join(image_output_folder, file_name + '.png')
    chart.save(full_output_path, webdriver='chrome')
    print("Saved " + full_output_path)
    return full_output_path


def save_data_frame_as_csv(data_frame, output_folder, file_name):
    """
    Saves given data frame as csv file in given output folder.

    Parameters:
    -----------
    data_frame : pandas.DataFrame
        data frame to be saved
    output_folder : str
        output folder path to save the chart
    file_name : str
        file name for generated csv
        
    Returns:
    -----------
    str
        saved file path
    """

    data_output_folder = os.path.join(output_folder, DATA_FOLDER)
    Path(data_output_folder).mkdir(parents=True, exist_ok=True)

    full_output_path = os.path.join(data_output_folder, file_name)

    data_frame.to_csv(full_output_path, encoding='utf-8')
    print("Saved " + full_output_path)

    return full_output_path


def main(input_file_path, output_folder_path):
    df = validate_and_read_input_file(input_file_path)

    generate_age_overall_and_bmi_distribution_chart(df, output_folder_path, "age_bmi_and_overall_distribution")
    generate_age_overall_and_bmi_vs_wage_chart(df, output_folder_path, "age_bmi_and_overall_vs_wage")
    generate_wage_histogram(df, output_folder_path, "wage_histogram")
    generate_wage_distribution_in_the_richest_clubs(df, output_folder_path, "wage_distribution_in_the_richest_clubs")
    generate_wage_distribution_in_random_clubs(df, output_folder_path, "wage_distribution_in_random_clubs")
    generate_club_value_vs_wage_chart(df, output_folder_path, "club_value_vs_wage")
    generate_and_save_wage_correlation_matrix(df, output_folder_path, "wage_correlation")


if __name__ == "__main__":
    args = docopt(__doc__, version='v0.1')
    main(args["--input-file-path"], args["--output-folder-path"])
