datasciencecoursera
===================

Coursera Data Science Repository

Course #3 -- "Getting and Cleaning Data" -- Final Project

---

In this repository directory are several files for the final project for Coursera's "Getting and Cleaning Data", including:

* README.md
   this file

* run_analysis.R
   R script to analyze the data

* tidyTableOutput.csv
   Tidy data set output of run_analysis.R

* codebook.txt
   Code book describing each column variable of the tidy data set output of run_analysis.R

---

run_analysis.R
==============

This script takes the UCI HAR Dataset files and:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

There are detailed comments in the run_analysis.R script that explain how each step is performed.

But in brief, the input data files consist of separating "training" and "test" data sets.

For each of these, there are 3 files:

* an "X" file of the input data with each row being an observation, with 561 columns of data measurements
* a "y" file, with each row corresponding to the same observation in "X", with a column listing the activity code during the measurement
* a "subject" file, with each row corresponding to the same observation in "X", with a column listing the subject number (30 subjects)

There are also the following 2 files, which describe the features and activities:

* a "features.txt" file, which lists the 561 features names, in the same order as the columns of the "X" file
* a "activity_labels.txt" file, a code book converting the numeric code of the 6 activities to an English description

The script:
* combines the "training" and "test" data set files ("X", "y", "Subject")
* extracts only the 66 of the 561 features corresponding to 33 pairs of means and standard deviations of measurements
* uses the text in "features.txt" to appropriately name the columns, after removing / replacing problematic characters
* converts the activity numeric codes to readable text factors
* aggregates the data into a second, independent tidy data set with the average of each of the 66 variables for each activity and each subject
* exports the second tidy data set using write.table, with instructions how to re-load the table back into R using read.table
