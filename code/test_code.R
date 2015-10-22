# This way I don't need to deal with the end of the line characters,
# read table gavit that problem
data<- readLines("./data/SpanishSentences.txt")
temp <- strsplit(data, split = ";")
english <- sapply(temp, "[", 1)
spanish <- sapply(temp, "[", 2)
lv <- sapply(temp, "[", 3)
data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)

# Version 1: select n random sentences, go throug them,
# present with the english version, read my translation, present both results,
# ask whether I was correct or not, count the number of correct answers, present
# with the results

transTest <- function(data, howmany){
  # Indices for the rows to select
  select.rows <- sample(1:nrow(data), howmany)
  tobe.tested <- data[select.rows]
  cat(paset("Will test", howmany, "sentences", sep = " "))
  score <- 0
  cat("Initial score is", score, sep = " ")
  cat("Starting the sentences...")
  for(i in seq_len(nrow(tobe.tested))){
    # wait for the input
    answer = readline(prompt =  paste(tobe.tested[i,1]," ", sep = ""))
    cat(paste("You entered:", answer, sep = " "))
    cat(paste("The correct translation:", tobe.tested[i,2], sep = " "))
    count.ch <- readline(prompt = "Were you correct? Enter y(yes) or n(no) ")
    res <- trimws(as.character(count.ch), what = "both")
    if(res == "y"){
      score <- score +1
    }
  }
}