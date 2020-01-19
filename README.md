# Project Proposal - Fifa 2019 complete player dataset

## Data Source and Description

For this project, we will be using the [Fifa 19 complete player dataset](https://www.kaggle.com/karangadiya/fifa19) [1].  The dataset includes about 80 attributes for all soccer players in FIFA 2019 (over 18,000 total!).  Attributes include basic information such as player age, nationality, club, position, wage, Fifa rating (as a measure of overall quality) as well as more detailed characteristics such as stamina, strength, interceptions, etc.  

So far we are only planning to make the following minor additions /changes to the dataset for our project:
 - Filter out extraneous attributes to make the number of features more manageable. For example, there are over 20 attributes that describe a player's performance rating in each possible position.  We plan to remove these and only use the primary player position and overall rating in our analysis.  After EDA and/or early model runs we will likely find more features that can be screened out.
 - Create a new `BMI` column based on the player `weight` and `height` attributes.

## Research Question

It's no secret that soccer players make exorbitant amounts of money.  Our main research question is a **predictive** question that asks: ***"What are the most important features in determining a football (soccer) player's salary?".***

Some sub-questions that we also plan to address include:
 - Are salaries correlated with ratings? If there is a strong correlation (which we would expect), we might be able to infer that the most important features for predicting salary might also be the best for predicting player quality/rating.
 - Who are the most overpaid and underpaid players in the world? Is there a trend by country/league/teams?
 - Are domestic players valued more highly than foreign players?
 - Which clubs have the best and worst economy in terms of a player potential to wage ratio?
 - Are different features more important for different positions?

## Plan

### Data Analysis

To analyze the data, we are planning to do the following (some of which may change after we complete our exploratory data analysis (EDA)):

- **Select key variables to include in our prediction model**
    - For example, we are currently thinking that age, nationality, position, skills (finishing, shot accuracy, etc) and physical attributes (speed, acceleration, etc) will be important characteristics
    - We will do some preliminary EDA to determine which variables are highly uncorrelated to salary / rating to limit the number of features that we need to include.

- **Fit a logistic regression model and extract feature weights on the whole dataset**
    - Other possible alternatives may include a Random Forest Regressor or other regression model
    - This will answer our primary research question of which features are most important in predicting a player's salary

- **Perform a hypothesis test using simulation (bootstrapping) and/or asymptotic theory (t-test) to determine whether domestic players are valued more highly than foreign players**
    - Null hypothesis: the average value (rating/wage) of domestic players and foreign players is the same.
    - Alternative hypothesis: the average value of domestic players is higher.

- **Investigate whether the overall trends **

### EDA

As part of the EDA process we plan to do the following at a minimum: 
- Determine which variables are highly correlated or uncorrelated to our target (salary) to decide which features to include or exclude from our prediction model.  For example, this could be done using `ggpairs` or a similar function.
- Plot histograms and/or distributions of key features (age, rating, salary, nationality, position) to get an idea of the variability within the data set.

#### Communicating Results

*What are the most important features in determining a football (soccer) player's salary?"*

The answer to our primary question can be presented as a bar chart or table showing the weights of the most important features for predicting salary ordered from most important to least important.

*Are salaries correlated with ratings?*

This could be a simple scatter plot with a regression fit line.

*Who are the most overpaid and underpaid players in the world? Is there a trend by country/league/teams?*

This could be presented as a bar plot showing a selected number (i.e. 10 or 20) of the best and worst-performing clubs colour-coded by league.

*Are domestic players valued more highly than foreign players?*
 
 This could be presented as a box plot or ridgeline plot showing the mean and distribution of domestic vs foreign player value.  We would also report the results of the hypothesis test with a significance level.
 
 *Which clubs have the best and worst economy in terms of a player potential to wage ratio?*

This could also be shown as a bar plot showing a selected number (i.e. 10) of the best and worst-performing clubs colour-coded by league.

 *Are different features more important for different positions?*

This could be plotted as a multi-bar chart with features on the x-axis, weights on the y-axis, and different coloured bars for each position (defense, midfield, forward)



### References

[1] Karan Gadiya. (2019, February). FIFA 19 complete player dataset. Retrieved January 16, 2020 from https://www.kaggle.com/karangadiya/fifa19.


