## Download raw data sets from Getting and cleaning Data Course Project

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setwd("C:/Users/Seastar/Desktop")
download.file(url, destfile = "C:/Users/Seastar/Desktop/Dataset.zip", mode="wb")
Dataset <- unzip(zipfile = "Dataset.zip")


activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt", as.is = TRUE)
features <- read.table("UCI HAR Dataset/features.txt", as.is = TRUE)

testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
testx <- read.table("UCI HAR Dataset/test/x_test.txt")
testy <- read.table("UCI HAR Dataset/test/y_test.txt")

trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainx <- read.table("UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("UCI HAR Dataset/train/y_train.txt")

## step 1. Merges only the training and the test sets to create one data set.
totalsubject <- rbind(testsubject, trainsubject)
totalx <- rbind(testx, trainx)
totaly <- rbind(testy, trainy)


## Step 2. Extract only the mearusements on the mean and standard deviation for each measurement
mean_std_features <- grep("mean|std", features$V2)

mean_and_std_features <- grep("(mean|std)", features[, 2])

xdata <- totalx[, mean_and_std_features]

names(xdata) <- features[mean_and_std_features, 2]


## Step 3. Use descriptive activity names to name the activities in the data set.

totaly <- activitylabels[totaly[, 1], 2]
colnames(totaly) <- "Activity"
View(totaly)

## Step 4. Appropriately labels the data set with descriptive variable names.

colnames(totalsubject) <- "Subject"

totaldata <- cbind(totalx, totaly, totalsubject)    

## Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
groupData <- totaldata %>%
  
  group_by(Subject, Activity) %>%
  
  summarise_all(funs(mean))
  
write.table(groupData, file = "tidy.txt", row.names = FALSE, quote = FALSE)

                       









