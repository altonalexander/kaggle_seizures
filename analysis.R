# to connect to spark and dfs
#install.packages("devtools")
install.packages("rJava")
#library(devtools)
#install_github("amplab-extras/SparkR-pkg", subdir="pkg")


# connect to spark
library(SparkR)
#sc <- sparkR.init(master="local")
sc <- sparkR.init("spark://alexander1:7077")
lines <- textFile(sc, "hdfs://alexander1:9000/user/root/seizure-data/Patient_1/Patient_1_interictal_segment_0044.mat")
wordsPerLine <- lapply(lines, function(line) { length(unlist(strsplit(line, " "))) })


# to be able to read a matlab file
library(R.matlab)

setwd("/home/alton/Documents/seizure/")

path = "../../Downloads/"
file = "Dog_1_interictal_segment_0001.mat"

mat = readMat(paste(path,file,sep=""))

data = mat[[1]]



# load the meta data
file.split = strsplit(file,"_")
patient.type = file.split[[1]][1]
patient.name = paste(file.split[[1]][1],file.split[[1]][2],sep="_")
segment.type = file.split[[1]][3]
segment = as.numeric(gsub(".mat","",file.split[[1]][length(file.split[[1]])]))
data.length.sec = data[[2]]
sampling.frequency = data[[3]]
n.channels = length(data[[4]])
sequence = data[[4]]

var(data[[1]][1,])


