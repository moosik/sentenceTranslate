library(shiny)

# I've simplified the UI a little so that we can focus on what's
# going on. I'm also using a slightly unusual way of creating a
# shiny app which means that you can just source a single file. 
# Instead of ui.r and server.r, I create ui and server objects
# which I supply to runApp in a special way (see below).
ui <- basicPage(
  tags$p(actionButton("increment", "+1")),
  tags$p(actionButton("decrement", "-1")),
  uiOutput("count")
)

server <- function(input, output) {
  # Here we create a new reactiveValues object to hold the value of 
  # the counter - we need that because input is read-only, but we
  # need something that's reactive.
  values <- reactiveValues(i = 1)
  
  # This is similar to before except we use i from values
  output$count <- renderText({
    paste0("i = ", values$i)
  })
  
  # The value of input$increment is not important, we just want to do
  # something when it changes (signalling that the button has been)
  # pushed - so instead of constructing a reactive expression we
  # use an observer, which will re-run the code whenever the button
  # is clicked
  observe({
    input$increment
    
    # We need to use isolate because otherwise whenever values$i changes
    # the observer will be run again and we'll get stuck in an infinite 
    # loop
    isolate({
      values$i <- values$i + 1
    })
  })
  
  observe({
    input$decrement
    isolate(values$i <- values$i - 1)
  })
}