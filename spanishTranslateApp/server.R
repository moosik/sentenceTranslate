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
  # Create reactive values expression to advance through tobe.tested object
  spanishCounter <- reactiveValues(i = 0)
  
  # Observe the button "spanish"
  observe({input$spanish
    isolate({
      if(spanishCounter$i < nrow(tobe.tested())){
        spanishCounter$i <- spanishCounter$i + 1
      }
      else{
        spanishCounter$i <- NULL
      }
      })
    })
  output$spanishS <- renderText({
    paste(tobe.tested()[spanishCounter$i, 2])
  })
  # Create another reactive values output
  englishShow <- reactiveValues(data = NULL)
  
  observe({input$spanish
    isolate({englishShow$data <- NULL})
  })
  
  observe({ input$english
    isolate({ englishShow$data <- tobe.tested()[spanishCounter$i, 1] })
    })
  
  output$englishS <- renderText({
    if (is.null(englishShow$data)) return()
    englishShow$data # this one and below work
    #paste(tobe.tested()[spanishCounter$i, 1])
  })
  
  output$endtest <- renderText({
    if(is.null(spanishCounter$i)){
      return("you are done")
    }
  })

}))