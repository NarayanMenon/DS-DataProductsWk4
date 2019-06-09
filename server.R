library(shiny)
library(pracma)
library(plotly)
library(tseries)

shinyServer(function(input, output) {
  observeEvent(input$Submit, {
    if (nchar(input$tickerSymbol) > 0) {
      
      ticker <- input$tickerSymbol
      beginDate <- format(Sys.Date()-365, format="%Y-%m-%d")
      endDate <- format(Sys.Date(), format="%Y-%m-%d")
      
      
      STK <- get.hist.quote(
        instrument = ticker,
        start = beginDate,
        end = endDate,
        quote = c("Close"),
        provider = "yahoo",
        compression = "d"
      )
      
      lenStk <- dim(STK)[1]
      if (lenStk < 200) {
        output$prediction <- renderText("Sufficient data not available")
        return()
      }
      
      ma20 <- movavg(STK, 20, "e")
      ma40 <- movavg(STK, 40, "e")
      
      
      myPlot <-
        plot_ly(
          x = time(STK),
          y = STK$Close,
          type = 'scatter',
          mode = 'line',
          name = 'Closing'
        ) %>%
        add_trace(y = ma40,
                  name = 'EMA-40',
                  mode = 'lines') %>%
        add_trace(y = ma20,
                  name = 'EMA-20',
                  mode = 'lines') %>%
        layout(title = ticker)
      
    }
    
    
    output$stockChart <- renderPlotly(myPlot)
    m1 <- paste("Prediction for ",ticker," ===>>> ")
    
    STK1 <- unclass(STK)
    P_1 <- STK1[lenStk] 
    P_7 <- STK1[lenStk - 7] 
    M40_1 <- ma40[lenStk]
    M40_7 <- ma40[lenStk - 7]
    M20_1 <- ma20[lenStk]
    M20_7 <- ma20[lenStk - 7]
    
    if (P_1 > P_7 * 1.05 && M20_1 > M40_1) {
      m2 <- "BUY"
    } else if (P_1 < P_7 * .95 && M20_1 < M40_1) {
      m2 <- "SELL"
    } else if (P_1 > M20_1 && M20_1 > M40_1) {
      m2 <- "BUY"
    } else if (P_1 < M20_1 && M20_1 < M40_1) {
      m2 <- "SELL"
    } else if (P_1 > P_7 * 1.05 && M20_1 < M40_1) {
      m2 <- "AVOID"
    } else if (P_1 < P_7 * .95 && M20_1 > M40_1) {
      m2 <- "AVOID"
    } else {
      m2 <- "HOLD"
    }
    
    output$prediction <- renderText(paste(m1,m2))
    output$tickerSymbol <- renderText(input$tickerSymbol)
  })
  
})