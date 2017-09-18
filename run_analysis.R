# Getting and CLeaning Data Course Project #
#------------------------------------------#
# Purpose #
#---------#
# You should create one R script called 
# run_analysis.R that does the following.
#
# Objective 1: Merges the training and the test sets to create one data set.
# Objective 2: Extracts only the measurements on the mean and standard 
#    deviation for each measurement.
# Objective 3: Uses descriptive activity names to name the activities
#    in the data set
# Objective 4: Appropriately label the data set with descriptive variable
#    names.
#
# From the data set in step 4, creates a second, independent 
# tidy data set with the average of each variable for each 
# activity and each subject.
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
# Objective 1 #
#-------------#
library(dplyr)
# Download data from web
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("~/Documents/DataScience/Course 3/Programming Assignment/DATA"))
  {dir.create("~/Documents/DataScience/Course 3/Programming Assignment/DATA")}
download.file(URL,destfile = 
"~/Documents/DataScience/Course 3/Programming Assignment/DATA/SmartPhone_Dataset.zip")
unzip(zipfile=
"~/Documents/DataScience/Course 3/Programming Assignment/DATA/SmartPhone_Dataset.zip"
,exdir="~/Documents/DataScience/Course 3/Programming Assignment/DATA")
list.files("~/Documents/DataScience/Course 3/Programming Assignment/DATA")
# SmartPhone_Dataset.zip" "UCI HAR Dataset"

setwd("~/Documents/DataScience/Course 3/Programming Assignment/DATA")
# Read Test and Train Files 
# Test Set
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
# Train Set
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
# Activity Labels
activityXREF <- read.table("UCI HAR Dataset/activity_labels.txt") 
# Features data
features <- read.table("UCI HAR Dataset/features.txt")
activityXREF
# Create Columns to Organize Data
# Subject_ID
ID <- "Subject_ID"
colnames(subject_test) <- ID
colnames(subject_train) <- ID

# Activity_CD & Description
ID = "Activity_CD"
DESC = "Activity_Desc"
colnames(activityXREF) <- c(ID,DESC)
colnames(y_test) = c(ID)
colnames(y_train) = c(ID)

# Add Features as Header to x Test/Train data
head(features) #Column Header for each Test/Train file
nrow(features) #561
ncol(x_test)   #561


header <- features[,2]
colnames(x_test)  <- header
colnames(x_train) <- header

# Append Subject ID to Data and Identify as Test or Train
x_test$SET <- "Test"
x_train$SET <- "Train"
nrow(x_test) #2947
nrow(subject_test) #2947
nrow(y_test) #2947
nrow(x_train) #7352
nrow(subject_train) #7352
nrow(y_train) #7352
# No common column, same # rows, use cbind to combine columns
TEST_SET <- cbind(subject_test, y_test, x_test)
TRAIN_SET <- cbind(subject_train, y_train, x_train)
names(TEST_SET) #OK
nrow(TEST_SET) #2947
names(TRAIN_SET) #OK
nrow(TRAIN_SET) #7352
2947+7352 #10299
# Append TEST_SET AND TRAIN_SET using rbind to combine rows
Data_Set <- rbind(TEST_SET, TRAIN_SET)
names(Data_Set) #OK
nrow(Data_Set)  #10299
ncol(Data_Set)  #564
# OBJECTIVE 1 COMPLETE #
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
# Objective 2 #
#-------------#
# Find all columns that have the mean and std for each measurement #
# Keep Subject_ID, Activity_CD, SET, and any colun that includes
# mean or std in the variable name (upper or lowercase)

MEAN_STD <-
  Data_Set[,grep("(Subject_ID|Activity_CD|SET|[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd])",
                 colnames(Data_Set))]
names(MEAN_STD)
#NOTE - Identified 7 columns with angle(): Angle between to vectors.
#       Excluding all fields with angle since these are not 
#       mean or std measurements
MEAN_STD_ADJ <-
  MEAN_STD[,-(grep("^[Aa][Nn][Gg][Ll][Ee]",colnames(MEAN_STD)))]
names(MEAN_STD_ADJ)
ncol(MEAN_STD_ADJ) #82
nrow(MEAN_STD_ADJ) #10299

# OBJECTIVE 2 COMPLETE #
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
# Objective 3 #
#-------------#
# Adding description to the Activity ID using merge 
Mean_Std_Names <- merge(x=MEAN_STD_ADJ,y=activityXREF,
                        by.x=c("Activity_CD"),
                        by.y=c("Activity_CD")
                        )
names(Mean_Std_Names)
nrow(Mean_Std_Names) #10299
head(Mean_Std_Names) #ok
# OBJECTIVE 3 COMPLETE #
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
# Objective 4 #
#-------------#
## SEE above, Objective 1. Column Names created to help
## organize data.
names(Mean_Std_Names)
# Organinze Names
# Rename Mean Fields
# Prefix #
# f = Freq =Frequency
names(Mean_Std_Names) <- gsub("^f","Freq",colnames(Mean_Std_Names))
names(Mean_Std_Names)
# t = Time
names(Mean_Std_Names) <- gsub("^t","Time",colnames(Mean_Std_Names))
names(Mean_Std_Names)
# -mean = Mean
names(Mean_Std_Names) <- gsub("-mean","Mean",colnames(Mean_Std_Names))
names(Mean_Std_Names)
# -std = Std
names(Mean_Std_Names) <- gsub("-std","Std",colnames(Mean_Std_Names))
names(Mean_Std_Names)
# ()|- = ""
names(Mean_Std_Names) <- gsub("\\(\\)|-","",colnames(Mean_Std_Names))
names(Mean_Std_Names)
# ()|- = ""
names(Mean_Std_Names) <- gsub("BodyBody","Body",colnames(Mean_Std_Names))
names(Mean_Std_Names)
head(Mean_Std_Names)
#ReOrder Columns & Rename TIDY_DATA
# SET, Subject_ID, Activity_CD, Activity_Desc,Others
TIDY_DATA <-
Mean_Std_Names %>%
  select(SET, Subject_ID,Activity_CD,Activity_Desc, TimeBodyAccMeanX:FreqBodyGyroJerkMagMeanFreq)
names(TIDY_DATA)
head(TIDY_DATA)
ncol(Mean_Std_Names) #83
ncol(TIDY_DATA) #83
nrow(Mean_Std_Names) #10299
nrow(TIDY_DATA) #10299
# Remove all rows with incomplete cases
TIDY_DATA <- TIDY_DATA[complete.cases(TIDY_DATA),]
ncol(TIDY_DATA) #83
nrow(TIDY_DATA) #10299 No rows removed
# Includes Activity_CD, Activity_Desc,
#          Subject_ID, SET (Train or Test),
#          and all fields with mean or std in the name,
#          excluding angle fields
# OBJECTIVE 4 COMPLETE #
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
# Mean_Std_Names Tidy Data Set built #
# CREATING SECOND TIDY DATA SET with
# Average of each variable per Subject/Activity
BY_VARS <-
  TIDY_DATA %>%
    group_by(Subject_ID, Activity_CD, Activity_Desc)

TIDY_MEANS <- BY_VARS %>% summarize_if(is.numeric,mean) # Ignores the SET Variable
names(TIDY_MEANS) # Excludes SET
nrow(TIDY_MEANS) #180
setwd("~/Documents/DataScience/Course 3/Programming Assignment")
write.table(TIDY_MEANS,"TIDY_MEANS.txt",row.names = FALSE )
# TIDY_MEANS COMPLETE #
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#