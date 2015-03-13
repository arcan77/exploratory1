# Downloading and unzipping initial archive
tempfile <- tempfile()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, tempfile, method="curl")
unzip(tempfile)  # unzip our archive
unlink(tempfile) #delete temporary file
setwd("UCI HAR Dataset")

#Opening feature file and setting its column names
features <- read.table("features.txt")
names(features) <- c("FeatureId","FeatureName")
#Opening activity labels file and setting its column names
activityLabels <- read.table("activity_labels.txt")
names(activityLabels) <- c("ActivityId","ActivityName")
#Opening test and train files
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

#Merge trainX + trainSubject + trainLabels together into allTrain
allTrain <- cbind(trainSubject, trainLabels, trainX)
#Merge testX + testSubject + testLabels together into allTest
allTest <- cbind(testSubject, testLabels, testX)

#Merge allTrain + allTest together
all <- rbind(allTrain,allTest)

#Join it with the activityLabels to take activityName from activityId
allWithLabels <- merge(all,activityLabels,by.x="ActivityId",by.y="ActivityId", all=FALSE)

#Replace factor vector Activity Name to the second position. It is more comfortable for me:)
a <- allWithLabels[1]
b <- allWithLabels[564]
c <- allWithLabels[2:563]
allTogether <- cbind (a,b,c)

#Getting numbers of features with "mean" and "std"
FeatureNumbersWithMeans <- grep("mean()",features$FeatureName, value=FALSE)
FeatureNumbersWithStd <- grep("std()",features$FeatureName, value=FALSE)
FeatureNumbers <- sort(c(FeatureNumbersWithMeans, FeatureNumbersWithStd))

#In the result AllTogether data frame we have first 3 columns "ActivityId","ActivityName","SubjectId"
#So our feature columns numbers begins with 4
#So we need to increase FeatureNumbers vector by 3
FeaturesWithMeanAndStd <- FeatureNumbers+3
#Combine numbers of FeaturesWithMeanAndStd and second and third column that we want to save
# to calculate later means and standart deviations
FeatureNumbersToSave <-c(2,3,FeaturesWithMeanAndStd)

#Cutting AllTogether dataframe for a piece with only needed columns
allTogetherOnlySaved <- allTogether[,FeatureNumbersToSave]

# Now we finaly calculate the mean() of every feature for every
library(reshape2)
AllMelt <- melt(allTogetherOnlySaved, id=c("ActivityName","SubjectId"), measure.var=names(allTogetherOnlySaved[3:80]))
MeanForEach <- dcast(AllMelt, ActivityName + SubjectId ~ variable, mean)

#Job's done! Now we need to write the result to output file
setwd("..")
write.table(MeanForEach,"CourseProject.txt", row.names=FALSE, col.names=TRUE)

# Thanks for you attention :)


