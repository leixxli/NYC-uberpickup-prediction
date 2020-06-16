
library(lubridate)
library(ggplot2)
library(cowplot)
library(MASS)
library(ggpubr)
library(PerformanceAnalytics)
library(mctest)
library(fastDummies)

# --- import data 
#setwd("/Users/spyker/Desktop")
data = read.csv(file = "uber_nyc_enriched.csv",   header=TRUE, sep=",")

# ---data cleaning and mining 
data$Month = parse_date_time(data$pickup_dt, orders= 'ymd HMS')  

# extract only hour information 
data$Hour = hour(data$Month)   #extract only hour information 
pickups = data$pickups
#  add feature->weekday or weekends 
data$week_mark = wday(data$Month, label = TRUE)
data$weekends_ornot = data$week_mark == 'Sun' | data$week_mark == 'Sat'
# remove missing values 
data = subset(data, !is.na(borough))


# --- for plotting 
# get seperate borough information 
ewr = data[ which(data$borough == 'EWR'),]
staten_island = data[which(data$borough == 'Staten Island'),]
queen = data[ which(data$borough == 'Queens'),]
bronx = data[ which(data$borough == 'Bronx'),]
brooklyn = data[which(data$borough == 'Brooklyn'),]
manhattan = data[ which(data$borough == 'Manhattan'),]


# set col names for ui interface 
time_col = c('Month','Hour')
bor_col = c("EWR","Staten Island","Queens","Bronx","Brooklyn","Manhattan")
use_col = c("Queens","Bronx","Brooklyn","Manhattan")

weather = data.frame(data[,4:8], data[,11:12],pickups = data$pickups)
weather_data = data.frame(weather, borough= data$borough)


# --- deciding to remove borough 'EWR' and 'Staten Island' for prediction
use_data = subset(data, data$borough!='EWR')
use_data = subset(use_data, use_data$borough!='Staten Island')


# change 
dummy_hday = fastDummies::dummy_cols(use_data$hday)

use_data = data.frame(use_data[,2:12],y_hday=dummy_hday$.data_Y,pickup_dt=use_data$Month)

# correlation matrix
# chart.Correlation(use_data[,3:12], histogram=TRUE, method = 'spearman',pch=19)

# --- prediction1---GLM 

lag_col = c('lag_1_hour','lag_1_day','lag_1_week')
feature_list = c("pickups"="pickups", "spd" ="spd", "vsb"="vsb",  "temp"='temp', "dewp"='dewp',"slp"='slp',"pcp01"='pcp01',
                 "pcp06"='pcp06',"pcp24"='pcp24', "sd" ='sd',"lag_1_hour"="lag_1_hour",
                 "lag_1_day"="lag_1_day","lag_1_week"="lag_1_week")

#introduce lag variables
use_data$lag_1_hour = lag(use_data$pickups)
use_data$lag_1_day = lag(use_data$pickups,24)
use_data$lag_1_week = lag(use_data$pickups,168)

use_data = subset(use_data, !is.na(lag_1_week)) # remove missing vlues since lag features brought some NAs
# split into train and test data
train = use_data[-c(16701:nrow(use_data)),]
test = use_data[c(16701:nrow(use_data)),]

# --- for arima model
library('forecast')
library('tseries')



