# NYC-uberpickup-prediction

## Introduction

This project focuses on using machine-learning methods to predict the uber demand and visualize it in the shiny app. Shiny app provides an interactive way to understand the change of parameters, which is extremely helpful for selecting the models. Using this app, users can build the models as they want, and select the model with best performance by using RMSE. We can actually see from the results that, ARIMA can be relatively unstable, although it’s suitable for predicting time series data. Weather information is also helpful for building the GLM model. With weather features, GLM model can end up with relatively small RMSE.
