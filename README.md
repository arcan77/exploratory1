##Hello!

This is a short description of how to get my tidy data from the original.


####Step 1:
Download the archive with origin data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzip it

<!-- -->
    tempfile <- tempfile()
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, tempfile, method="curl")
    unzip(tempfile)
    unlink(tempfile)
    setwd("UCI HAR Dataset")

####Step 2:
Examine the data in unzipped folder according to README.txt in it:

1.  "features.txt has the names of all features
2.  "activity_labels.txt"  has the names of all activities and their id
3.  in both "test" and "train" folders there is the same structure of files: "X*.txt" is the data frame of measurements for all features (descibed in "features.txt"); "subject*.txt" is the vector of subject id for all measurements; "y*.txt" is the vector of activity id (described in "activity_labels.txt")

####Step 3:
Read this tables into data frames and give names to each column with `names` function. For data frame with measurements ("X*.txt") names of columns are equal to the vector of names in feature data frame. Specific names for each columns i used can be found in "run_analyses.R" file in my comments.

<!-- -->
    features <- read.table("features.txt")
    names(features) <- c("FeatureId","FeatureName")
    
    activityLabels <- read.table("activity_labels.txt")
    names(activityLabels) <- c("ActivityId","ActivityName")
    
    testX <- read.table("test/X_test.txt")
    testSubject <- read.table("test/subject_test.txt")
    testLabels <- read.table("test/y_test.txt")

    trainX <- read.table("train/X_train.txt")
    trainSubject <- read.table("train/subject_train.txt")
    trainLabels <- read.table("train/y_train.txt")

    #Giving names to the trainX and testX of the names of the features
    names(trainX) <- features$FeatureName
    names(testX) <- features$FeatureName

    #Giving names to the column of trainLabels and testLabels
    names(trainLabels) <- "ActivityId"
    names(testLabels) <- "ActivityId"

    #Giving names to the column of trainSubject and testSubject
    names(trainSubject) <- "SubjectId"
    names(testSubject) <- "SubjectId"

####Step 3:
Merge Activity + Subject + Measurements data for each train and test sets by `cbind` function

<!-- -->
    allTrain <- cbind(trainSubject, trainLabels, trainX)
    allTest <- cbind(testSubject, testLabels, testX)

####Step 4:
Merge Train + Test data by `rbind` function 

<!-- -->
    all <- rbind(allTrain,allTest)

####Step 5:
Merge All data (from step 4) with activity labels from "activity_labels.txt" by `merge` function.

<!-- -->
    allWithLabels <- merge(all,activityLabels,by.x="ActivityId",by.y="ActivityId", all=FALSE)

####Step 6:
Change the columns in data frame from Step 5 (just for author's comfort:) ). The new column order is: LabelId, LabelName, SubjectId, Features...

####Step 7:
Get numbers of features with "mean" and "std" from "features.txt" using `grep` function and `sort` the output vector (just to make it readable).

<!-- -->
    FeatureNumbersWithMeans <- grep("mean()",features$FeatureName, value=FALSE)
    FeatureNumbersWithStd <- grep("std()",features$FeatureName, value=FALSE)
    FeatureNumbers <- sort(c(FeatureNumbersWithMeans, FeatureNumbersWithStd))

####Step 8:
Delete from "All" data columns which names doesn't have "mean" or "std". But manualy save second and third column ("Activity Name", "Subject Id") because we will need them for calculate mean.

<!-- -->
    FeatureNumbersToSave <-c(2,3,FeaturesWithMeanAndStd)
    allTogetherOnlySaved <- allTogether[,FeatureNumbersToSave]

####Step 9:
Calculate mean of all features for ActivityName + SubjectId using `melt` and `dcast` from `reshape2` library as it was in lecture 3:4

<!-- -->
    library(reshape2)
    AllMelt <- melt(allTogetherOnlySaved, id=c("ActivityName","SubjectId"), measure.var=names(allTogetherOnlySaved[3:80]))
    MeanForEach <- dcast(AllMelt, ActivityName + SubjectId ~ variable, mean)

####Step 10:
Write the output to the file using `write.table` function with `row.names=FALSE, col.names=TRUE`

<!-- -->
    write.table(MeanForEach,"CourseProject.txt", row.names=FALSE, col.names=TRUE)
    
For more information please look at "run_analyses.R": it has more operations and comments.