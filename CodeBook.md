# CodeBook.md

### Dataset: Raw Data
The data linked to the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
  
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data for the project:
  
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  
##### The original dataset includes the following files:

* 'README.txt': Provides a detailed overview of the original Dataset

* 'features_info.txt': Shows information about the variables used on the feature vector.

* 'features.txt': List of all features.

* 'activity_labels.txt': Links the class labels with their activity name.

* 'train/X_train.txt': Training set.

* 'train/y_train.txt': Training labels.

* 'test/X_test.txt': Test set.

* 'test/y_test.txt': Test labels.

An R script called run_analysis.R applies the following to the raw data:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### DataSet: TIDY_DATA
Dataset built by appending Subject ID and Activity to Data Outcomes, identifying each subset as Test or Train with the SET variable and then appending Test and Train Datasets.  The final dataset is cleaned up to include only those outcomes variables that measure the mean or standard deviation.  Final step checks that all rows have complete data using complete.cases.  Code found in run_analysis.R with detailed notes for each datastep.  Variables follow:

| **Variable** | **Description** | **Source** |
| :--- | :--- | :--- |
| SET | Test or Train | X_test.txt; X_train.txt |
| Subject_ID | Participant 1 thru 30 | subject_test.txt; subject_train.txt |
| Activity_CD | Activity Code 1 thru 6 | y_test.txt; y_train.txt |
| Activity_Desc| Activity Description (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) | activity_labels.txt
| Outcomes Data | Mean and Standard Deviation Outcomes |  X_test.txt; X_train.txt |

#### **Mean and Standard Deviation Outcomes** *(Heading Adjustments)* 
* Replace t with Time 
* Replace f with Freq
* Replace mean with Mean
* Replace std with Std 
* Remove () and -
* Omit Angle fields 
* Replace BodyBody with Body

### DataSet: TIDY_MEANS
Dataset built off of TIDY_DATA (only source table).  The data is grouped by Subject ID and Activity, and then all Mean an Std outcomes are averaged.  The resulting data set provides the average of each variable for each activity and each subject.  Code found in run_analysis.R with detailed notes for each datastep. Variables follow: 

| **Variable** | **Description** |
| :--- | :--- |
| Subject_ID | Participant 1 thru 30 | 
| Activity_CD | Activity Code 1 thru 6 |
| Activity_Desc| Activity Description (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) | activity_labels.txt
| Outcomes Data | Average of Mean and Standard Deviation Outcomes |
