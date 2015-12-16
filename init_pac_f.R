library(R.matlab)
#install.packages("doSNOW")
library(doSNOW)
#install.packages("foreach")
library(foreach)

parallel <- T
if (parallel)
{
  cl<-makeCluster(2) #change the 2 to your number of CPU cores
  registerDoSNOW(cl)
}

setwd("/home/alton/Documents/seizure/raw-data/") #!!! set path to your data !!!!
num <- 24
part<-0.03
part1000<-round(part*1000)

chars <- function(data,pref)
{
  sg <- abs(fft(data))
  sg <- sg[1:(part*length(sg))]
  ln=length(sg)
  df<-aggregate(sg,by = list(trunc(num*((1:ln)-1)/ln)),FUN=mean)
  df=data.frame(t(df))
  
  names(df) <- paste(pref,paste("f",1:num,sep=""),sep="_")
  df["x",]
}

sub_folders <- c("Dog_3", "Patient_2", "Patient_1", "Dog_4", "Dog_2", "Dog_1",  "Dog_5")

files <- function(sub_folder)
{
  all_list <- NULL
  orig_file <- list.files(path=sub_folder)
  file <- paste(sub_folder,orig_file,sep="/")
  all_list <- rbind(all_list,data.frame(file=file,orig_file=orig_file))
  print(sub_folder); flush.console()
  all_list[,"type"]<-unlist(lapply(as.character(all_list[,1]),function(x) strsplit(x,split="_")[[1]][4] ))
  all_list
}
foreach (sub_folder = sub_folders, .packages=c("R.matlab")) %dopar%
#for (sub_folder in sub_folders[1])
{
  fls <- files(sub_folder)
  cnt <- nrow(fls)
  all_char_list <- NULL
  
  file <- fls[1,"file"]
  data <- readMat(file)[[1]]
  channels <- as.character(data[[4]]) # channels
  for (i in 1:cnt)
  {
    file <- fls[i,"file"]
    data <- readMat(file)[[1]]
    print(paste(file,":", i,"of",cnt)); flush.console()

    char_list <- chars(data[[1]][1,],channels[1])
    for (i2 in 2:length(channels))
      char_list <- cbind(char_list, chars(data[[1]][i2,],channels[i2]))
    char_list[,"latency"] <- ifelse(length(data)==4,-1,data[[5]]) 
    char_list[,"orig_file"] <- fls[i,"orig_file"]
    char_list[,'type'] <- fls[i,"type"]
    char_list[,'freq'] <- data[[3]]
    char_list[,'sec'] <- data[[2]]
    
    all_char_list <- rbind(all_char_list,char_list)
  }
  write.csv(all_char_list, paste("pre-processed-data/",
                                 paste(sub_folder,
                                       paste(num,part1000,sep="_"),"csv",sep="."),
                                 sep=""),row.names=F,quote=F)
}

if (parallel)
{
  stopCluster(cl)
  rm(cl)
}
