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
  output$levelchoiceslider <- renderUI({
    sliderInput("levels", "Choose from which levels the questions are presented", 
                min = min(data.df$level) + 1, 
                max = max(data.df$level) + 1, 
                value = min(data.df$level) + 2, 
                step = 1)
  })
  
  res <- eventReactive(input$button, {
    paste("You will be asked to translate sentences from ", 
          paste(keys.df[1 : input$levels, "expl"], collapse = ", "))
    })
  
  output$sectionsToTest <- renderText({
    res()
  })
  
  # Select the subset of the data accoring to the number of levels
  # from which the questions will be selected
  data.section <- eventReactive(input$button, {
    data.df[data.df$level < input$levels, ]
    })
  
  # Check whether there is enough senteces
  tobe.tested <- eventReactive(input$button, {
    sentenceAvailabilityForTest(data.section(), tests = input$numbersentences)
    })
  
  # Print how many sentences total are there in the selected sections
  output$sentencesAvailable <- renderText({
    paste("This section has", nrow(data.section()), "sentences\n", sep = " ")
  })
  
  # Print how many sentences will be tested depending on the requested
  # sentences and how many are available
  output$sentencesWillTest <- renderText({
    paste("We will test", nrow(tobe.tested()), "sentences\n", sep = " ")
  })
  
  # Start the test
  spanish.sentence <- eventReactive(input$teststartbutton, {
    paste("Sentence: ", tobe.tested()[1,1], sep = "")
  })
  output$spanish <- renderText({
    spanish.sentence()
  })
  english.sentence <- eventReactive(input$submittranslation, {
    paste("The correct translation: ", tobe.tested()[1,2], sep = "")
  })
  output$english <- renderText({
    english.sentence()
  })
  
}))