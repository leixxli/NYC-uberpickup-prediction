# NYC-uberpickup-prediction

Shiny app:(​https://leixxli.shinyapps.io/uber_pickup_prediction_app/​).

## 1. Introduction

This project focuses on using machine-learning methods to predict the uber demand and visualize it in the shiny app. Shiny app provides an interactive way to understand the change of parameters, which is extremely helpful for selecting the models. Using this app, users can build the models as they want, and select the model with best performance by using RMSE. We can actually see from the results that, ARIMA can be relatively unstable, although it’s suitable for predicting time series data. Weather information is also helpful for building the GLM model. With weather features, GLM model can end up with relatively small RMSE.

## 2. Data

I acquired the dataset for this project from Kaggle. For specifically, the uber pickups raw data gained from Five Thirty Eight. Weather data is from National Centers for Environmental information. LocationID to Borough mapping is also from Five Thirty Eight.
Date range: 01/01/2015 to 30/06/2015, Number of records: 29,101 This dataset contains 13 variables:
● pickup_dt: Time period of the observations.
● borough: NYC's borough, including Bronx, Brooklyn, Queens, Manhattan, EWR
and Staten Island.
● pickups: Number of pickups for the period.
● spd: Wind speed in miles/hour.
● vsb: Visibility in Miles to nearest tenth.
● temp: temperature in Fahrenheit.
● dewp: Dew point in Fahrenheit.
● slp: Sea level pressure.
● pcp01: 1-hour liquid precipitation.
● pcp06: 6-hour liquid precipitation.
● pcp24: 24-hour liquid precipitation.
● sd: Snow depth in inches.
● hday: Being a holiday (Y) or not (N).

### 3. Exploratory Data Analysis

Before conducting exploratory data analysis, I removed missing value and changed the format of date using the package “lubridate”.
In this section, I mainly studied the relationship between pickups with different features. I divided features into 3 categories, borough, time and weather information. User can access the second Tab “Visualization” to discover the relationship between feature. I will describe this section in brief.

3.1 Pickups with boroughs
In this part, I mainly studied the relationship between pickups in different boroughs for various time periods, 6 months, 1 day. User can either select ‘Month’ or ‘Hour to check the distribution of pickup number. The following figure plots the pickups in 6 months. Different color represents different boroughs. The smoothing line is under LOESS function. (Please be noted: in the app, it may take a while to generate this plot.)

