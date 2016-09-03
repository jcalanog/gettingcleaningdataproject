
# standard practice is to make sure to clear and clean up the workspace prior to any other work. 
# This is to ensure that no lingering variables or objects persist, from any previous work. 
rm(list=ls())

# set up our [workspace] folder, where we will store majority of our docs. 
if(!file.exists("./workspace"))
{
	dir.create("./workspace")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./workspace/Dataset.zip",method="curl")

unzip(zipfile="./workspace/Dataset.zip",exdir="./workspace")

file_loc <-  file.path("./workspace" , "UCI HAR Dataset")
dataFiles <- list.files(file_loc, recursive=TRUE)

# ** SANITY CHECK. We can opt to look into the list of files just to make sure data files have been 
# ** extracted without any issues. 

#dataFiles 

# read the non-train/non-test files and store them for now. 
featuresData <- read.table(file.path(file_loc, "features.txt"), header = FALSE)
activityLabel <- read.table(file.path(file_loc,  "activity_labels.txt"), header = FALSE)
names(activityLabel) <- c("activity_id", "activity")

# read data files according to classification: TEST or TRAIN. Mainly done to avoid confusion
# with organization (per the README.txt description).

# Load all 'TEST'-related files first. 
testSubject  <- read.table(file.path(file_loc, "test" , "subject_test.txt"),header = FALSE)
testSet  <- read.table(file.path(file_loc, "test" , "X_test.txt" ),header = FALSE)
testActivity  <- read.table(file.path(file_loc, "test" , "Y_test.txt" ),header = FALSE)

# Load all 'TRAIN'-related files second. 
trainSubject <- read.table(file.path(file_loc, "train", "subject_train.txt"),header = FALSE)
trainSet <- read.table(file.path(file_loc, "train", "X_train.txt"),header = FALSE)
trainActivity <- read.table(file.path(file_loc, "train", "Y_train.txt"),header = FALSE)

# with all the files loaded (into memory), now do the actual work from here. 

# combine test and training data. For this script, 'test' comes before 'train'.
# # combine by Subject 
allSubject <- rbind(testSubject, trainSubject)
# # combine by Activity 
allActivity <- rbind(testActivity, trainActivity)
# # combine by 'Set'
allSet <- rbind(testSet, trainSet)

# optionally check the status of the 3 newly made objects above. 
# make changes to the columns or data types if necessary. 
names(allSubject) <- c("subject_id")
names(allActivity) <- c("activity_id") 
# # this one is special, because this relates to the 'features.txt' that was loaded earlier. 
names(allSet) <- featuresData[,2]

# now to combine them to make sense of the data (sort of). 
mergedData <- cbind(allSubject, allActivity)
metrics.df <- cbind(allSet, mergedData)

# obtain a subset of the data where 'mean' and 'std' appear in features
subset.features <- featuresData$V2[grep("mean\\(\\)|std\\(\\)", featuresData$V2)]
subset.names <- c(as.character(subset.features), "subject_id", "activity_id")
metrics.df <- subset(metrics.df, select=subset.names)


names(metrics.df)<-gsub("^t", "time", names(metrics.df))
names(metrics.df)<-gsub("^f", "frequency", names(metrics.df))
names(metrics.df)<-gsub("Acc", "Accelerometer", names(metrics.df))
names(metrics.df)<-gsub("Gyro", "Gyroscope", names(metrics.df))
names(metrics.df)<-gsub("Mag", "Magnitude", names(metrics.df))
names(metrics.df)<-gsub("BodyBody", "Body", names(metrics.df))

# for the tidy data, obtain the average for each column according to subject and activity. 
tidy.data <- aggregate(metrics.df[,names(metrics.df) != c("subject_id", "activity_id")], by=list(metrics.df$subject_id, metrics.df$activity_id), mean)
names(tidy.data)[names(tidy.data) == "Group.1"] <- "subject_id"
names(tidy.data)[names(tidy.data) == "Group.2"] <- "activity_id"

tidy.data2 <- merge(activityLabel, tidy.data, by="activity_id", all.x = TRUE)

# commit the result [tidy.data2] to persistence. 
write.table(tidy.data2, "./tidyData.txt", row.names=FALSE, sep='\t')
