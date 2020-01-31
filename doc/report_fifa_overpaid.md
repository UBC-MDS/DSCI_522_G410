Are Domestic Soccer Players Overpaid?
================

## Introduction

Most soccer leagues (and in fact many sports other sports leagues around
the world) have rules limiting the number of foreign players that any
team can have on their squad. In England’s Premier League, the
[Homegrown Player
Rule](https://en.wikipedia.org/wiki/Homegrown_Player_Rule_\(England\))
requires that each team has a minimum of 8 ‘homegrown’ (or ‘domestic’)
players on their 25 man sqad. I’ve often wondered if rules like this
actually result in domestic players being overvalued. What else could
explain Manchester United paying over 30 million pounds for an average
player like Luke Shaw when he was just a teenager?\!

For this project, we will attempt to answer the inferential question:
**Are domestic soccer players overpaid?** Or in a more statistical
context, we will be *testing the hypothesis that the mean overpaid index
is greater for domestic players than foreign players*.

## Methodology

### Data Sources

For this project, we sourced player salaries and attributes from the
[FIFA 19 complete player
dataset](https://www.kaggle.com/karangadiya/fifa19) (Gadiya n.d.) from
[Kaggle](www.kaggle.com). The dataset was downloaded and uploaded to one
of our team member’s public github repository (see
[here](https://raw.githubusercontent.com/mglu123/live_dash_demo/master/data-2.csv)).

Unfortunately, the FIFA dataset does not include information on leagues
and locations, so we needed another data source to be able to determine
whether a player is a domestic or foreign player. To be able to link
clubs with a league location, we manually created a dictionary table of
`Club`, `League`, and `Country` values sourced from the official [EA
Games
website](https://www.ea.com/games/fifa/news/fifa-19-leagues-and-teams)
(Games 2019) and uploaded it to another public github repo (located
[here](https://github.com/hwilliams10/fifa_data/blob/master/clubs_and_leagues.csv)).

### Exploratory Data Analysis

Before starting our analysis, we did some exploration on the range of
wages using the statistical package python
(<span class="citeproc-not-found" data-reference-id="python">**???**</span>).
One thing we looked at is which features were most strongly correlated
with wage. If every player were to receive fair compensation based on
their value, we would expect wage to be most strongly associated with
their overall FIFA ranking (which is how FIFA measures how valuable a
player is).

<table>

<caption>

**Table 1. Top 5 Features Correlated with Player Wage (Ignoring
Wage/Salary Features)**

</caption>

<thead>

<tr>

<th style="text-align:left;">

Feature

</th>

<th style="text-align:right;">

Correlation Coefficient

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Club\_Value

</td>

<td style="text-align:right;">

0.7111105

</td>

</tr>

<tr>

<td style="text-align:left;">

International.Reputation

</td>

<td style="text-align:right;">

0.6776594

</td>

</tr>

<tr>

<td style="text-align:left;">

Overall FIFA Ranking

</td>

<td style="text-align:right;">

0.5856002

</td>

</tr>

<tr>

<td style="text-align:left;">

Reactions

</td>

<td style="text-align:right;">

0.5134063

</td>

</tr>

<tr>

<td style="text-align:left;">

Potential

</td>

<td style="text-align:right;">

0.4935512

</td>

</tr>

<tr>

<td style="text-align:left;">

Composure

</td>

<td style="text-align:right;">

0.4663572

</td>

</tr>

</tbody>

</table>

From Table 1, we see that the overall FIFA ranking is reasonably
correlated with a player’s wage, but not as highly as one might expect.
We also see that it is likely that the richest clubs also have the
highest paid players which is intuitive.

*Note: The EDA analysis is performed by the [`eda.py`](../src/eda.py)
script in the [`src`](../src/) directory. Additional details on the EDA
process and findings are presented in the [EDA
Report](https://github.com/UBC-MDS/DSCI_522_G410/blob/master/doc/eda_report.md)
in the [`doc`](../doc/) directory*

### Assumptions

We decided to limit our analysis to the top five global soccer leagues:

  - Premier League (England)
  - LaLiga (Spain)
  - Bundesliga (Germany)
  - Serie A (Italy)
  - Ligue 1 (France)

To measure how overrated a player is, we decided to create an
`Overpaid_Index`. This index was calculated as a player’s total salary
(in millions) divided by their overall FIFA rating (which is a measure
of how ‘good’ a player is) and multiplied by 1000.   
![ Overpaid\\ Index = \\frac{salary (\\$M)}{FIFA\\ rating}1000
](https://latex.codecogs.com/png.latex?%20Overpaid%5C%20Index%20%3D%20%5Cfrac%7Bsalary%20%28%5C%24M%29%7D%7BFIFA%5C%20rating%7D1000%20
" Overpaid\\ Index = \\frac{salary (\\$M)}{FIFA\\ rating}1000 ")  

### Wrangling and Cleaning

When we first went to join the dataframes, there were many mismatching
`Club` names between the two datasets (for example, things like
`Manchester United` versus `Manchester Utd`). After joining the
tables,we also made new columns for the following features:

  - `Salary`(in millions) was calculated based on the weekly `Wage` data
    from the FIFA dataset
  - `Domestic` was assigned a value of 1 when a player had the same
    `Nationality` as the league’s `Country`
  - `Overpaid_Index` was calculated as described above

The joining of the two dataframes, and this wrangling and cleaning step
is performed by the
[`cleaning_leagues_table.r`](../src/cleaning_leagues_table.ipynb) script
in the [`src`](../src/) directory using the programming language R (R
Core Team 2019) and the tidyverse (Wickham 2017) package.

### Analysis and Results

To test our hypothesis, we used R’s (R Core Team 2019) `lm()` function
to build linear models and the `broom` (Robinson and Hayes 2019) package
to view and interpret results. Our steps were as follows:

  - First, we fit a simple linear model associating `Overpaid_Index`
    with the player type (either `Domestic` or `Foreign`) as a baseline.
  - We then fit an additive linear model to see the effect of both
    `League` and the player type (either `Domestic` or `Foreign`) on the
    `Overpaid_Index`.
  - We also fit a linear model with interaction to see whether the
    relation between the player type and `Overpaid_Index` changes for
    different leagues.

Once we had our three models, we used the `anova()` function to see if
our additive and interaction models with the extra `League` term
significantly improved our simple baseline model. Our findings were as
follows:

  - *Comparing additive model to baseline*: adding the extra `League`
    term in the additive model improved the baseline model at the 0.05
    significance level (the p-value was 1.82e-36).
  - *Comparing model with interaction to additive*: adding the
    interaction term significantly improved the additive model at the
    0.05 significance level (the p-value was 1.1e-06).

Based on these results, we concluded that it was important to use our
interaction model and look at the relationship for each league. The
overall results are summarized in Table 2 below.

<table>

<caption>

**Table 2. Results of Comparing the Relationship of Player Origin to
Overpaid Index**

</caption>

<thead>

<tr>

<th style="text-align:left;">

League

</th>

<th style="text-align:left;">

Domestic Mean Overpaid Index

</th>

<th style="text-align:left;">

Foreign Mean Overpaid Index

</th>

<th style="text-align:left;">

Difference

</th>

<th style="text-align:left;">

p\_value

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Bundesliga

</td>

<td style="text-align:left;">

14.1

</td>

<td style="text-align:left;">

18.6

</td>

<td style="text-align:left;">

\-4.49

</td>

<td style="text-align:left;">

2.16e-25

</td>

</tr>

<tr>

<td style="text-align:left;">

LaLiga

</td>

<td style="text-align:left;">

16

</td>

<td style="text-align:left;">

35

</td>

<td style="text-align:left;">

\-19

</td>

<td style="text-align:left;">

5.1e-06

</td>

</tr>

<tr>

<td style="text-align:left;">

Ligue 1

</td>

<td style="text-align:left;">

11

</td>

<td style="text-align:left;">

17.4

</td>

<td style="text-align:left;">

\-6.46

</td>

<td style="text-align:left;">

0.229

</td>

</tr>

<tr>

<td style="text-align:left;">

Premier League

</td>

<td style="text-align:left;">

23.7

</td>

<td style="text-align:left;">

42

</td>

<td style="text-align:left;">

\-18.3

</td>

<td style="text-align:left;">

2.72e-25

</td>

</tr>

<tr>

<td style="text-align:left;">

Serie A

</td>

<td style="text-align:left;">

15.8

</td>

<td style="text-align:left;">

23.7

</td>

<td style="text-align:left;">

\-7.86

</td>

<td style="text-align:left;">

0.0828

</td>

</tr>

</tbody>

</table>

From Table 2 we see that there is a difference in the mean overpaid
index between domestic and foreign players, however it is not what we
expected. Foreign players have a higher mean overpaid index than
domestic players. Looking at the p-values, this relationship is
significant for 4 out the 5 top leagues. The only exception is France’s
Ligue 1 where the p-value of 0.115 indicates that the difference in mean
overpaid index between domestic and foreign players is not significant
at the 0.05 level.

Figure 1 shows all the data graphically.

![](../results/img/overpaid_plot.png)

Looking at the figure, this pattern that foreign players are more
overvalued than domestic players becomes more clear. The black diamonds
on each plot represent the mean overpaid index and the jittered points
in the background represent all players. Even though there is scatter,
we see that upper end of the overpaid index distribution (the most
overpaid players) is higher for foreign players in all cases. It should
also be noted that the data has been plotted on a log scale, so the
magnitude of the differences are actually greater than they may first
appear. Finally we see the biggest difference in Spain’s LaLiga and
England’s Premier League, showing that my original hypothesis may have
been extremely misguided.

*Note: The analysis described above is performed by the
[`analysis_overpaid.r`](../src/analysis_overpaid.r) script in the
[`src`](../src/) directory.*

## Conclusions

We set out to test the hypothesis that the mean overpaid index is
greater for domestic players than foreign players in the top 5 soccer
leagues. This was based on the theory that league homegrown quota rules
result in domestic players being overvalued. We built linear models to
test whether there was a significant relationship between a player’s
origin and their overpaid index and found that the relationship depends
on the league the player is in. Our final results showed that there was
a significant relationship between mean overpaid index and player origin
for 4 out of the 5 leagues. However, the finding was that it is in fact
foreign players who are more overvalued.

Not only was our original hypothesis disproven; but instead we found
that the opposite was true\!

*This report was prepared with R’s (R Core Team 2019) `kableExtra` (Zhu
2019) and `knitr` (Xie 2014) packages*

# References

<div id="refs" class="references">

<div id="ref-kaggle_fifa">

Gadiya, Karan. n.d. “FIFA 19 Complete Player Dataset.” Accessed January
16, 2020. <https://www.kaggle.com/karangadiya/fifa19>.

</div>

<div id="ref-fifa">

Games, EA. 2019. “FIFA 19 All Teams and Clubs.” 2019.

</div>

<div id="ref-R">

R Core Team. 2019. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

</div>

<div id="ref-broom">

Robinson, David, and Alex Hayes. 2019. *Broom: Convert Statistical
Analysis Objects into Tidy Tibbles*.
<https://CRAN.R-project.org/package=broom>.

</div>

<div id="ref-tidyverse">

Wickham, Hadley. 2017. *Tidyverse: Easily Install and Load the
’Tidyverse’*. <https://CRAN.R-project.org/package=tidyverse>.

</div>

<div id="ref-knitr">

Xie, Yihui. 2014. “Knitr: A Comprehensive Tool for Reproducible Research
in R.” In *Implementing Reproducible Computational Research*, edited by
Victoria Stodden, Friedrich Leisch, and Roger D. Peng. Chapman;
Hall/CRC. <http://www.crcpress.com/product/isbn/9781466561595>.

</div>

<div id="ref-kableExtra">

Zhu, Hao. 2019. *KableExtra: Construct Complex Table with ’Kable’ and
Pipe Syntax*. <https://CRAN.R-project.org/package=kableExtra>.

</div>

</div>
