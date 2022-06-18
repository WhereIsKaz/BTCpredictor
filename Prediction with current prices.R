#installation for all packages
install.packages("dplyr")
install.packages('dygraphs')
install.packages('prophet')
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("rmarkdown")
install.packages('forecast')
#loading packages

library(dplyr)
library(dygraphs)
library(prophet)
library(tidyverse)
library(ggplot2)
library(Quandl)
library(forecast)

#Searching for updated data with Quandl
btcsearch <- Quandl.search("bitcoin usd", Silent = F)

#Loading the Dataset
bitcoin <- Quandl("BITFINEX/BTCUSD", type = "xts")


#head(bitcoin)

# Reformat XTS to dataframe
bitcoin <- fortify(bitcoin)

btcpredict <- data.frame(bitcoin$Last,bitcoin$Index)

btcpredict %>% rename(y = bitcoin.Last, dates = bitcoin.Index)

#Calling the Prophet Function to Fit the Model
Model1 <- prophet(btcjan)
Future1 <- make_future_dataframe(Model1, periods = 182)
tail(Future1)
Forecast1 <- predict(Model1, Future1)
tail(Forecast1[c('ds','yhat','yhat_lower','yhat_upper')])
#Plotting the Model Estimates
dyplot.prophet(Model1, Forecast1)
prophet_plot_components(Model1, Forecast1)

#Tuning 
dataprediction <- data.frame(Forecast1$ds,Forecast1$yhat)
trainlen <- length(btcjan$y)
dataprediction <- dataprediction[c(1:trainlen),]
accuracy(btcjan$y, Forecast1$yhat)
