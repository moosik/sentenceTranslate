library(shiny)

# data<- readLines("data/SpanishSentences.txt")
# temp <- strsplit(data, split = ";")
# english <- sapply(temp, "[", 1)
# spanish <- sapply(temp, "[", 2)
# lv <- as.numeric(sapply(temp, "[", 3))
# data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)

shinyServer(function(input, ouput)({
  data() <- reactive({
    data<- readLines("data/SpanishSentences.txt")
    temp <- strsplit(data, split = ";")
    english <- sapply(temp, "[", 1)
    spanish <- sapply(temp, "[", 2)
    lv <- as.numeric(sapply(temp, "[", 3))
    data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)
  })
  output$levelchoiceslider <- renderUI({
    sliderInput("sentences", "Choose from which levels the questions are presented", 
                min = min(data()$level), max = data()$level, value = min(data()$level) + 1, step = 1)
  })
  
  
  
  
  
}))