

###########################################
#         Install required packages       #
###########################################

list.of.packages <- c("shiny", "devtools", "shiny", "XML", "plyr", "dplyr", "httr", "xml2", "plotly", "shinythemes", 
                      "tm", "randomForest", "class", "e1071", "nnet", "neuralnet", "ranger", "reshape")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
for (i in list.of.packages) {
  do.call("library", list(i))
}

# Updated default for nnet visualization using plot()
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')


