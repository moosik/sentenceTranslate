library(shiny)

shinyUI(fluidPage(
  titlePanel("Test your Spanish Vocabulary from Duolingo"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("levelchoiceslider"),
      sliderInput("numbersentences", "Choose number of sentences", 
                  min = 5, max = 30, value = 15, step = 1),
      actionButton("button", "Submit")),
    mainPanel(
    textOutput("text")
    )
  )
))