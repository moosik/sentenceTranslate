library(shiny)

shinyUI(fluidPage(
  titlePanel("Test your Spanish Vocabulary from Duolingo"),
  sidebarLayout(
    
    sidebarPanel(
      
      # Panel for the choices of sections from the database to be testes
      uiOutput("sectionslider"),
      
      # Panel for the number of sentences to be tested
      sliderInput("numbersentences", "Choose number of sentences", 
                  min = 5, max = 30, value = 15, step = 1),
      
      # Button to submit the sections and the number of sentences
      actionButton("submitparameters", "Submit")
      
      ),
    
    mainPanel(
      
      # Output what sections, how many sentences available and how many
      # sentences will be tested after the "submitparameters" was pressed
      textOutput("sectionsToTest"),
      textOutput("sentencesAvailable"),
      textOutput("sentencesWillTest"),
      # Add section the presents Spanish question: button Spanish and the
      # output with the Spanish sentence
      conditionalPanel("input.submitparameters",
                       actionButton("spanish", "Spanish")),
      
      conditionalPanel("input.spanish",
                       textOutput("spanishS")),
      # Add conditional panel for the English translation
      conditionalPanel("input.submitparameters",
                       actionButton("english", "English")),
      
      conditionalPanel("input.english",
                       textOutput("englishS")),
      # create a conditional panel based on english button
      conditionalPanel("input.english",
                       helpText("Was your translation correct?"),
                       actionButton("yes", "Yes"),
                       actionButton("no", "No")
                       ),
      textOutput("endtest"),
      conditionalPanel("input.english",
                       textOutput("testresult"))
    
      )
    
    
  )
))