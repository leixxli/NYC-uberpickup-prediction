source('pre_process.R')

library(shiny)
library(plotly)
library(shinythemes)

library(dplyr)
library(forecast)
library(tseries)

ui <- navbarPage( theme = shinytheme("cerulean"),"Uber Pickups   ",
                  tabPanel("Overview"
                           ,fluidRow(column(10,
                                            includeMarkdown("Overview.Rmd")))),
                  navbarMenu("Data Visualization",
                             tabPanel("Boroughs",
                                      sidebarPanel(
                                        selectInput("var1", "Choose Time Range:", 
                                                    choices= time_col),
                                        helpText("May take a while. Please wait.")),
                                      mainPanel(
                                        plotOutput("plot1"))
                             ),
                             
                             tabPanel("Time",
                                      sidebarPanel(
                                        selectInput("var2", "Choose Borough:", 
                                                    choices= bor_col)),
                                      mainPanel(
                                        plotOutput("plot2"))
                             ),
                             tabPanel("Weather",
                                      sidebarPanel(
                                        selectInput('wb','Boroughs:',choices=bor_col),
                                        selectInput('wx', 'X', colnames(weather)),
                                        selectInput('wy', 'Y', colnames(weather)),
                                        helpText("Please select x and y feature to check the relationship.")
                                      ),
                                      
                                      mainPanel(plotOutput('plot3'))
                             )
                  ),
                  navbarMenu("Prediction",
                             tabPanel("GLM",
                                      fluidRow(
                                        column(4,
                                               wellPanel(
                                                 selectInput('glm_b','Choose Boroughs:',choices=use_col),
                                                 checkboxGroupInput("checkGroup", label = "Dataset Features:", 
                                                                    choices = feature_list, inline = F,
                                                                    selected = names(feature_list)),
                                                 code("please always select 'pickups'. "),
                                                 helpText("Lag_1 hour means the number of pickups from last hour, and so forth.\n
                                                          Other features are all about weather variables.")
                                                 )
                                               ),
                                        column(6, offest = 6,
                                               tabsetPanel(type = "tabs",
                                                           tabPanel("Plot", plotOutput("plot4"),verbatimTextOutput("rmse_glm")), # Plot
                                                           tabPanel("Model Summary", verbatimTextOutput("summary")) # Regression output
                                                           
                                               )))
                                      ),
                             tabPanel("ARIMA",
                                      fluidRow(
                                        column(3,
                                               wellPanel(
                                                 selectInput('ari_b','Choose Boroughs:',choices=use_col),
                                                 p(strong("For Seasonal part:")),
                                                 sliderInput("s_d", em("D:"),width='200px',min = 0, max = 3, value = 2),
                                                 sliderInput("s_p", em("P:"),width='200px',min = 0, max = 3, value = 1),
                                                 sliderInput("s_q", em("Q:"),width='200px',min = 0, max = 3, value = 0),
                                                 helpText("*D,P,Q only affect the result of arima model."))
                                        ),
                                        
                                        
                                        column(6, offest = 6,
                                               tabsetPanel(type = "tabs",
                                                           tabPanel("Plot", 
                                                                    plotOutput("plot5"),
                                                                    verbatimTextOutput("rmse_ari")),
                                                           tabPanel("Decomposition", plotOutput("plot6"),
                                                                    verbatimTextOutput("check_station")), # Decomposition of time series
                                                           tabPanel("Autocorrelation", plotOutput("plot7"),
                                                                    plotOutput("plot8"))
                                                           
                                               )),
                                        column(3,wellPanel(p(strong("For Non-seasonal part:")),
                                                           sliderInput("c_d", em("d:"), width='200px',min = 0, max = 5, value = 0),
                                                           sliderInput("c_p",em("p:"),width='200px',min = 1, max = 5, value = 1),
                                                           sliderInput("c_q",em("q:"),width='200px',min = 1, max = 5, value = 1),
                                                           helpText("*Choose D to check the change of Decomposition and Autocorrelation, 
                                                                    which can help decide P and Q."))
                                               
                                        )                        
                                      ))
),
tabPanel('References'
         ,fluidRow(column(10,
                          includeMarkdown("References.Rmd"))))

)

