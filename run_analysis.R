library(plyr)

rm(list=ls())
path <- "/home/bvv/data"
setwd(path)

#--------------------------------------------------------------------
# Step 1: read features list and activity labels
#--------------------------------------------------------------------
features <- read.table("features.txt", header=F)
activity_labels <- read.table("activity_labels.txt", header=F)

#--------------------------------------------------------------------
# Step 2: read test and train data
#--------------------------------------------------------------------
xTest <- read.table("test/X_test.txt", header=F)
subjectTest <- read.table("test/subject_test.txt", header=F)
yTest <- read.table("test/y_test.txt", header=F)

xTrain <- read.table("train/X_train.txt", header=F)
subjectTrain <- read.table("train/subject_train.txt", header=F)
yTrain <- read.table("train/y_train.txt", header=F)

#--------------------------------------------------------------------
# Step 3: join test and train data into common dataset
#--------------------------------------------------------------------
xTotal <- rbind(xTest, xTrain)
yTotal <- rbind(yTest, yTrain)
subjectTotal <- rbind(subjectTest, subjectTrain)

#--------------------------------------------------------------------
# Step 4: filter measured data by feature names
# select features with mean() or std()  
#--------------------------------------------------------------------
name_ids <- grep("mean\\(|std\\(", features[, 2])
xTotal <- xTotal[, name_ids]

#--------------------------------------------------------------------
# Step 5: set human readable column names
#--------------------------------------------------------------------
names(subjectTotal) <- "subjectId"
yTotal <- data.frame(activity_labels[yTotal[, 1], 2])
names(yTotal) <- "activity"
colnames(xTotal) <- features[name_ids, 2]

#--------------------------------------------------------------------
# Step 6: create common dataset with selected features
#--------------------------------------------------------------------
dataTotal <- cbind(subjectTotal, yTotal, xTotal)

#--------------------------------------------------------------------
# Step 7: create tidy dataset with column means by subjectId, activity
#--------------------------------------------------------------------
tidyData <- ddply(dataTotal, .(subjectId, activity), function(x) colMeans(x[, 3:dim(x)[2]]))
write.table(tidyData, file="tidyData.txt", sep="\t", col.names=T, row.names=F)
