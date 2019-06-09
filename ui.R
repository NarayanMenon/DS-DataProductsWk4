library(shiny)
library(plotly)

shinyUI(pageWithSidebar(
  headerPanel("Buy/Sell Recommender for US Stocks"),
  sidebarPanel(
    textInput(inputId = "tickerSymbol", label = "Enter Ticker Symbol"),
    actionButton("Submit", "Submit"),
    tags$br(),
    tags$br(),
    span(
    p('=> Easy to use investing tool. Just enter the ticker symbol of your favorite stock and push submit.'),
    tags$br(),
    p('=> The tool will advice you on what action to take, Buy, Sell, Hold or Avoid'),
    tags$br(),
    p('=> Investing in stocks is not without risk...there is no shame in engaging a pro.'),
    style = "color:blue;font-size:15px")
  ),
  mainPanel(
    span(textOutput("prediction"), style = "color:red;font-size:20px"),
    tags$br(),
    plotlyOutput("stockChart")
  )
))
