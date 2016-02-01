# Load: data column names
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

## Load the data
training <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
test[,563] <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

activityLabels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)



## Merging the data
combinedData <- rbind(training, test)
cols <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[cols,]
cols <- c(cols, 562, 563)

## removing other columns
combinedData <- combinedData[,cols]

## Add the column names to combinedData
colnames(combinedData) <- c(features$V2, "Activity", "Subject")
colnames(combinedData) <- tolower(colnames(combinedData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}

combinedData$activity <- as.factor(combinedData$activity)
combinedData$subject <- as.factor(combinedData$subject)

tidy_data = aggregate(combinedData, by=list(activity = combinedData$activity, subject=combinedData$subject), mean)

## dont need subject and activity
tidy_data[,90] = NULL
tidy_data[,89] = NULL

## tidy_data table
write.table(tidy_data, "tidy_data.txt", sep="\t", row.names=FALSE)