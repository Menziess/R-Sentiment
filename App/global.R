

###########################################
#             Preperation data            #
#=========================================#
# Load required packages. Define methods  #
# for data retrieval, tokenization and    #
# creation of corpus.                     #
###########################################

source("App/require.R")
source("App/datasets.R")
source("App/lgendrot.R")

# Clean IMDB dataset
folder <- paste0(getwd(), "/Data/imdb/")
convertTsvToCsv(paste0(folder, "labeledTrainData.tsv"), 
                paste0(folder, "labeledTrainData.csv"))
convertTsvToCsv(paste0(folder, "unlabeledTrainData.tsv"), 
                paste0(folder, "unlabeledTrainData.csv"))
convertTsvToCsv(paste0(folder, "testData.tsv"), 
                paste0(folder, "testData.csv"))

# Clean polarity dataset
folder <- paste0(getwd(), "/Data/polarity/pos/")
convertFilesToCsv(folder, paste0(getwd(), "/Data/polarity/positive.csv"), 1)
folder <- paste0(getwd(), "/Data/polarity/neg/")
convertFilesToCsv(folder, paste0(getwd(), "/Data/polarity/negative.csv"), 0)


###########################################
#               Neural Net                #
###########################################

# Load imdb file 1 to convert to feature list
my_features   <- convert(getMovieData("imdb", "labeledTrainData.csv", 2000))

# Prepare formula used to define weights in neural network
form          <- as.formula(paste("sentiment~", paste(setdiff(names(my_features), c("sentiment")), collapse="+")))


#===== TRAINING, TESTING AND NEW DATA ====#

# IMDB labeled
train         <- sample_frac(my_features, .8)

# IMDB labeled
new           <- sample_frac(setdiff(my_features, train), 1)


#=========== TRAIN & PREDICT =============#

# Use train list to train neural network
m_nnet <- nnet(form, data=train, size=2,  MaxNWts=100000, maxit = 20)
  
# Use new list to see if neural network does it's job
pred_nnet <- predict(m_nnet, new, type = "class")

# Only works with labeled new dataset
prediction <- as.factor(pred_nnet)
reality    <- new$sentiment 
results(prediction, reality)
