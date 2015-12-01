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
    sliderInput("sentences", "Choose from which levels the questions are presented", 
                min = min(data.df$level) + 1, 
                max = max(data.df$level) + 1, 
                value = min(data.df$level) + 2, 
                step = 1)
  })
  res <- eventReactive(input$button, {
    paste("You will be asked to translate sentences from ", 
          paste(keys.df[1 : input$sentences, "expl"], collapse = ", "))})
  output$sectionsToTest <- renderText({
    res()
  })
  # select the sentences from the database for testing
  observeEvent(input$button, {cat("sentences", input$numbersentences)})
  data.section <- eventReactive(input$button, {data.df[data.df$level < input$numbersentences, ]})
  tobe.tested <- eventReactive(input$button, {sentenceAvailabilityForTest(data.section, tests = input$numbersentences)})
  output$sentencesAvailable <- renderText({
    paste("This section has", nrow(data.section()), "sentences\n", sep = " ")
  })
  output$sentencesWillTest <- renderText({
    paste("We will test", nrow(tobe.tested()), "sentences\n", sep = " ")
  })


}))