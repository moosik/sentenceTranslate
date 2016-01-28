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
      # Button to start the test will be shown after the "submitparameters"
      # button was pressed 
      conditionalPanel("input.submitparameters",
                       actionButton("teststartbutton", "Start Test")),
      
      
      # Upon pressing teststartbutton display the Spanish sentence,
      # text input box for the translation and the button submittranslation
      conditionalPanel("input.teststartbutton",
                       textOutput("spanish"),
                       textInput("yourtranslation", 
                                 label = "Enter your translation in the box below",
                                 value = "your translation"),
                       actionButton("submittranslation", "Check answer"))
      
      )
  )
))