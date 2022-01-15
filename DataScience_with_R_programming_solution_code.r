from google.colab import drive
drive._mount('/content/drive')
%cd /content/drive/MyDrive/GitHubAtor
uname = 'samuel-ntsua'
repos = 'DataScience_with_R-programming'
colagit = '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'
!git clone https://{colagit}@github.com/{uname}/{repos}
%cd DataScience_with_R-programming/








# This document is generated using knitr, File->Knit Document. Knitr then runs my r-code and knit the output into this document.
# Warning: If there is a line in the code that installs a package , knitr expect the repository to be explicitly specified: install.packages(..., repos="....")


# Package installation and loading

# Package names
packages <- c("Hmisc","corrplot","PerformanceAnalytics","correlation","car","caTools")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages], repos = "http://cran.us.r-project.org" )
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))



# Importing data

library(readr)
Hcost <- read_csv("HospitalCosts.csv", TRUE)

names(Hcost)
dim(Hcost)
ls.str(Hcost)

# The structure of the data shows Gender and Race are numeric.
# We need to convert to factor so that calculation is not done on them.
# For example, if they remain numeric as opposed to factors,
# the summary function will produce the mean of Race, with is meaningless.
# For analysis reasons, I am going to create factor variable of these two variables:

Hcost$FAC_FEM <- as.factor(Hcost$FEMALE)
Hcost$FAC_RACE <- as.factor(Hcost$RACE)


# Descriptive Statistics of variables

#library(dplyr)
sapply(Hcost, summary)

# Checking on missingness
sum(is.na(Hcost))

# Checking on correlation between cost and the rest of the variables: correlation matrix.
# We want to display the correlation coefficients as well as the p-values, so we need to install the packages: "Hmisc","corrplot","PerformanceAnalytics and "correlation"


library(Hmisc); library(corrplot); library(PerformanceAnalytics) ; library(correlation)

# Correlation matrix
corM <- rcorr(as.matrix(Hcost), type="pearson")

#Instead of displaying the entire corM, let's look at the various parts we can extract

names(corM)

# We see that we can choose $r (correlation matrix), $n (case count) and $P (the p-values)
# Let's round these numbers to 2 digits after decimal.
round(corM$r,2)
round(corM$P,2)

#To easily see positive and negative correlation among variables, let's use corrplot to visualize the matrix. Especially, method="ellipse" is very useful in seeing the sign of the correlation.

corrplot(cor(Hcost[1:6]), method = "number" , type ="lower")

# Plotting the correlation, 3 variables at a time, so we don't get a cluttered graph

library(ggplot2)

pairs(Hcost[1:6],upper.panel = NULL)

# Correlation table

correl <- correlation(Hcost)
summary(correl)

chart.Correlation(Hcost[1:6], histogram=TRUE, pch=19)



# Slitting data into training and testing, using caTools package

library(caTools); library(car)

# To be able to produce the same training and testing data in the future, we set a seed to a randomly picked value.
set.seed(10)
# Splitting the data into 70/30
splitsample <- sample.split(Hcost$TOTCHG,SplitRatio = .7)

train_hcost <- subset(Hcost,splitsample==TRUE)
test_hcost <- subset(Hcost,splitsample==FALSE)

# Building the model with all variables
train_model_all <- lm(train_hcost$TOTCHG ~ ., data = train_hcost)

summary(train_model_all)

#The summary statistics of train_model show that the coefficients of AGE, LOS and APRDRG are significantly different from zero, with a confidence level of 0.05, therefore, we will include them in our final linear model.

# Building the model with significant variables only

train_model_sig <- lm(TOTCHG ~ AGE+LOS+APRDRG , data = train_hcost)

summary(train_model_sig)
names(train_model_sig)
# We check if the number of fitted values is equal to number of observations in the training data
length(train_model_sig$fitted.values)
dim(train_hcost)
# They are, so we can predict.
# Create data frames for predict and residuals of the training data.

predict_train_df <- data.frame(train_model_sig$fitted.values)
resid_train_df <- data.frame(train_model_sig$residuals)
str(resid_train_df)
# Perform prediction using testing data

predict_test_df <- predict(train_model_sig,newdata = test_hcost)
predict_test_df <- data.frame(predict_test_df)
str(predict_test_df)

# Plotting testing data versus predicted testing data

plot(test_hcost$TOTCHG,col="red",type = "l")
lines(predict_test_df,col="green", type = "l")

# Linear regression model assumptions verification: let's diagnose our linear model to see if our data does not violate the assumptions


# Test for auto-correlation in residuals

durbinWatsonTest(train_model_sig)

#==>> p-values =0.512 >> 0.001, so there is no first order correlation in residuals.

# Test for collinearity using VIF
vif(train_model_sig)
sqrt(vif(train_model_sig))>5
#==> All VIF factors are less than 5, we can conclude that there is no collinearity among the variables retained for the final model.

# Test for linearity and homoscedasticity using plot of Residual versus fitted data
plot(train_model_sig,which=1)

#==>> Except from three data points with large residuals (3,34 and 177), the data is fairly spread around the x-axis (y=0)

# Test for normality of the data using quantile-quantile plot
plot(train_model_sig,which=2)

## The data in most cases aligns with the 45 degree line, meaning the data is fairly normally distributed

# Conlusion
## Even thought the data seems not to be race-balanced, the tests of the model assumptions indicate linear regression model is appropriate for the analysis.
## The analysis shows that the model can accurately predict the cost of hospitalization using patient’s age, length of stay and diagnosis group.
