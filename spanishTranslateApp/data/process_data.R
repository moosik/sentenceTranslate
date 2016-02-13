# This script should be run occasionally to process the data: SpanishSentences.txt
# and section_code_keys.txt to compile it in a .rda structure for speed.
# The app itself will load the processed data


# Read the database with sentences
data<- readLines("SpanishSentences.txt")
temp <- strsplit(data, split = ";")
english <- sapply(temp, "[", 1)
spanish <- sapply(temp, "[", 2)
lv <- as.numeric(sapply(temp, "[", 3))
data.df <- data.frame(english, spanish, level = lv, stringsAsFactors = FALSE)
# Read the keys to the sections
keys <- readLines("section_code_keys.txt")
temp <- strsplit(keys, split = ";")
num <- sapply(temp, "[", 1)
expl <- sapply(temp, "[", 2)
keys.df <- data.frame(num, expl, stringsAsFactors = FALSE)
save(data.df, keys.df, file = "sentence_source.rda")
