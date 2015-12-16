
setwd("/home/alton/Documents/seizure/seizure/")
all_data = read.csv("all_data.csv")

head(all_data)

library(randomForest)

factors = names(all_data)[c(2,3,6:ncol(all_data))]

train = all_data[ all_data$sequence %in% c(4,5,6), factors]

val = all_data[ all_data$sequence %in% c(1,2,3), factors]

test = all_data[ all_data$sequence %in% c(0), factors]


# build the model
rf = randomForest(preictal ~ ., data = train)


# predict
train.pred <- predict(rf, train)
val.pred <- predict(rf, val)
plot(train[,"preictal"], train.pred, main="train data")
plot(val[,"preictal"], val.pred, main="val data")




# final predictions
test$preictal <- predict(rf, test)
hist(test$preictal)
# no negatives
mean(test$preictal<0)
test[ test$preictal<0, "preictal"] <- 0
# no greater than 1
mean(test$preictal>1)
test[ test$preictal>1, "preictal"] <- 1


sub = data.frame(all_data[ all_data$sequence %in% c(0),"clip"], test[,c("preictal")])
names(sub) <- c("clip", "preictal")
sub = sub[ order(sub$clip, decreasing=F), ]

write.csv(format(sub, scientific = FALSE), 
          file=paste("submissions","1.csv",sep="/"), 
          row.names=F, quote=F)


# compare submission to test submission
nrow(sub)
# 3935
sample = read.csv("sampleSubmission.csv")
nrow(sample)

sum(as.character(sample$clip) == as.character(sub$clip))
#sample$clip[!as.character(sample$clip) == as.character(sub$clip)]
#sub$clip[!as.character(sample$clip) == as.character(sub$clip)]



