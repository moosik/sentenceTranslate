library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # I think data processing doesn't need to be reactive:
  data<- readLines("../data/SpanishSentences.txt")
  temp <- strsplit(data, split = ";")
  english <- sapply(temp, "[", 1)
  spanish <- sapply(temp, "[", 2)
  lv <- as.numeric(sapply(temp, "[", 3))
  data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)
  data.df <- na.omit(data.df)
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    # Get the levels
    # x    <- data.df$level  
    # bins <- seq(min(data.df$level), max(data.df$level), 
    #            length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    ggplot(data.df, aes(level)) + 
      geom_histogram(binwidth = input$bins, color = "white", fill = "grey") +
      ggtitle("Sentences per level") + theme_bw()
  })
})