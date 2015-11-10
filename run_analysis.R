###---Read in features and activity labels---###
features <- read.table("features.txt")["V2"]
activity_labels <- read.table("activity_labels.txt")["V2"]


###---Read in train dataset---###
X_train <- read.table("X_train.txt")
names(X_train) <- features$V2 #assigns features to X_train dataset
#head(X_train)
y_train <- read.table("y_train.txt")
names(y_train) <- "labels" #sets column name to "labels"
#head(y_train)

#Read in subject train dataset
subject_train <- read.table("subject_train.txt")
names(subject_train) <- "subjects" #sets column name to "subjects"
#Check dimensions
dim(X_train)
dim(y_train)
dim(subject_train)


###---Read in test dataset---###
X_test <- read.table("X_test.txt")
names(X_test) <- features$V2 #assigns features to X_test dataset
#head(X_test)
y_test <- read.table("y_test.txt")
names(y_test) <- "labels" #sets column name to "labels"
#head(y_test)

#Read in subject test dataset
subject_test <- read.table("subject_test.txt")
names(subject_test) <- "subjects"

#Check dimensions
dim(X_test)
dim(y_test)
dim(subject_test)


#find indces of columns corresponding to mean/std data 
indices_of_means_and_stds <- grep("mean|std",features$V2)
## Extract only the measurements on the mean and standard deviation for each measurement
means_and_std_colnames <- colnames(X_test)[indices_of_means_and_stds]
X_test_subset <- cbind(subject_test,y_test,subset(X_test,select=means_and_std_colnames))
X_train_subset <- cbind(subject_train,y_train,subset(X_train,select=means_and_std_colnames))


###---Combine data sets---###
Xy <- rbind(X_test_subset, X_train_subset)


###---Create a second, independent tidy data set with the average of each variable for each activity and each subject---###
tidy <- aggregate(Xy[,3:ncol(Xy)],list(Subject=Xy$subjects, Activity=Xy$labels), mean)
tidy <- tidy[order(tidy$Subject),]


#Label activity with proper labels
tidy$Activity <- activity_labels[tidy$Activity,]

#write to file
write.table(tidy, file="./tidydata.txt", sep="\t", row.names=FALSE)
