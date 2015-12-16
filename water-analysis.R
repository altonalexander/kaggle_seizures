
# connect to local h2o cluster
library(h2o)
localH2O <- h2o.init(ip = 'alexander1', port =54321)
#h2o.clusterInfo(localH2O)


## To import from HDFS
pathToData = "hdfs://alexander1:9000/user/root/seizure-data/Dog_1/Dog_1_interictal_segment_0001.mat"
#test.hex = h2o.importFile(localH2O, path = pathToData, key = "test.hex")

system(paste("/opt/hadoop/bin/hdfs dfs -get",pathToData,"/hdfs/Rtmp.mat"))

