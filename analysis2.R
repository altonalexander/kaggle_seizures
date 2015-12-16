
# to be able to read a matlab file
#install.packages("R.matlab")
library(R.matlab)

setwd("/home/alton/Documents/seizure/seizure/")

path = "../raw-data/"

all_data <- data.frame(matrix(ncol = 158, nrow = 0),
                       stringsAsFactors = FALSE)
colnames(all_data) <- paste0("c", c(1:158))



# for each folder
for(eachFolder in c("Dog_1","Dog_3","Dog_5","Patient_2","Dog_2","Dog_4","Patient_1")){
  
  # for each segment
  for( eachFile in list.files(paste(path,eachFolder,"/",sep="")) ){
    if(grepl(eachFolder,eachFile) ){
      print(eachFile)
      
      
      
      
      ### loop through each file
      
      folder = eachFolder
      file = eachFile
      
      mat = readMat(paste(path,folder,"/",file,sep=""))
      data = mat[[1]]
      
      # load the meta data
      file.split = strsplit(file,"_")
      patient.type = file.split[[1]][1]
      patient.name = folder
      segment.type = file.split[[1]][3]
      segment = as.numeric(gsub(".mat","",file.split[[1]][length(file.split[[1]])]))
      data.length.sec = data[[2]]
      sampling.frequency = data[[3]]
      n.channels = length(data[[4]])
      if( length(data)>=5 ){
        sequence = as.numeric(data[[5]])
      } else {
        sequence = 0
      }
      
      
      
      #plot(abs(data[[1]][4,]),type="l")
      
      new_data = c(file,patient.type,patient.name,segment.type,segment,sequence,
                   data.length.sec,sampling.frequency,n.channels)
      
      for(sequence in 1:n.channels){
        new_data = c( new_data, summary(data[[1]][1,]) )
      }
      
      for(sequence in (n.channels+1):24){
        new_data = c( new_data, summary(c(0)) )
      }
      
      ### save results to all_data
      if(nrow(all_data)==0){
        all_data = data.frame(t(new_data),stringsAsFactors = FALSE)
      } else {
        all_data = rbind(all_data,new_data)
      }
      
      
      
      
      
      
      
    }
  }
  
  
}




