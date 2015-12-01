library(shiny)

data<- readLines("data/SpanishSentences.txt")
temp <- strsplit(data, split = ";")
english <- sapply(temp, "[", 1)
spanish <- sapply(temp, "[", 2)
lv <- as.numeric(sapply(temp, "[", 3))
data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)

shinyServer(function(input, output)({
  output$levelchoiceslider <- renderUI({
    sliderInput("sentences", "Choose from which levels the questions are presented", 
                min = min(data.df$level), 
                max = max(data.df$level), 
                value = min(data.df$level) + 1, 
                step = 1)
  })
  output$text <- renderText({
    input$sentences
  })
  
  
  
  
  
  
}))