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
          paste(keys.df[1 : input$levels, "expl"], collapse = ", "), ".", sep = "")
    })
  
  # Print the sections which will be tested
  output$sectionsToTest <- renderText({
    res()
  })
  
  # Subset sentences according to the sections upon pressing the button "submitparameters"
  data.section <- eventReactive(input$submitparameters, {
    # all of a sudden I am not sure why this works
    data.df[data.df$level < input$levels, ]
    })
  
  # Check whether there is enough sentences upon pressing the button "submitparameters"
  tobe.tested <- eventReactive(input$submitparameters, {
    sentenceAvailabilityForTest(data.section(), tests = input$numbersentences)
    })
  
  # Print how many sentences total are there in the selected sections
  output$sentencesAvailable <- renderText({
    paste("This section has ", nrow(data.section()), " sentences.", sep = "")
  })
  
  # Print how many sentences will be tested 
  output$sentencesWillTest <- renderText({
    paste("We will ask you to translate ", nrow(tobe.tested()), " sentences.", sep = "")
  })
  
  # ---------------------------------------------------------
  # Create reactive values expression to advance through tobe.tested object
  spanishCounter <- reactiveValues(i = 0)
  
  # Observe the button "spanish": if the counter is less the number of
  # rows in the tobe tested object then continue increasing the counter
  # otherwise set it to NULL
#   observe({input$spanish
#     isolate({
#       if(spanishCounter$i < nrow(tobe.tested())){
#         spanishCounter$i <- spanishCounter$i + 1
#       }
#       else{
#         spanishCounter$i <- NULL
#       }
#       })
#     })
  observeEvent(input$spanish,
               # We observe the button Spanish but don't take dependency
               # on it
               {
                 isolate({
                   if(spanishCounter$i < nrow(tobe.tested())){
                     spanishCounter$i <- spanishCounter$i + 1
                   }
                   else{
                     spanishCounter$i <- NULL
                   }
                 }) 
               })
  
  # Produce the sentence for translation
  output$spanishS <- renderText({
    paste(tobe.tested()[spanishCounter$i, 2])
  })
  
  # Create another reactive values output
  englishShow <- reactiveValues(data = NULL)
  
  # Upon pressing the button Spanish English panel with a translation
  # reactive values in englishShow should be set to NULL
  observe({input$spanish
    isolate({englishShow$data <- NULL})
  })
  
  # Upon pressing the English button we should get the English
  # translation
  observe({ input$english
    isolate({ englishShow$data <- tobe.tested()[spanishCounter$i, 1] })
    })
  
  # Produce English output
  output$englishS <- renderText({
    if (is.null(englishShow$data)) return()
    englishShow$data # this one and below work
    #paste(tobe.tested()[spanishCounter$i, 1])
  })
  
  # Writing an observer to keep track of the answers
  answerCounter <- reactiveValues(i = 0)
  
  # If we hit yes, then the counter of correct answers will increse
  observeEvent(input$yes,{
    isolate(answerCounter$i <- answerCounter$i + 1)
  })
  
  # If we hit no then the counter of correct answers will stay the same
  observeEvent(input$no,{
    isolate(answerCounter$i <- answerCounter$i)
  })
  
  # The test will end when the counter for sentences turns to NULL
  output$endtest <- renderText({
    if(is.null(spanishCounter$i)){
      return("You are done!")
    }
  })
  # Provide the score
  output$testresult <- renderText({
    paste("Your current score is", answerCounter$i, sep = " ")
  })

}))