# NYC-uberpickup-prediction

- [Shiny app](https://leixxli.shinyapps.io/uber_pickup_prediction_app/).

- [Medium Post] (https://medium.com/@leixxxli/how-to-predict-the-uber-demand-2a5321cb46a5)

## Overview

This project focuses on using machine-learning methods to predict the uber demand and visualize it in the shiny app. Shiny app provides an interactive way to understand the change of parameters, which is extremely helpful for selecting the models. Using this app, users can build the models as they want, and select the model with best performance by using RMSE. We can actually see from the results that, ARIMA can be relatively unstable, although it’s suitable for predicting time series data. Weather information is also helpful for building the GLM model. With weather features, GLM model can end up with relatively small RMSE.

## Methods 



### 3. Exploratory Data Analysis

Before conducting exploratory data analysis, I removed missing value and changed the format of date using the package “lubridate”.
In this section, I mainly studied the relationship between pickups with different features. I divided features into 3 categories, borough, time and weather information. User can access the second Tab “Visualization” to discover the relationship between feature. I will describe this section in brief.

3.1 Pickups with boroughs
In this part, I mainly studied the relationship between pickups in different boroughs for various time periods, 6 months, 1 day. User can either select ‘Month’ or ‘Hour to check the distribution of pickup number. The following figure plots the pickups in 6 months. Different color represents different boroughs. The smoothing line is under LOESS function. (Please be noted: in the app, it may take a while to generate this plot.)

