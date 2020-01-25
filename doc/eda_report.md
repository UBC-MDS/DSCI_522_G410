Are Domestic Soccer Players Overpaid?
================

### Exploratory Data Analysis For Fifa 19 Dataset

We are making analysis about the Fifa 19 complete player dataset \[1\].
The dataset has about 80 attributes for all soccer players in FIFA 2019.
The attributes include some basic information such as player age, club,
position, wage, overall rating of the players according to their skills
and performance as well as more detailed characteristics such as
stamina, strength, interceptions, etc.

Our main goal of the project is that we are trying to understand the
most important features in determining a soccer player’s salary and
whether the domestic soccer players are overpaid. To get more insight on
the dataset, we start with looking at the distribution of the `Wage`
column.

<img src="../results/images/wage_histogram.png" title="Figure 1. The distribution of the players' wage." alt="Figure 1. The distribution of the players' wage." width="100%" />

So, we see that the distribution of the salary is higly skewed and there
some outliers which can be considered as a sign that there maybe some
features lead drastical increase in the salary.

We can look at the correlation matrix to see which features have a high
correlation with the wage. These features will be valuable to use for
our analysis.

<table>

<caption>

**Table 1. Top 20 Features Correlated with Player Wage (Ignoring
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

0.7277567

</td>

</tr>

<tr>

<td style="text-align:left;">

International.Reputation

</td>

<td style="text-align:right;">

0.6701575

</td>

</tr>

<tr>

<td style="text-align:left;">

Overall FIFA Rating

</td>

<td style="text-align:right;">

0.6630327

</td>

</tr>

<tr>

<td style="text-align:left;">

Reactions

</td>

<td style="text-align:right;">

0.5352335

</td>

</tr>

<tr>

<td style="text-align:left;">

Potential

</td>

<td style="text-align:right;">

0.5075673

</td>

</tr>

<tr>

<td style="text-align:left;">

Composure

</td>

<td style="text-align:right;">

0.4726412

</td>

</tr>

<tr>

<td style="text-align:left;">

Special Skills

</td>

<td style="text-align:right;">

0.4542754

</td>

</tr>

<tr>

<td style="text-align:left;">

ShortPassing

</td>

<td style="text-align:right;">

0.4338597

</td>

</tr>

<tr>

<td style="text-align:left;">

BallControl

</td>

<td style="text-align:right;">

0.4334185

</td>

</tr>

<tr>

<td style="text-align:left;">

LongPassing

</td>

<td style="text-align:right;">

0.3122152

</td>

</tr>

<tr>

<td style="text-align:left;">

Vision

</td>

<td style="text-align:right;">

0.3115009

</td>

</tr>

<tr>

<td style="text-align:left;">

Dribbling

</td>

<td style="text-align:right;">

0.3104430

</td>

</tr>

<tr>

<td style="text-align:left;">

ShotPower

</td>

<td style="text-align:right;">

0.2944712

</td>

</tr>

<tr>

<td style="text-align:left;">

Skill.Moves

</td>

<td style="text-align:right;">

0.2766217

</td>

</tr>

<tr>

<td style="text-align:left;">

Curve

</td>

<td style="text-align:right;">

0.2748873

</td>

</tr>

<tr>

<td style="text-align:left;">

Volleys

</td>

<td style="text-align:right;">

0.2680204

</td>

</tr>

<tr>

<td style="text-align:left;">

LongShots

</td>

<td style="text-align:right;">

0.2609602

</td>

</tr>

</tbody>

</table>

From Table 1, we see that the `Overall FIFA rating`,`Potential` of the
player and also some skill set of the players such as `Reaction`,
`Composure` are highly correlated with a player’s wage. We also see that
`Club_value` is another good feature to look at.

We also need to be aware of that there might be some other features
highly related with the wage, but not having a positive or negative
correlation such as `Age` and `BMI`.

The following plots show the distribution of some candidates
features.

<img src="../results/images/age_bmi_and_overall_distribution.png" title="Figure 1. The distribution of the players' wage." alt="Figure 1. The distribution of the players' wage." width="100%" />
The distribution of `Age` shows that the players are generally between
the age 20 and 35. When we look at the overall ratings, there are only a
few players having greater than 90, the general overall rating is around
65-70. The relation of the these attributes with the salary can be seen
in the below
plots.

<img src="../results/images/age_bmi_and_overall_vs_wage.png" title="Figure 1. The distribution of the players' wage." alt="Figure 1. The distribution of the players' wage." width="100%" />

The first plot shows that the players of the age between 20 and 30
earning the most and after the age of 35 the wage drastically drops. The
last plot suggests that there are high number of players having overall
rating between 70-80 and the players with rating higher than 85 have
very high salaries.

The `Club` of a player is also an important features to
analysis

<img src="../results/images/club_value_vs_wage.png" title="Figure 1. The distribution of the players' wage." alt="Figure 1. The distribution of the players' wage." width="100%" />

So, the plot shows that there are gaps between clubs in terms of their
values and it is likely that the richest clubs also have the highest
paid players which is intuitive. But we also want to see the distrubtion
of wage in some clubs and we firstly look at a few famous
clubs.

<img src="../results/images/wage_distribution_in_the_richest_clubs.png" title="Figure 1. The distribution of the players' wage." alt="Figure 1. The distribution of the players' wage." width="100%" />
So, these clubs are high paid their players but even for them, the
distribution of wage is different from each other. The following plot
shows the distribution of the wage in any random
clubs.

<img src="../results/images/wage_distribution_in_random_clubs.png" title="Figure 1. The distribution of the players' wage." alt="Figure 1. The distribution of the players' wage." width="100%" />

So, the `Club value` is a good indicator in the salary of the players.

After all the analysis with plots and the correlation table, we decide
to include some important features such as `Age`, `Club value`,
`Overall` and some other features related with skill set of the players
like `Potential`, `Ball controlling`, `Composure` in our model.
