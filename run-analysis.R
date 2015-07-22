run.analysis <- function() {
    initializeData()
}

initializeData <- function() {
    acquireData()
    unpackData()
}

acquireData <- function() {
    if (!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){
        download.file(
            url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
            destfile = "getdata-projectfiles-UCI HAR Dataset.zip",
            method = "auto",
            mode = "wb")
    }
}

unpackData <- function() {
    if(!file.exists("UCI HAR Dataset")){
        unzip("getdata-projectfiles-UCI HAR Dataset.zip")
    }
}