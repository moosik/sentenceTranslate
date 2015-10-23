# This way I don't need to deal with the end of the line characters,
# read table gavit that problem
data<- readLines("./data/SpanishSentences.txt")
temp <- strsplit(data, split = ";")
english <- sapply(temp, "[", 1)
spanish <- sapply(temp, "[", 2)
lv <- sapply(temp, "[", 3)
data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)

# Version 1: select n random sentences, go through them,
# present with the english version, read my translation, present both results,
# ask whether I was correct or not, count the number of correct answers, present
# with the results

transTest <- function(data, howmany){
  # Indices for the rows to select
  select.rows <- sample(1:nrow(data), howmany)
  # Select the data
  tobe.tested <- data[select.rows, ]
  # List to store the sentences which weren't translated correctly
  tobe.studied <- list()
  cat(paste("Will test", howmany, "sentences", sep = " "))
  cat("\n")
  score <- 0
  cat(paste("Initial score is", score, sep = " "))
  cat("\n")
  cat("Starting the sentences...\n")
  for(i in seq_len(nrow(tobe.tested))){
    # wait for the input
    answer <- readline(prompt =  paste("Sentence: ", tobe.tested[i,1], ". Your translation: ", sep = ""))
    cat(paste("You entered:", answer, sep = " "))
    cat("\n")
    cat(paste("The correct translation:", tobe.tested[i,2], sep = " "))
    count.ch <- readline(prompt = "Were you correct? Enter y(yes) or n(no) ")
    res <- trimws(as.character(count.ch), which = "both")
    if(res == "y"){
      score <- score +1
    }
    else{
      tobe.studied[[length(tobe.studied) + 1]] <- tobe.tested[i,1]
    }
  }
  cat(paste("Your score is ", round((score/nrow(tobe.tested))*100, 2), "%", sep = ""))
  cat("\n")
  cat("Sentences you didn't translate correctly:\n")
  j <- 1
  while(j <= length(tobe.studied)){
    cat(tobe.studied[[j]])
    cat("\n")
    j <- j + 1
  }
}