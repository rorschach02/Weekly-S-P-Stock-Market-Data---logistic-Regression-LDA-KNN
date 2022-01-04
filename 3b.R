
## Loading all the libraries 
library(ISLR)
library(corrplot)
library(MASS)
library(klaR)
library(leaps)
library(lattice)
library(ggplot2)
library(corrplot)
library(car)
library(caret)
library(class)

?Weekly
## Loading dataset 
data("Weekly")
dim(Weekly)
head(Weekly)
str(Weekly)
data1 <- Weekly

# finding null values 
NAmat = matrix(as.numeric(is.na(data1)) , ncol = 9)
head(NAmat,50)
nonNAdx = which(rowSums(NAmat) == 0)
## so no missing value as length of nonNAdx is equal to number of rows in dataset 
length(nonNAdx)

## Visualizing the data set 

# scatter-plots 
colnames(data1)
x11()
scatterplotMatrix(~Direction+Lag1+Lag2+Lag3+Lag4+Lag5, data=data1, main="Scatterplot Matrix with Features : Direction+Lag1+Lag2+Lag3+Lag4+Lag5")

x11()
scatterplotMatrix(~Direction+Volume+Today, data=data1, main="Scatterplot Matrix with Features : Direction+Volume+Today")


# Barplots 
# Which year has more ups and which year has more down.
Up_Year <- table(Weekly$Year[data1$Direction == 'Up'])
Up_Year

x11()
barplot_up <- barplot(Up_Year, main = "Years with Up Direction ", col = "light blue", xlab = "Years" , ylim = c(0, 40), ylab = "count")                               
text(x = barplot_up,  y = Up_Year + 2 , labels = Up_Year )

head(data1$Direction , 10)
#down
Down_Year <- table(Weekly$Year[Weekly$Direction == 'Down'])
Down_Year

x11()
barplot_up <- barplot(Down_Year, main = "Years with Down Direction ", col = "light blue", xlab = "Years" , ylim = c(0, 35), ylab = "count")                               
text(x = barplot_up,  y = Down_Year + 2 , labels = Down_Year )

#Histogram
x11()
hist(Weekly$Volume , ylim = c(0,600) , xlab = "Volumn of Share Traded"  ,  main = "Histogram of Volumn of share Traded in Billion")

#Plot
x11()
plot(Weekly$Year,Weekly$Today , xlab = "Percentage return for this week" , ylab = "Year" , main= "Year v/s Today's Week percentage plot")


#correlation plots 
cor(subset(data1, select = -Direction))
corrplot(cor(data1[,1:8]), method="pie")

# with direction as well, first i need to convert it into numbers so : 0 and 1
Directions <- ifelse(data1$Direction == "Up", 1 , 0)
## Sanity check 
table(Directions)
table(data1$Direction)

data2 <- data1[,1:8]
data2 <- cbind(data2 , Directions)
head(data2 , 3)

?Weekly

## correlation plot with target feature
corrplot(cor(data2), method="pie")


## Logistic Regression ## 

logistic_reg <- glm(Direction~Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,data = data1, family = binomial)
logistic_reg
summary(logistic_reg)
## Lag2 seems to be significant feature according to this.

## predicting the fitted model and computing confusion matrix

pred_model = predict(logistic_reg, type="response")

pred_values = rep("Down", length(data1$Direction))
pred_values[pred_model > 0.5] = "Up"

confusion_matrix <- table(pred_values, data1$Direction)
confusion_matrix1 <- confusionMatrix(confusion_matrix)
names(confusion_matrix1)
accuracy_logistic_model <- 100 * confusion_matrix1$overall[1] 
##Accuracy is : 56.11
round(accuracy_logistic_model, digits = 2)


## Now train data will be data from year 1990 - 2008 and test data wil be data from 2009 and 2010.  
table(data1$Year)
train_data <- subset(data1 , Year < 2009)
test_data <- subset(data1, Year > 2008)
head(data1)
#Now I'll run logistic regression using only Lag2 as predictor.
training_log_reg <- glm(Direction~Lag2, data = train_data , family = binomial)

