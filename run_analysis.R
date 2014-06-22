# set the working directory

setwd("C:\\Users\\Ana\\Documents\\Online_Courses\\_Specialization_Data_Science\\3_Getting_and_Cleaning_Data_June_2014\\project")

# read the training and the test datasets

trainData = read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
testData = read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")

# merge the two datasets

mergedData <- rbind(trainData, testData)

# assign variable names for the measurements

features <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt")
colnames(mergedData) <- features[,2]

# add the activity and the subject who performed the activity

train_activity = read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt")
test_activity = read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt")

activities <- rbind(train_activity, test_activity)

mergedData$activity <- activities

subject_train <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")
subject_test <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")

subjects <- rbind(subject_train, subject_test)

mergedData$subject <- subjects

# extract the mean and standard deviation variables for each measurement

extractCols <- grep("-mean\\(\\)|-std\\(\\)", names(mergedData))

extractedData <- cbind(mergedData[, extractCols], mergedData[, "activity"], mergedData[, "subject"])
colnames(extractedData) <- c(names(extractedData[1:(length(extractedData)-2)]), c("activity", "subject"))

# name the activities with descriptive activity names - the first tidy data set

activity_labels <- read.table(".\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")
colnames(activity_labels) <- c("activity", "activity_label")

finalData1 = merge(extractedData, activity_labels, by="activity", all=TRUE)
finalData1$activity <- NULL

write.table(finalData1, ".\\finalData1.txt", sep="\t")
test1 <- read.table(".\\finalData1.txt")

# calculate the average of each variable for each activity and each subject - the second tidy data set

finalData2 <- aggregate(finalData1[, -((length(extractedData)-1):length(extractedData))], by=list(finalData1$subject, finalData1$activity_label), FUN=mean, na.rm=TRUE)

library(plyr)
names(finalData2)[1:2] <- c("subject_group", "activity_group")

write.table(finalData2, ".\\finalData2.txt", sep="\t")
test2 <- read.table(".\\finalData2.txt")