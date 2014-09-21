#Merge files for test
#
activity_labels <- read.table("~/activity_labels.txt", quote="")
features <- read.table("~/features.txt", quote="\"")
X_test <- read.table("~/test/X_test.txt", quote="\"")
names (X_test) <- as.vector(features$V2)
y_test <- read.table("~/test/y_test.txt", quote="\"")
names (y_test) <- "labeln"
mergedtest = cbind(y_test[1],X_test)
subject_test <- read.table("~/test/subject_test.txt", quote="\"")
names (subject_test) <- "subject"
mergedtest = cbind(subject_test[1],mergedtest)
#
#merge files for train
#
X_train <- read.table("~/train/X_train.txt", quote="\"")
names (X_train) <- as.vector(features$V2)
y_train <- read.table("~/train/y_train.txt", quote="\"")
names (y_train) <- "labeln"
mergedtrain = cbind(y_train[1],X_train)
subject_train <- read.table("~/train/subject_train.txt", quote="\"")
names (subject_train) <- "subject"
mergedtrain = cbind(subject_train[1],mergedtrain)
#merge all
#
mergeall <- rbind(mergedtrain, mergedtest)
#
# extracts only mean and standard deviation for each measurement
#
txt <- names(mergeall)
if(length(i <- grep("mean", txt, ignore.case = TRUE)))i
txt[i]
vars1 <- subset(mergeall, select = txt[i])
if(length(j <- grep("std", txt, ignore.case = TRUE)))j
txt[j]
vars2 <- subset(mergeall, select = txt[j])
dfextracted <- cbind(mergeall[1:2],vars1,vars2)
#
# use activity lavels to name activities in the data set
#
dfextracted$labeln <- replace(dfextracted$labeln,dfextracted$labeln==1,"WALKING")
dfextracted$labeln <- replace(dfextracted$labeln,dfextracted$labeln==2,"WALKING_UPSTAIRS")
dfextracted$labeln <- replace(dfextracted$labeln,dfextracted$labeln==3,"WALKING_DOWNSTAIRS")
dfextracted$labeln <- replace(dfextracted$labeln,dfextracted$labeln==4,"SITTING")
dfextracted$labeln <- replace(dfextracted$labeln,dfextracted$labeln==5,"STANDING")
dfextracted$labeln <- replace(dfextracted$labeln,dfextracted$labeln==6,"LAYING")
#
#creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
#
names(dfextracted) <- tolower(names(dfextracted))
final <- melt(dfextracted, id=c("subject_test", "labeln"), na.rm=TRUE)
acast(final, subject_test ~ labeln ~ variable)
#
#write the final data set
#
write.table(final, file="./final.txt", row.names=FALSE)
