library(plyr)
library(dplyr)
library(reshape2)

run.analysis <- function() {
    initializeDataFiles()
    data <- readDataFiles()
    data <- transformData(data)
    data <- analyzeData(data)
    data
}

initializeDataFiles <- function() {
    acquireDataFiles()
    unpackDataFiles()
}

acquireDataFiles <- function() {
    if (!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){
        download.file(
            url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
            destfile = "getdata-projectfiles-UCI HAR Dataset.zip",
            method = "auto",
            mode = "wb")
    }
}

unpackDataFiles <- function() {
    if(!file.exists("UCI HAR Dataset")){
        unzip("getdata-projectfiles-UCI HAR Dataset.zip")
    }
}

readDataFiles <- function() {
    meta <- readMetaDataFiles()
    measures <- list()
    measures$x <- ldply(c("test", "train"), function(setName) readDataFilesX(setName, meta$features))
    measures$y <- ldply(c("test", "train"), function(setName) readDataFilesY(setName))
    measures$subject <- ldply(c("test", "train"), function(setName) readDataFilesSubject(setName))
    list(meta=meta, measures=measures)
}

readMetaDataFiles <- function() {
    features <- read.table(
        file="./UCI HAR Dataset/features.txt",
        sep=" ",
        col.names=c("index", "name"),
        stringsAsFactors=FALSE)
    
    activities <- read.table(
        file="./UCI HAR Dataset/activity_labels.txt",
        sep=" ",
        col.names=c("activityId", "activity"),
        stringsAsFactor=TRUE)
    
    list(features=features, activities=activities)
}

readDataFilesSubject <- function(setName) {
    path <- sprintf("./UCI HAR Dataset/%s/subject_%s.txt", setName, setName)
    colNames <- "subject"
    subject <- read.table(path, col.names=colNames)
    
    subject
}

readDataFilesX <- function(setName, features) {
    path <- sprintf("./UCI HAR Dataset/%s/X_%s.txt", setName, setName)
    colNames <- features$name ##sapply(features$name, function(name) {gsub("[(),-]", "", name)})
    x <- read.table(path, col.names=colNames)
    
    x
}

readDataFilesY <- function(setName) {
    path <- sprintf("./UCI HAR Dataset/%s/Y_%s.txt", setName, setName)
    colNames <- "activity"
    y <- read.table(path, col.names=colNames)
    
    y
}

