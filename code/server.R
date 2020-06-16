
source('pre_process.R')

library(shiny)
library(plotly)
library(shinythemes)

library(dplyr)
library(forecast)
library(tseries)

server <-function(input, output){
  
  #---plot1 -borough/time
  output$plot1 = renderPlot({
    ggplot(data, aes(data[,c(input$var1)], pickups)) +
      geom_jitter(alpha = 0.3, aes(colour = borough)) +
      stat_smooth(aes(color = borough),method = "loess")+
      scale_y_log10()+
      scale_color_brewer(palette="Set1")+
      labs(y="the number of pickups", x="Time",title="The Number of Pickups in Different Boroughs")
  })
  
  #---plot2 - weekdays weekends
  bor_data = reactive({data[ which(data$borough == input$var2),]})
  output$plot2 = renderPlot({
    ggplot(bor_data(), aes(week_mark, pickups)) +
      geom_boxplot()+
      labs(y="pickups",x="",title="The Distribution of Pickup Numbers in One Week")
  })
  
  #---plot3 - weather information 
  wea_data <- reactive({ 
    weather_data[ which(weather_data$borough == input$wb),][,c(input$wx, input$wy)]
  })
  output$plot3 = renderPlot({
    plot(wea_data(),col = rgb(0.168, 0.4, 0.933,alpha=0.6))
  })
  
  #---prediction-GLM
  # train and test features after selecting 
  use_train = reactive({
    train[which(train$borough == input$glm_b),][,input$checkGroup]
  })
  use_test.x = reactive({ 
    test[which(test$borough == input$glm_b),][,input$checkGroup]%>%
      select(-starts_with("pickups"))
  }) 
  use_test.y = reactive({test[which(test$borough == input$glm_b),][,c("pickups")] }) 
  use_test.time =reactive({test[which(test$borough == input$glm_b),][,c("pickup_dt")]})
  
  # fit the model  
  fit = reactive( {glm(pickups~.,data = use_train())})
  diff_glm = reactive({ predict(fit(), use_test.x(), type="response")})
  # Summary of model
  output$summary = renderPrint({
    summary(fit())
  })
  
  # RMSE-train/test
  output$rmse_glm = renderText({
    rmse_test = sqrt((sum(use_test.y() - diff_glm())^2)/length(use_test.y()))
    rmse_train = sqrt(mean(fit()$residuals^2))
    paste('Train RMSE:',round(rmse_train,2), '\nTest RMSE:',round(rmse_test,2) )
    
  })
  
  
  # Plot Glm
  output$plot4 = renderPlot({
    plot(use_test.time(), diff_glm(),type = 'l',col='blue',ylim = c(min(use_test.y()),max(use_test.y())),
         main = 'GLM',xlab='Time: From 6/24 To 6/30',ylab = 'Pickups')
    lines(use_test.time(), use_test.y(), col = 'red')
    legend("topleft", legend=c("Predicted", "Actual"),
           col=c("blue", "red"), lty=1:2, cex=1)
    
  })
  
  # ---ARIMA 
  # decompose the data and check stationary
  use_value =  reactive({train[which(train$borough == input$ari_b),][,c("pickups")] }) 
  ari_test.y = reactive({test[which(test$borough == input$ari_b),][,c("pickups")] }) 
  ari_test.time = reactive({test[which(test$borough == input$ari_b),][,c("pickup_dt")]})
  
  
  ari_dat = reactive({ ts(use_value(), frequency = 24) })
  # for difference data 
  ari_data = reactive({
    if(input$c_d == 0){
      ari_data = ari_dat() 
    }else{
      ari_data = diff(ari_dat(), differences = input$c_d)
    }
    return(ari_data)
  })
  
  # plot the result of decomposition 
  output$plot6 = renderPlot({
    plot(decompose(ari_data()))
  })
  # show the diagnosis of stationary
  output$check_station =renderPrint ({
    adf.test(ari_data(), alternative = "stationary")
  })
  
  # plot the autocorrelation result
  output$plot7 = renderPlot({
    Acf(ari_data(), main='ACF') 
  })
  output$plot8 = renderPlot({
    Pacf(ari_data(), main='PACF')
  })
  
  # arima results plot
  ari_order = reactive({ as.numeric( c(input$c_d,input$c_p,input$c_q)) })
  sea_order = reactive({ as.numeric( c(input$s_d,input$s_p,input$s_q)) })
  
  ari_fit=reactive({arima(ari_data(), order=ari_order(),seasonal = sea_order(), method="CSS") }) 
  ari_pred =reactive({ predict(ari_fit(), length(ari_test.time())) })
  
  #plot 
  output$plot5 = renderPlot({
    plot(ari_test.time(), ari_pred()$pred,type = 'l',col='blue',
         ylim = c(min(ari_pred()$pred,ari_test.y()),max(ari_pred()$pred,ari_test.y())),
         main = 'ARIMA',xlab='Time: From 6/24 To 6/30',ylab = 'Pickups')
    lines(ari_test.time(), ari_test.y(), col = 'red')
    legend("topleft", legend=c("Predicted", "Actual"),
           col=c("blue", "red"), lty=1:2, cex=1)
    
  })
  
  output$rmse_ari = renderText({
    rmse_ari_test = sqrt((sum(ari_test.y() - ari_pred()$pred)^2)/length(ari_test.time()))
    rmse_ari_train = sqrt(mean(ari_fit()$residuals^2))
    paste('Train RMSE:',round(rmse_ari_train,2),'\nTest RMSE:',round(rmse_ari_test,2) )
    
  })
  
  
}
