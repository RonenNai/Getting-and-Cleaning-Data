library(plyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("data.zip"))
  download.file(url,"data.zip")

## 1.Merges the training and the test sets to create one data set

x_test <- read.table(unz("data.zip", "UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(unz("data.zip", "UCI HAR Dataset/test/y_test.txt"))
subject_test  <- read.table(unz("data.zip", "UCI HAR Dataset/test/subject_test.txt"))

x_train <- read.table(unz("data.zip", "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz("data.zip", "UCI HAR Dataset/train/y_train.txt"))
subject_train <- read.table(unz("data.zip", "UCI HAR Dataset/train/subject_train.txt"))

x_merge <- rbind(x_train, x_test) 
y_merge <- rbind(y_train, y_test) 
subject_merge <- rbind(subject_train, subject_test) 
colnames(subject_merge) <-"Subject"

##2.Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table(unz("data.zip", "UCI HAR Dataset/features.txt"))
colnames(features) <- c('feature_id', 'featute_name')
colnames(x_merge) <- features[,2]

mean_and_std_features <- grep("-mean\\(\\)|-std\\(\\)", features$featute_name)
x_merge  <- x_merge[, mean_and_std_features]


##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names. 

activities <- read.table(unz("data.zip", "UCI HAR Dataset/activity_labels.txt"))
y_merge[,1] <- activities[y_merge [, 1], 2]
colnames(y_merge) <- "Activity"

all_data <- cbind(x_merge, y_merge, subject_merge)

##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidyDataSet <- aggregate ( .~ Activity + Subject, data=all_data,  FUN = "mean")

write.table(tidyDataSet, "tidyDataSet.txt", row.name=FALSE)
