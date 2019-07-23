---
title: "CodeBook"
author: "Oscar Gabauquer"
date: "22 de julio de 2019"
---

## Getting and Cleaning Data Course Project

This project submission consists of a single script file called run_analysis.R.

In this file, resides all the necessary code to read the different data files, create their respective data sets, merge these data sets and apply all the necessary transformations, in order to get a tidy data set, as it is required by the declared instructions for this course project.

To run the script, it is recommended to have all the data files in the same folder that the script is, as well as the activity_labels.txt file and the features.txt file. Doing this, will make getting the tidy data set really easy, since it would be necessary to set the working directory only once, to the folder where the run_analysis.R is stored.

After having all the train and test files, activity_labels.txt and features.txt file, in the same folder where the script is, then the run_analysis.R can be run line by line, and at the end of the script, the tidy data will be created.
