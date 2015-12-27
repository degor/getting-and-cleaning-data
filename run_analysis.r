library(dplyr)

## Merges the training and the test sets to create one data set.
# read additional data regarding labels and features
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)


# read subject test and train data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
# joined subject values and set a proper col name
subjectJoined <- rbind(subjectTrain, subjectTest)
colnames(subjectJoined) <- "Subject"

# read feature test and train data
xTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
# join feature values and set a proper column name
xJoined <- rbind(xTrain, xTest)
colnames(xJoined) <- featureNames[, 2] 

# read activity test and train data
yTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
# join activity values and set a proper column name
yJoined <- rbind(yTrain, yTest)
colnames(yJoined) <- "Activity"

# Join all data together.
joinedData <- cbind(subjectJoined, yJoined, xJoined)

## Extracts only the measurements on the mean and standard deviation for each measurement. 
trimmedData <- joinedData[,c(1, 2, grep(".*Mean.*|.*Std.*", names(joinedData), ignore.case=TRUE))]

## Uses descriptive activity names to name the activities in the data set
trimmedData <- mutate(trimmedData, Activity = as.character(activityLabels[Activity,2]))

## Appropriately labels the data set with descriptive variable names. 
colnames(trimmedData) <- sub("^t", "Time ", ignore.case=TRUE, colnames(trimmedData))
colnames(trimmedData) <- sub("^f", "Frequency ", ignore.case=TRUE, colnames(trimmedData))

colnames(trimmedData) <- sub("\\-x", " on x axis", ignore.case=TRUE, colnames(trimmedData))
colnames(trimmedData) <- sub("\\-y", " on y axis", ignore.case=TRUE, colnames(trimmedData))
colnames(trimmedData) <- sub("\\-z", " on z axis", ignore.case=TRUE, colnames(trimmedData))

## From the data set  creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(aggregate(. ~Subject + Activity, trimmedData, mean), file = "tidy.txt", row.names = FALSE)

