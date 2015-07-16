setwd("D:\\Coursera\\Getting and Cleaning Data\\Project")


## Reading Data
activityTest  <- read.table("./dataset/test/Y_test.txt" ,header = FALSE)
activityTrain <- read.table("./dataset/train/Y_train.txt" ,header = FALSE)

subjectTrain <- read.table("./dataset/train/subject_train.txt",header = FALSE)
subjectTest  <- read.table("./dataset/test/subject_test.txt",header = FALSE)

featuresTest  <- read.table("./dataset/test/X_test.txt" ,header = FALSE)
featuresTrain <- read.table("./dataset/train/X_train.txt",header = FALSE)

featuresLabel <- read.table("./dataset/features.txt",header = FALSE)

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

##1- Merges the training and the test sets to create one data set.
subject <- rbind(subjectTrain, subjectTest)
activity<- rbind(activityTrain, activityTest)
features<- rbind(featuresTrain, featuresTest)

##4-Appropriately labels the data set with descriptive variable names
names(subject)<-c("subject")
names(activity)<- c("activity")
names(features)<- featuresLabel$V2

##1- Merges the training/test and Subject and Activity sets to create one data set(Continue.
temp <- cbind(subject, activity)
Data <- cbind(features, temp)

##2-Extracts only the measurements on the mean and standard deviation for each 
## measurement. 
meanStdLabels<-featuresLabel[grep("mean\\(|std\\(", featuresLabel$V2),2]
allLabels<-c(as.character(meanStdLabels), "subject", "activity" )
Data<-subset(Data,select=allLabels)

##3-Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("./dataset/activity_labels.txt",header = FALSE)
activityLabels=activityLabels$V2
Data$activity=activityLabels[Data$activity]

##4-Appropriately labels the data set with descriptive variable names(continue)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


##5-From the data set in step 4, creates a second, independent tidy data set with the
##average of each variable for each activity and each subject.
tidyData<-aggregate(. ~subject + activity, Data, mean)


write.table(tidyData, file = "tidydata.txt",row.name=FALSE)