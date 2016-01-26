library(shiny)

# Read the database with sentences
data<- readLines("data/SpanishSentences.txt")
temp <- strsplit(data, split = ";")
english <- sapply(temp, "[", 1)
spanish <- sapply(temp, "[", 2)
lv <- as.numeric(sapply(temp, "[", 3))
data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)
# Read the keys to the sections
keys <- readLines("data/section_code_keys.txt")
temp <- strsplit(keys, split = ";")
num <- sapply(temp, "[", 1)
expl <- sapply(temp, "[", 2)
keys.df <- data.frame(num, expl, stringsAsFactors = FALSE)

source("helpers.R")

shinyServer(function(input, output)({
  
  # Slider for the sections to be tested, sidebar panel
  output$sectionslider <- renderUI({
    sliderInput("levels", "Choose sections", 
                min = min(data.df$level) + 1, 
                max = max(data.df$level) + 1, 
                value = min(data.df$level) + 2, 
                step = 1)
  })
  
  # ---------------------------------------------------------
  # Events depending on the "submitparameters" = "Submit" button
  # Extract the sections to be tested
  res <- eventReactive(input$submitparameters, {
    paste("You will be asked to translate sentences from ", 
          paste(keys.df[1 : input$levels, "expl"], collapse = ", "))
    })
  
  # Print the sections which will be tested
  output$sectionsToTest <- renderText({
    res()
  })
  
  # Subset sentences according to the sections upon pressing the button "submitparameters"
  data.section <- eventReactive(input$submitparameters, {
    data.df[data.df$level < input$levels, ]
    })
  
  # Check whether there is enough sentences upon pressing the button "submitparameters"
  tobe.tested <- eventReactive(input$submitparameters, {
    sentenceAvailabilityForTest(data.section(), tests = input$numbersentences)
    })
  
  # Print how many sentences total are there in the selected sections
  output$sentencesAvailable <- renderText({
    paste("This section has", nrow(data.section()), "sentences\n", sep = " ")
  })
  
  # Print how many sentences will be tested 
  output$sentencesWillTest <- renderText({
    paste("We will test", nrow(tobe.tested()), "sentences\n", sep = " ")
  })
  
  # ---------------------------------------------------------
  # Events depending on the "teststartbutton" = "Start Test" button
  # Get the first sentence in Spanish
  spanish.sentence <- eventReactive(input$teststartbutton, {
    paste("Sentence: ", tobe.tested()[1,"spanish"], sep = "")
  })
  
  # Output the first sentence in Spanish
  output$spanish <- renderText({
    spanish.sentence()
  })
  
  # ---------------------------------------------------------
  # Events depending on the submittranslation = "Check answer" button
  # Retrieve the English translation for the sentence
  english.sentence <- eventReactive(input$submittranslation, {
    paste("The correct translation: ", tobe.tested()[1,"english"], sep = "")
  })
  
  # Print the English translation for the sentence
  output$english <- renderText({
    english.sentence()
  })
  
#   # --------------------------------------------------------
#   # Event depending on the nextsentence = "Next sentence" button
#   # Getting the next spanish sentence
#   spanish.sentence <- eventReactive(input$nextsentence, {
#     paste("Sentence: ", tobe.tested()[2,"spanish"], sep = "")
#   })
#   
#   # Output the first sentence in Spanish
#   output$spanish <- renderText({
#     spanish.sentence()
#   })
  
  
#   output$showtranslation <- reactive({
#     if(input$nextsentence == 0)
#       return(TRUE)
#     isolate({return(FALSE)})
#   })
#   outputOptions(output, 'showtranslation', suspendWhenHidden=FALSE)
#   # Continue the test based on the submit the results button

}))