# Weekly S&amp;P Stock Market Data -- Logistic Regression , LDA &amp; KNN
## Dataset: 
The dataset can be found in ISLR library in R. 

#### Description: 
Weekly percentage returns for the S&P 500 stock index between 1990 and 2010.

#### Format: 
A data frame with 1089 observations on the following 9 variables.

Year
The year that the observation was recorded

Lag1
Percentage return for previous week

Lag2
Percentage return for 2 weeks previous

Lag3
Percentage return for 3 weeks previous

Lag4
Percentage return for 4 weeks previous

Lag5
Percentage return for 5 weeks previous

Volume
Volume of shares traded (average number of daily shares traded in billions)

Today
Percentage return for this week

Direction
A factor with levels Down and Up indicating whether the market had a positive or negative return on a given week

## Libraries: 
-- ISLR <br/>
-- corrplot <br/>
-- MASS <br/>
-- klaR <br/>
-- leaps <br/>
-- lattice <br/>
-- ggplot2 <br/>
-- corrplot <br/>
-- car <br/>
-- caret <br/>
-- class <br/>

## Scatter-Plots: 


![scatterplot1_ques2](https://user-images.githubusercontent.com/46763031/148004635-86c0288e-7416-4c91-ae50-e8a189dcddf3.png)

![scatterplot2_ques2](https://user-images.githubusercontent.com/46763031/148004644-87eae9dc-aff3-46f9-b523-9d134f444bc5.png)

From the plots above it can be told that except volume feature all the other features have normal distribution. All the features are also co-related to each other as the points in all the graph forms a cluster in the center of the graph meaning the points of both the feature in a given graph are overlapping each other.

## Histogram:

![histogram](https://user-images.githubusercontent.com/46763031/148004862-e9c4eb16-6ecb-432a-8edc-d25e90302815.png)

## Pair-Plots:

![pair-plots](https://user-images.githubusercontent.com/46763031/148004879-56d997cb-3a20-4217-b8da-5f1f1c3a7dba.png)

## Co-relation Plot:

![co-relation plot](https://user-images.githubusercontent.com/46763031/148004900-944781f4-81d3-494f-8cbd-650dddcdef3f.png)

So, Volume and Year are highly co-related to each other that means volumes of share trading as increased over the years. All the other features are positively corelated to each
other as well. 

## Logistic Regression: 

Logistic Regression uses linear regression with the addition of sigmoid function which helps in returning output in between 0-1 range. Here as i have two
categorical features ‘UP’ and ‘DOWN’, if the logistic regression returns value lower than 0.5 I’ll classify that as ‘DOWN’ and it returns value more than that then I’ll classify that as ‘UP’. R uses glm.net to do logistic regression.

I got the accuracy of 56.11% and error rate of 43.89% from logistic regression model.

## LDA:

Linear Discriminant analysis is a true decision boundary discovery algorithm. It assumes that the class has common covariance and it’s decision boundary is linear
separating the class.

![LDA_plot](https://user-images.githubusercontent.com/46763031/148005097-5e55f757-3a5b-46f3-b3c8-519af04569e4.png)

This plot tells me that the two classes are overlapping. This will cause a lot of misclassification in the LDA model.

I get the accuracy of 62.5% and error rate of 37.5% from LDA model with just Lag2 as predictor. This is exactly the same accuracy that i got from logistic regression with just
Lag2 as predictor.

## KNN: 
I get the accuracy of 79.81% and error rate of 20.19% from KNN model with K=1. This is even worse than LDA and logistic regression.

## Results:

![result_ques2](https://user-images.githubusercontent.com/46763031/148005194-82e9291c-0b27-46a0-8048-b1474ea9334a.png)

So, out of all the models, LDA and Logistic Regression with Lag2 as predictors worked the best. As I saw in the scatterplots that the data follows normal distribution so it’s anyway better to use LDA as it separates classes by drawing a linear decision boundary.




