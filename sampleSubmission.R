
# load the results from feature extraction
setwd("/home/alton/Documents/seizure/")
sample = read.csv("sampleSubmission.csv")


head(sample)

table(sample$preictal)