## now I'll predict the fitted model on data of 2009 and 2010 (test data)
test_prediction <- predict(training_log_reg , test_data , type = "response")

#computing confusion matrix 
y_test <- rep("Down", length(test_data$Direction))
y_test[test_prediction > 0.5] = "Up"
test_confusion_matrix <- table(y_test , test_data$Direction)
test_confusion_matrix1 <- confusionMatrix(test_confusion_matrix)
#Accuracy is: 62.5
round(test_confusion_matrix1$overall[1]*100 , digits = 2)


## LDA ## 
train_lda <- lda(Direction~Lag2 , data = train_data)
train_lda

##plotting lda ##
x11()
plot(train_lda)

## fitting model to test data ## 
test_pred_lda <- predict(train_lda, test_data)
test_pred_lda

## confusion matrix and computing error 
confusion_matrix_lda <- table(test_pred_lda$class , test_data$Direction)
confusion_matrix_lda1 <- confusionMatrix(confusion_matrix_lda)
# Accuracy is : 62.5
round(confusion_matrix_lda1$overall[1]*100 , digits = 2)


## KNN = 1 ##
x_train <- subset(train_data , select = -c(9))
x_test <- subset(test_data , select = -c(9))
set.seed(1)
testing_knn <- knn(x_train , x_test , train_data$Direction , k=1)
confusion_matrix_knn <- table(testing_knn , test_data$Direction)
confusion_matrix_knn1 <- confusionMatrix(confusion_matrix_knn)

# Accuracy of KNN is : 79.81
round(confusion_matrix_knn1$overall[1]*100 , digits = 2)


# Transforming and Interacting with predictors
# First i would like to take today(this week) and Lag1 (last week) as predictors
#Logistic Regression 

logistic_reg1 <- glm(Direction~Lag1:Today, data = train_data, family = binomial)
pred_model1 = predict(logistic_reg1, type="response")
pred_model1

pred_values1 = rep("Down", length(train_data$Direction))
pred_values1[pred_model1 > 0.5] = "Up"


confusion_matrix_interaction1 <- table(pred_values1, train_data$Direction)
confusion_matrix_interaction2 <- confusionMatrix(confusion_matrix)
names(confusion_matrix_interaction2)
accuracy_logistic_model <- 100 * confusion_matrix_interaction2$overall[1] 
##Accuracy is : 55.43
round(accuracy_logistic_model, digits = 2)


#LDA : with LAG1 , LAG2 ,LAG3 , LAG4 AND LAG5 are predictors.
train_lda1 <- lda(Direction~Lag1*Lag2*Lag3*Lag4*Lag5 , data = train_data)
train_lda1

## fitting model to test data ## 
test_pred_lda1 <- predict(train_lda1, test_data)


## confusion matrix and computing error 
confusion_matrix_lda_interaction1 <- table(test_pred_lda1$class , test_data$Direction)
confusion_matrix_lda_interaction2 <- confusionMatrix(confusion_matrix_lda_interaction1)
# Accuracy is : 51.92
round(confusion_matrix_lda_interaction2$overall[1]*100 , digits = 2)

## KNN with K =5 
set.seed(1)
testing_knn1 <- knn(x_train , x_test , train_data$Direction , k=5)
confusion_matrix_knn2 <- table(testing_knn1 , test_data$Direction)
confusion_matrix_knn3 <- confusionMatrix(confusion_matrix_knn2)

# Accuracy of KNN is : 88.46
round(confusion_matrix_knn3$overall[1]*100 , digits = 2)

##KNN with k =10 
set.seed(1)
testing_knn2 <- knn(x_train , x_test , train_data$Direction , k=10)
confusion_matrix_knn4 <- table(testing_knn2 , test_data$Direction)
confusion_matrix_knn5 <- confusionMatrix(confusion_matrix_knn4)

# Accuracy of KNN is : 85.58
round(confusion_matrix_knn5$overall[1]*100 , digits = 2)


