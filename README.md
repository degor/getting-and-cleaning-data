Getting and Cleaning Data

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project: 

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!


You will find four files in this reposity

run_analysis.R - the source code of script that cleans data.
tidy.txt - tidy data that is resulted from cleaning data.
CodeBook.md - codebook for variables in tidy.txt
README.md - descri of run_analysis.R

Content of run_analysis.R is discussed below:

## add a reference to dplyr library that helps with cleaning data.
library(dplyr)

## 1. Merges the training and the test sets to create one data set.
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

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Search for all column names that contains Mean and Std in their name and subset them with two additionl colums that we got from joined subject and joined y.
trimmedData <- joinedData[,c(1, 2, grep(".*Mean.*|.*Std.*", names(joinedData), ignore.case=TRUE))]

## 3. Uses descriptive activity names to name the activities in the data set
# Take a proper character based description of activity from it's factor value.
trimmedData <- mutate(trimmedData, Activity = as.character(activityLabels[Activity,2]))

## 4. Appropriately labels the data set with descriptive variable names. 

# For brevity i've just changed a few names to be more descriptive but this can be done with all columns.

colnames(trimmedData) <- sub("^t", "Time ", ignore.case=TRUE, colnames(trimmedData))
colnames(trimmedData) <- sub("^f", "Frequency ", ignore.case=TRUE, colnames(trimmedData))

colnames(trimmedData) <- sub("\\-x", " on x axis", ignore.case=TRUE, colnames(trimmedData))
colnames(trimmedData) <- sub("\\-y", " on y axis", ignore.case=TRUE, colnames(trimmedData))
colnames(trimmedData) <- sub("\\-z", " on z axis", ignore.case=TRUE, colnames(trimmedData))

## 5. From the data set  creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# we aggregate values based on each subject and each activty and store then in tidy.txt.
write.table(aggregate(. ~Subject + Activity, trimmedData, mean), file = "tidy.txt", row.names = FALSE)