library(shiny)

shinyUI(fluidPage(
  #titlePanel("Test your Spanish Vocabulary from Duolingo"),
  fluidRow(
    column(11, "boohoo"),
    fluidRow(
      column(3,
             # Panel for the choices of sections from the database to be testes
             uiOutput("sectionslider"),
             
             # Panel for the number of sentences to be tested
             sliderInput("numbersentences", "Choose number of sentences", 
                         min = 5, max = 30, value = 15, step = 1),
             
             # Button to submit the sections and the number of sentences
             actionButton("submitparameters", "Submit")),
        column(8,
               textOutput("sectionsToTest"),
               textOutput("sentencesAvailable"),
               textOutput("sentencesWillTest"))
      ),
      fluidRow(
        column(3),
        column(4,
               conditionalPanel("input.submitparameters",
                                actionButton("spanish", "Spanish")),
               conditionalPanel("input.spanish",
                                textOutput("spanishS"))),
        column(4,
               conditionalPanel("input.submitparameters",
                                actionButton("english", "English")),
               conditionalPanel("input.english",
                                textOutput("englishS")))
      ),
      fluidRow(
        column(3),
        column(8, 
               conditionalPanel("input.english",
                                helpText("Was your translation correct?"),
                                actionButton("yes", "Yes"),
                                actionButton("no", "No")
               ),
               textOutput("endtest"),
               conditionalPanel("input.english",
                                textOutput("testresult")))
      )
    )
  )

  
)