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
      # action button needs to show after the submit button
      conditionalPanel("input.button",
                       actionButton("teststartbutton", "Start Test!")),
      # Conditional Panel for the test of the sentences
      conditionalPanel("input.teststartbutton",
                       textOutput("spanish"),
                       textInput("yourtranslation", 
                                 label = "Enter your translation in the box below",
                                 value = "your translation"),
                       actionButton("submittranslation", "Submit"))
      )
      # Next to figure out: how to set the conditional to 0 for the submittranslation
#     textOutput("spanish"),
#     textInput("yourtranslation", label = "Enter your translation in the box below",
#               value = "your translation"),
#     actionButton("submittranslation", "Submit"),
#     textOutput("english"),
#     radioButtons("check", label = "Was your translation correct?", choices = c("Yes", "No"),
#                  selected = "No")
  )
))