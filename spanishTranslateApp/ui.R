library(shiny)

shinyUI(fluidPage(
  titlePanel("Test your Spanish Vocabulary from Duolingo"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("levelchoiceslider"),
      sliderInput("numbersentences", "Choose number of sentences", 
                  min = 5, max = 30, value = 15, step = 1),
      actionButton("submitparameters", "Submit")),
    mainPanel(
      textOutput("sectionsToTest"),
      textOutput("sentencesAvailable"),
      textOutput("sentencesWillTest"),
      # action button needs to show after the submit button
      conditionalPanel("input.submitparameters",
                       actionButton("teststartbutton", "Start Test")),
      # Conditional Panel for the test of the sentences
      conditionalPanel("input.teststartbutton",
                       textOutput("spanish"),
                       textInput("yourtranslation", 
                                 label = "Enter your translation in the box below",
                                 value = "your translation"),
                       actionButton("submittranslation", "Check answer")),
      conditionalPanel("output.showtranslation",
                       textOutput("english"),
                       radioButtons("correctness", "Is your translation correct?",
                                    c("Yes" = "yes",
                                      "No" = "no")),
                       actionButton("nextsentence", "Next sentence"))
      
      )
  )
))