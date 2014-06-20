#
# Cleaning Data - Final Project - run_analysis.R
#
# - the current working directory should be set to the "UCI HAR Dataset" directory
# - the working directory must contain:
#   - "activity_labels.txt", "features.txt"
#   - "test" and "train" directories, which will each contain:
#       - subject, X, and y text data files
#

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and
# each subject.


# *** Load the list of 561 features -- the order corresponds to the 561 columns of the input data ***
featuresList <- read.table("./features.txt", stringsAsFactors = FALSE) # need to strip out ( ) , - 


# *** Load in the data of each of the 561 features, in both the testing and training subjects ***

    # FULLFILLS REQUIREMENT: "Merges the training and the test sets to create one data set"
inputData_dfrm <- rbind(read.table("./test/X_test.txt"), read.table("./train/X_train.txt"))


# *** Select a subset of feature columns of interest and clean up the names ***
# - keeping "only the measurements on the mean and standard deviation for each measurement"
# - I have elected to keep the 33 features containing "mean()" and 33 features containing "std()"
#   because these 66 features are matched to each other and appear to be a sensible set
# - there are an additional 20 features which contain the word "mean" which are not included
#   these additional features could easily be included by changing the grepl selection
# - the feature names contain characters like (),- that need to be stripped out

keepColumns <- grepl("mean\\(\\)|std\\(\\)", featuresList[,2], ignore.case = TRUE) # returns a logical vector of the features we want to keep
columnNames <- featuresList[keepColumns,2] # returns a list of the text names of the 66 features we are keeping
columnNames <- gsub("-mean\\(\\)-?", "Mean", columnNames) # replace "-mean()" (and trailing hyhpen if present) with "Mean"
columnNames <- gsub("-std\\(\\)-?", "StdDev", columnNames) # replace "-std()" (and trailing hyhpen if present) with "StdDev"


# *** Create a new extract from the input dataset with only the columns of interest ***

    # FULLFILLS REQUIREMENT: "Extracts only the measurements on the mean and standard deviation for each measurement"
dataExtract <- inputData_dfrm[,keepColumns]

    # FULLFILLS REQUIREMENT: "Appropriately labels the data set with descriptive variable names"
colnames(dataExtract) <- columnNames
remove(inputData_dfrm) # it's a relatively big dataset, so remove from memory

# *** Add corresponding activity label for each measurement ***

activity_labels <- read.table("./activity_labels.txt") # activities are in numeric activity code
activityData_dfrm <- rbind(read.table("./test/y_test.txt"), read.table("./train/y_train.txt")) # read in both the testing and training subjects
activityData_dfrm <- activity_labels[activityData_dfrm[,1],2] # change activity code to text factor

    # FULLFILLS REQUIREMENT: "Appropriately labels the data set with descriptive variable names"
dataExtract <- cbind(Activity = activityData_dfrm, dataExtract) # add activity column to our data extract


# *** Add corresponding subject number for each measurement ***

subjects_dfrm <- rbind(read.table("./test/subject_test.txt"), read.table("./train/subject_train.txt")) # read in both the testing and training subjects
colnames(subjects_dfrm) <- "Subject" # give column a descriptive label
dataExtract <- cbind(subjects_dfrm, dataExtract) # add subject code number to our data extract




# *** Create a tidy data set with averages of each extracted feature, for each activity, and for each subject ***

    # FULLFILLS REQUIREMENT: "Creates a second, independent tidy data set with the average of each variable for each activity and each subject"
    # - this is a tidy dataset because:
    #   - there is one variable per column, each row is a separate observation, and each type of observational unit is a table

tidyAverages <- aggregate(dataExtract[,3:68], list(Subject = dataExtract$Subject, Activity = dataExtract$Activity), mean) # mean of each of the 66 features, grouped by each activity + subject
colnames(tidyAverages) <- c("Subject", "Activity", paste("mean_", names(tidyAverages[,3:68]), sep = "")) # give more descriptive names to the variables



# *** Output the tidy data set as a comma-separated value text file ***
# - the file can be read back into R with the command: tidyAverages <- read.table("output.csv", header = TRUE, sep = ",")

write.table(tidyAverages, file = "tidyTableOutput.csv", sep = ",", row.names = FALSE) # output the tidy data set as a CSV file


