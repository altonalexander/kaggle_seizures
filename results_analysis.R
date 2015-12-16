

# load the results from feature extraction
setwd("/home/alton/Documents/seizure/")
res = read.csv("results.csv", header=F)
head(res)
names(res)<-c("filename","patient_type","patient","segment_type","segment","segment_num","sample_freq","samples","locations","time")


nrow(res)

table(res$patient_type, res$patient)

table(res$time)

table(res$locations)


table(res$patient,res$segment_type)
table(res$segment_num,res$segment_type)

# how many tests are there? 3935
sum(res$segment_type=='test')
