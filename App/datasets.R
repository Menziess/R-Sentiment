

#######################################################
#  Data must have {X}, {id} {sentiment} and {review}  #
#######################################################

# Get moviedata from csv files
getMovieData = function(type = NULL, file = NULL, nrows = -1) {
  types <- list.files(path <- paste0(getwd(), "/Data/"))
  if (is.null(type)) type <- readline(paste("Type -", list(types), ":"))
  if (!type %in% types && !is.numeric(type)) stop("Given folder doesn't exist")
  if (is.numeric(type)) type <- types[type]
  files <- list.files(path <- paste0(path, type, "/"))
  if (is.null(file)) file <- readline(paste("File -", list(files), ":"))
  if (!file %in% files && !is.numeric(file)) stop("Given file doesn't exist")
  if (is.numeric(file)) file <- files[file]
  return (tryCatch(read.csv(paste0(path, file), nrows = nrows)))
} 


##################
#   Word list    #
##################

# Positive and negative words
word_list <- getMovieData("pos-neg-words", "word_list.csv")


##################
#   TSV to CSV   #  Used for IMDB dataset
##################

convertTsvToCsv <- function(inputFile, outputFile) {
  if(is.null(inputFile) || is.null(outputFile))
    stop("Give input and output path of file")
  data <- read.table(inputFile, sep="\t", quote="", header=T)  
  write.csv(data, outputFile)
}


##################
#  Files to CSV  #  Used for Polarity dataset
##################

convertFilesToCsv <- function(folder, outputFile, sentiment) {
  if(is.null(folder) || is.null(outputFile) || is.null(sentiment))
    stop("Give input and output path of file")
  files <- list.files(folder)
  ans <- readline(paste("Read", length(files), "files? Y/N "))
  if (ans != "Y")
    return()
  matrix  <- matrix(nrow = length(files), ncol = 4)
  folder <- if(substr(folder, nchar(folder), nchar(folder)) == "/") folder else paste0(folder, "/")
  i <- 1
  for(f in files) {
    id <- f
    matrix[i,1] <- i
    matrix[i,2] <- id
    matrix[i,3] <- sentiment
    matrix[i,4] <- readChar(paste0(folder, f), file.info(paste0(folder, f))$size)
    i <- i+1
  }
  data <- as.data.frame(matrix)
  colnames(data) <- c("X", "id", "sentiment", "review")
  write.csv(data, outputFile)
}
