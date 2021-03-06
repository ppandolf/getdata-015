#################################################################
# run_analysis.R  compiles physical activity data collected 
# from the accelerometers from the Samsung Galaxy S smartphone 
# please see README and code book documentation for details
# this script is written to read input files from the
# /data/UCI HAR Dataset subdirectory within current working directory
#################################################################

library(dplyr)

##################################
# Read All Input Files
##################################
x_test_readings <- read.table("./data/UCI HAR Dataset/test/X_test.txt",colClasses = "numeric",comment.char = "")
y_test_activities <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
z_test_subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

x_train_readings <- read.table("./data/UCI HAR Dataset/train/X_train.txt", colClasses = "numeric",comment.char = "")
y_train_activities <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
z_train_subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")

######################################################
# Assign Subject and Activity ID Variable Names  
######################################################
names(z_test_subjects)[1] <- "SubjectID"
names(z_train_subjects)[1] <- "SubjectID"
names(y_test_activities)[1] <- "ActivityID"
names(y_train_activities)[1] <- "ActivityID"

######################################################
# Add Train-Test class variable to Subject Data
######################################################
z_test_subjects <- mutate(z_test_subjects, SubjectClass = "Test")
z_train_subjects <- mutate(z_train_subjects, SubjectClass = "Train")

########################################################################
# Extract - Determine and Select Measurements to Keep For Analysis
# using features file row indexes. Keeping mean() and std(), NOT freqMean      
########################################################################
meanStdColumns <- grep("mean|std", features$V2, value = FALSE)
meanFreqColumns <- grep("meanFreq", features$V2, value = FALSE)

colstokeep <- meanStdColumns[!meanStdColumns %in% meanFreqColumns]
xtrct_test <- x_test_readings[,colstokeep]
xtrct_train <- x_train_readings[,colstokeep]

#######################################################################
# Combining Subject, Activity and Reading detail within each class First
# Then the Test and Training samples are (vertically) combined  
#######################################################################
xyz_test <- cbind(z_test_subjects, y_test_activities, xtrct_test)
xyz_train <- cbind(z_train_subjects, y_train_activities, xtrct_train)

merged_data <- rbind(xyz_test, xyz_train)


#######################################################################
# Original input and interim tables can be cleared now      
#######################################################################
rm(x_test_readings, y_test_activities, z_test_subjects) 
rm(x_train_readings, y_train_activities, z_train_subjects)
rm(xtrct_test, xtrct_train)
rm(xyz_test, xyz_train) 

#######################################################################
# Apply the Actvity labels   
#######################################################################
merged_data$ActivityID[merged_data$ActivityID == 1] <- as.character(activity_labels$V2[1])
merged_data$ActivityID[merged_data$ActivityID == 2] <- as.character(activity_labels$V2[2])
merged_data$ActivityID[merged_data$ActivityID == 3] <- as.character(activity_labels$V2[3])
merged_data$ActivityID[merged_data$ActivityID == 4] <- as.character(activity_labels$V2[4])
merged_data$ActivityID[merged_data$ActivityID == 5] <- as.character(activity_labels$V2[5])
merged_data$ActivityID[merged_data$ActivityID == 6] <- as.character(activity_labels$V2[6])


#######################################################################
# Correct and apply the measurement aka "features" names   
#######################################################################
features$V2 <- gsub("BodyBody", "Body", features$V2)
features$V2 <- make.names(features$V2, unique=TRUE, allow_=TRUE)

vnames <- (features$V2[colstokeep])
knames <- c("SubjectID" ,   "SubjectGroup" ,"Activity")

names(merged_data) <- c(knames, vnames)


#######################################################################
# Calculate arithmetic mean of each measurement variable 
# by subject-actvity combination   
#######################################################################
arrange(merged_data, Activity, SubjectID)

