#loads files
tests <- read.table("test/subject_test.txt")
testx <- read.table("./test/X_test.txt")
testy <- read.table("./test/y_test.txt")

trains <- read.table("./train/subject_train.txt")
trainx <- read.table("./train/X_train.txt")
trainy <- read.table("./train/y_train.txt")

features <- read.table("./features.txt")

activity <- read.table("./activity_labels.txt")

#merges data sets to create one data set
subject <- rbind(tests, trains)
colnames(subject) <- "subject"

label <- rbind(testy, trainy)
label <- merge(label, activity.labels, by=1)[,2]

data <- rbind(testx, trainx)
colnames(data) <- features[, 2]

#merges all three datasets
data <- cbind(subject, label, data)

#creates a smaller dataset with only the mean and std
dsub <- grep("-mean|-std", colnames(data))
data.mean.std <- data[,c(1,2,dsub)]

#computes the means, grouped by subject/label
library(reshape2)
melted = melt(data.mean.std, id.var = c("subject", "label"))
data.mean = dcast(melted , subject + label ~ variable, mean)

#saves the resulting dataset
write.table(data.mean, file="tidy_data.txt")

#outputs final dataset
data.mean