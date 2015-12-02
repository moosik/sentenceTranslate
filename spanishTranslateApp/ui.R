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
    textOutput("sectionsToTest"),
    textOutput("sentencesAvailable"),
    textOutput("sentencesWillTest"),
    # Now add the butto to start the test
    actionButton("teststartbutton", "Start Test!"),
    textOutput("spanish"),
    textInput("yourtranslation", label = "Enter your translation in the box below",
              value = "your translation"),
    actionButton("submittranslation", "Submit"),
    textOutput("english"),
    radioButtons("check", label = "Was your translation correct?", choices = c("Yes", "No"),
                 selected = "No")
    )
  )
))