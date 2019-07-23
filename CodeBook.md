---
title: "CodeBook"
author: "Oscar Gabauquer"
date: "22 de julio de 2019"
output: html_document
---

# LIBRARY REQUIRED

* dplyr


# EXPLANATION


## STEP 1: Working with the train data:
	
	1. Start by loading the subject_train.txt file contents, to a dataframe called
	   trainSubjects.

	2. Rename the only column to a meaningful name like subjectID.

	3. Load the y_train.txt file contents to a dataframe called trainActivityIds.

	4. Rename the only column to a meaningful name like activityId.

	5. Create a new dataframe called trainDF by column binding the above datasets. 
	   With this, we have a data frame that relates the train subjects with each 
	   activity they performed.

	6. Load the X_train.txt file contents, to a dataframe called trainFeatureVectors.

	7. Load the features.txt file contents, to a dataframe called featuresLabels.

	8. With the features.txt data loaded, now we have all the names for the 
       measurements, but these names need to be cleaned from special characters. We'll
       start by removing the dashes, this is done by a function called "removeDashes".

    9. When the X_train data was loaded, R, by default gave each measurement a generic
       name, so now we need to rename and give those measurements their respective 
       name, we'll do this by renaming all the columns with the function "colnames"
       assigning them the names we cleaned from the featuresLabels data set.

   10. Select only the measurements from the trainFeatureVectors data set that we care, 
       in this case, the ones that are mean and std measurements. We'll do this by 
       following two steps:

   	   1. Select all the non duplicated columns in the trainFeatureVectors data set, 
   	      since there are duplicated columns, and these, cause the dplyr functions to 
   	      not work. There is no problem doing this, since the duplicated columns are 
   	      not mean or std measurements.

   	   2. Use dplyr's "select" function to get the columns that match "Mean()" and
   	      "Std()" patterns, to a dataframe called finalTrainFeatureVectors.

   	11. With the required measurements, we column bind the finalTrainFeatureVectors 
   	    columns to the trainDF. At this point, we now have the train subjects,
   	    their performed activities and required measurements related in one single data
   	    set.

   	12. Now, it's time to load the nine inertial signals files from the train data, 
   	    and column bind their data to our trainDF. For each of the nine files, the
   	    process is this:

   	    	1. Create one data frame for each file, these dataframes will be called:

   	    		1. bodyAccTrainX
   	    		2. bodyAccTrainY
   	    		3. bodyAccTrainZ
   	    		4. bodyGyroTrainX
   	    		5. bodyGyroTrainY
   	    		6. bodyGyroTrainZ
   	    		7. totalAccTrainX
   	    		8. totalAccTrainY
   	    		9. totalAccTrainZ

   	    	2. For each of these files, we need to name the 128 values obtained by the
   	    	   sensor signals, for each row in our trainDF data frame. To do this, 
   	    	   we'll apply colnames function to the nine recently created data sets
   	    	   to set the 128 column names, with the help of a created function called
   	    	   createColNamesInertialSignals. This funcion, will get a base name as
   	    	   an argument, and it will simply append an index number at the end of
   	    	   this name, to differentiate the 128 new column names. 

   	    	3. Finally, we can column bind these nine data sets, to our trainDF.

   	13. At this point, in our trainDF, we have the subjectID, activityID, all the
   	    mean and std measurements, and finallly, the 128 sensor signals values for
   	    each row.


## STEP 2: Working with the test data.

	The process to work with the test data, is the same we used for the train
	data, with only one exception, this time, we don't need to do step 7 and 8,
	the ones where we load the features labels data, and cleaning of this data.
	This data is already loaded and cleaned, so we can use to name the columns of 
	our vector of features for the test data, when loaded.

	Aside this, the rest of the steps are exactly the same, with the obvious 
	differences in names for the test dataframes. But, all the column names 
	must remain the same as the ones used for the train data sets, since we'll 
	row bind both, trainDF and testDF, where testDF, is the data frame that we 
	should get at the end of recreating the 13 steps explained above for the
	test files, and as we know, to row bind two dataframes, it's necessary that
	their column names are called the same.


## STEP 3: Final Transformations

	Now that we have have both the train and test data collected in their 
	respective data sets, it's just a matter of joining these data frames and
	applying and couple of last transformations to get the tidy data set 
	required for the course project.

	1. Use the rbind function to combine our trainDF and testDF data sets, in a
	   new data frame called unorderedFinalDF.

	2. Apply the order function on unorderedFinalDF, using the column subjectId,
	   se we can have a new data set ordered by subjectID. We'll store this
	   transformation in a new data frame called FinalDF.

	3. If we notice the column names of this data frame, we'll notice that there
	   are parentheses present, we don't need this, so we must remove them. We
	   can do this by using sapply on the columns names, and applying a 
	   custom function called removeParentheses.

	4. We need to also apply the respective activity labels to the column 
	   activityId, so the viewer of the data set can know what activity did the 
	   subject performed. We can do this by using one more time sapply, on
	   the column activityId, applying anoter custom fuction called labelActivities.

	5. Finally, we just need to rename the column activityId, to just activity, 
	   since we are not storing ids anymore.


## STEP 4: Generating the tidy data set with the summarise information

	Finally, we have the data set with the right column names and record values, 
	needed to create the tidy data required for the course project, it is just
	a matter to apply a few last operations to accomplish this.

	1. Use the group_by function on FinalDF, and group the data frame by subjectID
	   and activity, and assign its result to a new data frame called groupedDF.

	2. Use the summarise_all function on this freshly created data frame, and
	   apply the mean function, and assign its result to a new data frame called
	   avgDF.

  And it's done, after all these operations are executed, we finally have a tidy data
  set, with the mean of each measurement, grouped by activity and subject.
