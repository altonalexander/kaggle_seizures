
all_data = read.csv("all_data-backup.csv")

new_names = c("clip","patient.type","patient.name","segment.type","segment","sequence",
              "data.length.sec","sampling.frequency","n.channels")
names(all_data)[1:length(new_names)] = new_names

all_data$preictal = NA
all_data[ all_data$segment.type %in% 'interictal', 'preictal' ] <- 0
all_data[ all_data$segment.type %in% 'preictal', 'preictal' ] <- 1

write.csv(all_data, file="all_data.csv", row.names=F)


head(all_data)
## explore the data
table(all_data$sequence)

table(all_data$patient.type)
table(all_data$patient.name)
table(all_data$segment.type)

table(all_data$n.channels,all_data$patient.name)


table(all_data$segment.type,all_data$patient.name)


table(all_data$sequence,all_data$segment.type,all_data$patient.name)



