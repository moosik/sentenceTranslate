library(shiny)

shinyUI(fluidPage(
  h1("Test your Spanish Vocabulary from Duolingo", align = "center"),
  fluidRow(column(8, offset = 2,
                  p("This application tests your ability to translate
                           sentences from Spanish to English. The sentences
                           are based on the vocabulary learned in Duolingo 
                           Spanish. Choose the lessons from which the sentences should be selected and the number of sentences you want to translate."))),
  fluidRow(
      column(3, offset = 2, 
             # Panel for the choices of sections from the database to be testes
             uiOutput("sectionslider")
             ),
      column(3, 
             # Panel for the number of sentences to be tested
             sliderInput("numbersentences", "Choose number of sentences", 
                         min = 5, max = 30, value = 15, step = 1)
             ),
      column(2, 
             br(),
             # Button to submit the sections and the number of sentences
             actionButton("submitparameters", "Submit")
             )
      ),
  br(),
  fluidRow(
    column(6, offset = 2, 
           textOutput("sectionsToTest"),
           textOutput("sentencesAvailable"),
           textOutput("sentencesWillTest")
           )
      ),
  br(),
  fluidRow(
        column(4, offset = 2,
               conditionalPanel("input.submitparameters",
                                actionButton("spanish", "Spanish")),
               br(),
               conditionalPanel("input.spanish",
                                textOutput("spanishS"))),
        column(4,
               conditionalPanel("input.submitparameters",
                                actionButton("english", "English")),
               br(),
               conditionalPanel("input.english",
                                textOutput("englishS")))
      ),
  br(),
  fluidRow(
        column(4, offset = 6,
               conditionalPanel("input.english",
                                helpText("Was your translation correct?"),
                                actionButton("yes", "Yes"),
                                actionButton("no", "No")
               ),
               br(),
               textOutput("endtest"),
               br(),
               conditionalPanel("input.english",
                                textOutput("testresult")))
      ),
    title = "Duolingo Spanish")
)