# This way I don't need to deal with the end of the line characters,
# read table gavit that problem
data<- readLines("./data/SpanishSentences.txt")
temp <- strsplit(data, split = ";")
english <- sapply(temp, "[", 1)
spanish <- sapply(temp, "[", 2)
lv <- as.numeric(sapply(temp, "[", 3))
data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)

# Version 1: select n random sentences, go through them,
# present with the english version, read my translation, present both results,
# ask whether I was correct or not, count the number of correct answers, present
# with the results
# 
# Version 2: adding selection of the sections to be tested


# Function to aks the user about the sections to be tested:
sectionChoice <- function(){
  # Present with the choice of sections
  cat("Select which Duolingo lessons you want to practice:\n")
  cat("Lessons 1 through 6: basics 1 & 2, phrases, food, animals, plurals: enter 6\n")
  cat("Lessons 1 through 7: all the above and posession: enter 7\n")
  cat("Lessons 1 through 8: all the above and clothing: enter 8\n")
  cat("Phrases from Fluencia: enter 1\n")
  cat("All above: enter 2\n")
  section.select <- readline(prompt =  "Make your selection: ")
  sec.selected <- suppressWarnings(as.numeric(section.select))
  return(sec.selected)
}

sentenceAvailabilityForTest <- function(data, tests){
  # This function figures out whether the number of requested sentences
  # to be tested is less or more than the number of available sentences
  # in a section. 
  # data = sentences from a section
  # howmany = how many sentences to test
  # 
  # If the number of requested sentences larger than the number of available
  # sentences just reshuffle the rows and present them to the user
  if(nrow(data) >= tests){
    to.test.data <- data[sample.int(1:nrow(data)), ]
    return(to.test.data)
  }
  # If the number of requested sentences is smaller than the number of 
  # available sentences select the number of requested sentences at
  # random
  else{
    test.ind <- sample(1:nrow(data), tests)
    to.test.data <- data[test.ind, ]
    return(to.test.data)
  }
}


transTest <- function(data, howmany){
  user.choice <- sectionChoice()
  # Create a subset of data from the chosen section:
  data.section <- data[data$level == user.choice, ]
  # Select sentences from a section based on how many are requested for testing
  tobe.tested <- sentenceAvailabilityForTest(data.section, tests = howmany)
  cat(paste("This section has", nrow(data.section), "sentences\n", sep = " "))
  cat(paste("We will test", nrow(tobe.teste), "sentences\n", sep = " "))
  # List to store the sentences which weren't translated correctly
  tobe.studied <- list()
  score <- 0
  cat(paste("Initial score is", score, sep = " "))
  cat("\n")
  cat("Starting the sentences...\n")
  for(i in seq_len(nrow(tobe.tested))){
    # wait for the input
    answer <- readline(prompt =  paste("Sentence: ", tobe.tested[i,1], ". Your translation: ", sep = ""))
    cat(paste("You entered: ", answer, "\n", sep = ""))
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