tdata <- summarize(group_by(merged_data, Activity, SubjectID), 
avgtimeBodyAcc.mean.Xaxis =  mean(tBodyAcc.mean...X, na.rm  =  TRUE),
avgtimeBodyAcc.mean.Yaxis =  mean(tBodyAcc.mean...Y, na.rm  =  TRUE),
avgtimeBodyAcc.std.Zaxis =  mean(tBodyAcc.std...Z, na.rm  =  TRUE),
avgtimeGravityAcc.std.Xaxis =  mean(tGravityAcc.std...X, na.rm  =  TRUE),
avgtimeBodyAccJerk.mean.Yaxis =  mean(tBodyAccJerk.mean...Y, na.rm  =  TRUE),
avgtimeBodyAccJerk.std.Zaxis =  mean(tBodyAccJerk.std...Z, na.rm  =  TRUE),
avgtimeBodyGyro.std.Xaxis =  mean(tBodyGyro.std...X, na.rm  =  TRUE),
avgtimeBodyGyroJerk.mean.Yaxis =  mean(tBodyGyroJerk.mean...Y, na.rm  =  TRUE),
avgtimeBodyGyroJerk.std.Zaxis =  mean(tBodyGyroJerk.std...Z, na.rm  =  TRUE),
avgtimeGravityAccMag.std.. =  mean(tGravityAccMag.std.., na.rm  =  TRUE),
avgtimeBodyGyroMag.std.. =  mean(tBodyGyroMag.std.., na.rm  =  TRUE),
avgfreqBodyAcc.mean.Yaxis =  mean(fBodyAcc.mean...Y, na.rm  =  TRUE),
avgfreqBodyAcc.std.Zaxis =  mean(fBodyAcc.std...Z, na.rm  =  TRUE),
avgfreqBodyAccJerk.std.Xaxis =  mean(fBodyAccJerk.std...X, na.rm  =  TRUE),
avgfreqBodyGyro.mean.Yaxis =  mean(fBodyGyro.mean...Y, na.rm  =  TRUE),
avgfreqBodyGyro.std.Zaxis =  mean(fBodyGyro.std...Z, na.rm  =  TRUE),
avgfreqBodyAccJerkMag.std.. =  mean(fBodyAccJerkMag.std.., na.rm  =  TRUE),
avgfreqBodyGyroJerkMag.std.. =  mean(fBodyGyroJerkMag.std.., na.rm  =  TRUE),
avgtimeBodyAcc.mean.Zaxis =  mean(tBodyAcc.mean...Z, na.rm  =  TRUE),
avgtimeGravityAcc.mean.Xaxis =  mean(tGravityAcc.mean...X, na.rm  =  TRUE),
avgtimeGravityAcc.std.Yaxis =  mean(tGravityAcc.std...Y, na.rm  =  TRUE),
avgtimeBodyAccJerk.mean.Zaxis =  mean(tBodyAccJerk.mean...Z, na.rm  =  TRUE),
avgtimeBodyGyro.mean.Xaxis =  mean(tBodyGyro.mean...X, na.rm  =  TRUE),
avgtimeBodyGyro.std.Yaxis =  mean(tBodyGyro.std...Y, na.rm  =  TRUE),
avgtimeBodyGyroJerk.mean.Zaxis =  mean(tBodyGyroJerk.mean...Z, na.rm  =  TRUE),
avgtimeBodyAccMag.mean.. =  mean(tBodyAccMag.mean.., na.rm  =  TRUE),
avgtimeBodyAccJerkMag.mean.. =  mean(tBodyAccJerkMag.mean.., na.rm  =  TRUE),
avgtimeBodyGyroJerkMag.mean.. =  mean(tBodyGyroJerkMag.mean.., na.rm  =  TRUE),
avgfreqBodyAcc.mean.Zaxis =  mean(fBodyAcc.mean...Z, na.rm  =  TRUE),
avgfreqBodyAccJerk.mean.Xaxis =  mean(fBodyAccJerk.mean...X, na.rm  =  TRUE),
avgfreqBodyAccJerk.std.Yaxis =  mean(fBodyAccJerk.std...Y, na.rm  =  TRUE),
avgfreqBodyGyro.mean.Zaxis =  mean(fBodyGyro.mean...Z, na.rm  =  TRUE),
avgfreqBodyAccMag.mean.. =  mean(fBodyAccMag.mean.., na.rm  =  TRUE),
avgfreqBodyGyroMag.mean.. =  mean(fBodyGyroMag.mean.., na.rm  =  TRUE),
avgtimeBodyAcc.std.Xaxis =  mean(tBodyAcc.std...X, na.rm  =  TRUE),
avgtimeGravityAcc.mean.Yaxis =  mean(tGravityAcc.mean...Y, na.rm  =  TRUE),
avgtimeGravityAcc.std.Zaxis =  mean(tGravityAcc.std...Z, na.rm  =  TRUE),
avgtimeBodyAccJerk.std.Xaxis =  mean(tBodyAccJerk.std...X, na.rm  =  TRUE),
avgtimeBodyGyro.mean.Yaxis =  mean(tBodyGyro.mean...Y, na.rm  =  TRUE),
avgtimeBodyGyro.std.Zaxis =  mean(tBodyGyro.std...Z, na.rm  =  TRUE),
avgtimeBodyGyroJerk.std.Xaxis =  mean(tBodyGyroJerk.std...X, na.rm  =  TRUE),
avgtimeBodyAccMag.std.. =  mean(tBodyAccMag.std.., na.rm  =  TRUE),
avgtimeBodyAccJerkMag.std.. =  mean(tBodyAccJerkMag.std.., na.rm  =  TRUE),
avgtimeBodyGyroJerkMag.std.. =  mean(tBodyGyroJerkMag.std.., na.rm  =  TRUE),
avgfreqBodyAcc.std.Xaxis =  mean(fBodyAcc.std...X, na.rm  =  TRUE),
avgfreqBodyAccJerk.mean.Yaxis =  mean(fBodyAccJerk.mean...Y, na.rm  =  TRUE),
avgfreqBodyAccJerk.std.Zaxis =  mean(fBodyAccJerk.std...Z, na.rm  =  TRUE),
avgfreqBodyGyro.std.Xaxis =  mean(fBodyGyro.std...X, na.rm  =  TRUE),
avgfreqBodyAccMag.std.. =  mean(fBodyAccMag.std.., na.rm  =  TRUE),
avgfreqBodyGyroMag.std.. =  mean(fBodyGyroMag.std.., na.rm  =  TRUE),
avgtimeBodyAcc.std.Yaxis =  mean(tBodyAcc.std...Y, na.rm  =  TRUE),
avgtimeGravityAcc.mean.Zaxis =  mean(tGravityAcc.mean...Z, na.rm  =  TRUE),
avgtimeBodyAccJerk.mean.Xaxis =  mean(tBodyAccJerk.mean...X, na.rm  =  TRUE),
avgtimeBodyAccJerk.std.Yaxis =  mean(tBodyAccJerk.std...Y, na.rm  =  TRUE),
avgtimeBodyGyro.mean.Zaxis =  mean(tBodyGyro.mean...Z, na.rm  =  TRUE),
avgtimeBodyGyroJerk.mean.Xaxis =  mean(tBodyGyroJerk.mean...X, na.rm  =  TRUE),
avgtimeBodyGyroJerk.std.Yaxis =  mean(tBodyGyroJerk.std...Y, na.rm  =  TRUE),
avgtimeGravityAccMag.mean.. =  mean(tGravityAccMag.mean.., na.rm  =  TRUE),
avgtimeBodyGyroMag.mean.. =  mean(tBodyGyroMag.mean.., na.rm  =  TRUE),
avgfreqBodyAcc.mean.Xaxis =  mean(fBodyAcc.mean...X, na.rm  =  TRUE),
avgfreqBodyAcc.std.Yaxis =  mean(fBodyAcc.std...Y, na.rm  =  TRUE),
avgfreqBodyAccJerk.mean.Zaxis =  mean(fBodyAccJerk.mean...Z, na.rm  =  TRUE),
avgfreqBodyGyro.mean.Xaxis =  mean(fBodyGyro.mean...X, na.rm  =  TRUE),
avgfreqBodyGyro.std.Yaxis =  mean(fBodyGyro.std...Y, na.rm  =  TRUE),
avgfreqBodyAccJerkMag.mean.. =  mean(fBodyAccJerkMag.mean.., na.rm  =  TRUE),
avgfreqBodyGyroJerkMag.mean.. =  mean(fBodyGyroJerkMag.mean.., na.rm  =  TRUE))


#######################################################################
# Write out dataset for analysis 
# commented statements following the write can be used to 
# read the dataset back in from the /data subdirectory within 
# current working directory  
#######################################################################
write.table(tdata, file = "./data/getdata015_HARtidy.txt",row.name=FALSE) 

#mytidy <- read.table("./data/getdata015_HARtidy.txt")
#View(mytidy)