transformData <- function(data) {
    transformX <- function(x) {
        x <- select(x, matches(".*(mean|std)\\.\\..*"), -angle.tBodyAccJerkMean..gravityMean.)
        x <- rename(
                x,
                tBodyAcc.Mean.X = tBodyAcc.mean...X,
                tBodyAcc.Mean.Y = tBodyAcc.mean...Y,
                tBodyAcc.Mean.Z = tBodyAcc.mean...Z,
                tBodyAcc.Std.X = tBodyAcc.std...X,
                tBodyAcc.Std.Y = tBodyAcc.std...Y,
                tBodyAcc.Std.Z = tBodyAcc.std...Z,
                tGravityAcc.Mean.X = tGravityAcc.mean...X,
                tGravityAcc.Mean.Y = tGravityAcc.mean...Y,
                tGravityAcc.Mean.Z = tGravityAcc.mean...Z,
                tGravityAcc.Std.X = tGravityAcc.std...X,
                tGravityAcc.Std.Y = tGravityAcc.std...Y,
                tGravityAcc.Std.Z = tGravityAcc.std...Z,
                tBodyAccJerk.Mean.X = tBodyAccJerk.mean...X,
                tBodyAccJerk.Mean.Y = tBodyAccJerk.mean...Y,
                tBodyAccJerk.Mean.Z = tBodyAccJerk.mean...Z,
                tBodyAccJerk.Std.X = tBodyAccJerk.std...X,
                tBodyAccJerk.Std.Y = tBodyAccJerk.std...Y,
                tBodyAccJerk.Std.Z = tBodyAccJerk.std...Z,
                tBodyGyro.Mean.X = tBodyGyro.mean...X,
                tBodyGyro.Mean.Y = tBodyGyro.mean...Y,
                tBodyGyro.Mean.Z = tBodyGyro.mean...Z,
                tBodyGyro.Std.X = tBodyGyro.std...X,
                tBodyGyro.Std.Y = tBodyGyro.std...Y,
                tBodyGyro.Std.Z = tBodyGyro.std...Z,
                tBodyGyroJerk.Mean.X = tBodyGyroJerk.mean...X,
                tBodyGyroJerk.Mean.Y = tBodyGyroJerk.mean...Y,
                tBodyGyroJerk.Mean.Z = tBodyGyroJerk.mean...Z,
                tBodyGyroJerk.Std.X = tBodyGyroJerk.std...X,
                tBodyGyroJerk.Std.Y = tBodyGyroJerk.std...Y,
                tBodyGyroJerk.Std.Z = tBodyGyroJerk.std...Z,
                tBodyAccMag.Mean = tBodyAccMag.mean..,
                tBodyAccMag.Std = tBodyAccMag.std..,
                tGravityAccMag.Mean = tGravityAccMag.mean..,
                tGravityAccMag.Std = tGravityAccMag.std..,
                tBodyAccJerkMag.Mean = tBodyAccJerkMag.mean..,
                tBodyAccJerkMag.Std = tBodyAccJerkMag.std..,
                tBodyGyroMag.Mean = tBodyGyroMag.mean..,
                tBodyGyroMag.Std = tBodyGyroMag.std..,
                tBodyGyroJerkMag.Mean = tBodyGyroJerkMag.mean..,
                tBodyGyroJerkMag.Std = tBodyGyroJerkMag.std..,
                fBodyAcc.Mean.X = fBodyAcc.mean...X,
                fBodyAcc.Mean.Y = fBodyAcc.mean...Y,
                fBodyAcc.Mean.Z = fBodyAcc.mean...Z,
                fBodyAcc.Std.X = fBodyAcc.std...X,
                fBodyAcc.Std.Y = fBodyAcc.std...Y,
                fBodyAcc.Std.Z = fBodyAcc.std...Z,
                fBodyAccJerk.Mean.X = fBodyAccJerk.mean...X,
                fBodyAccJerk.Mean.Y = fBodyAccJerk.mean...Y,
                fBodyAccJerk.Mean.Z = fBodyAccJerk.mean...Z,
                fBodyAccJerk.Std.X = fBodyAccJerk.std...X,
                fBodyAccJerk.Std.Y = fBodyAccJerk.std...Y,
                fBodyAccJerk.Std.Z = fBodyAccJerk.std...Z,
                fBodyGyro.Mean.X = fBodyGyro.mean...X,
                fBodyGyro.Mean.Y = fBodyGyro.mean...Y,
                fBodyGyro.Mean.Z = fBodyGyro.mean...Z,
                fBodyGyro.Std.X = fBodyGyro.std...X,
                fBodyGyro.Std.Y = fBodyGyro.std...Y,
                fBodyGyro.Std.Z = fBodyGyro.std...Z,
                fBodyAccMag.Mean = fBodyAccMag.mean..,
                fBodyAccMag.Std = fBodyAccMag.std..,
                fBodyBodyAccJerkMag.Mean = fBodyBodyAccJerkMag.mean..,
                fBodyBodyAccJerkMag.Std = fBodyBodyAccJerkMag.std..,
                fBodyBodyGyroMag.Mean = fBodyBodyGyroMag.mean..,
                fBodyBodyGyroMag.Std = fBodyBodyGyroMag.std..,
                fBodyBodyGyroJerkMag.Mean = fBodyBodyGyroJerkMag.mean..,
                fBodyBodyGyroJerkMag.Std = fBodyBodyGyroJerkMag.std..)
        x
    }
    
    activity <- factor(data$meta$activities$activity,
                       levels=data$meta$activities$activity)
    transformY <- function(y) {
        y$activity <- activity[y$activity]
        y
    }
    
    mergeData <- function(dataset) {
        dataset$x$activity <- dataset$y$activity
        dataset$x$subject <- dataset$subject$subject
        dataset$x
    }
    
    data$measures$x <- transformX(data$measures$x)
    data$measures$y <- transformY(data$measures$y)
    data <- mergeData(data$measures)
}

analyzeData <- function(data) {
    analyzeByActivity <- function(subset) {
        data <- melt(subset, id.vars=c("activity"))
        data <- dcast(data, activity ~ variable, mean)
        data
    }
    
    data <- ddply(data, .(subject, activity), analyzeByActivity)
    data <- data[,c(68,1:67)]
    
    data
}