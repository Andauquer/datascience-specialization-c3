library(dplyr)

################################################################################# TRAIN DATA

trainSubjects <- read.table("subject_train.txt")

head(trainSubjects)

trainSubjects <- rename(trainSubjects, subjectId = V1)

head(trainSubjects)

############################################################################################

trainActivityIds <- read.table("y_train.txt")

head(trainActivityIds)

trainActivityIds <- rename(trainActivityIds, activityId = V1)

head(trainActivityIds)

############################################################################################

trainDF <- cbind(trainSubjects,trainActivityIds)

str(trainDF)

############################################################################################

trainFeatureVectors <- read.table("X_train.txt")

str(trainFeatureVectors)

############################################################################################

featuresLabels <- read.table("features.txt")

str(as.character(featuresLabels$V2))

head(featuresLabels)

featuresLabels$V2 <- sapply(as.character(featuresLabels$V2), removeDashes)

############################################################################################

colnames(trainFeatureVectors) <- featuresLabels$V2

str(trainFeatureVectors)

trainFeatureVectors <- trainFeatureVectors[,!duplicated(featuresLabels$V2)]

finalTrainFeatureVectors <- select(trainFeatureVectors, matches('Mean\\(\\)|Std\\(\\)'))

str(finalTrainFeatureVectors)

############################################################################################

trainDF <- cbind(trainDF,finalTrainFeatureVectors)

############################################################################################

bodyAccTrainX  <- read.table("body_acc_x_train.txt")

colnames(bodyAccTrainX) <- createColNamesInertialSignals( "bodyAccX" )

trainDF <- cbind(trainDF,bodyAccTrainX)


bodyAccTrainY <- read.table("body_acc_y_train.txt")

colnames(bodyAccTrainY) <- createColNamesInertialSignals( "bodyAccY" )

trainDF <- cbind(trainDF,bodyAccTrainY)


bodyAccTrainZ <- read.table("body_acc_z_train.txt")

colnames(bodyAccTrainZ) <- createColNamesInertialSignals( "bodyAccZ" )

trainDF <- cbind(trainDF,bodyAccTrainZ)


bodyGyroTrainX <- read.table("body_gyro_x_train.txt")

colnames(bodyGyroTrainX) <- createColNamesInertialSignals( "bodyGyroX" )

trainDF <- cbind(trainDF,bodyGyroTrainX)


bodyGyroTrainY <- read.table("body_gyro_y_train.txt")

colnames(bodyGyroTrainY) <- createColNamesInertialSignals( "bodyGyroY" )

trainDF <- cbind(trainDF,bodyGyroTrainY)


bodyGyroTrainZ <- read.table("body_gyro_z_train.txt")

colnames(bodyGyroTrainZ) <- createColNamesInertialSignals( "bodyGyroZ" )

trainDF <- cbind(trainDF,bodyGyroTrainZ)


totalAccTrainX <- read.table("total_acc_x_train.txt")

colnames(totalAccTrainX) <- createColNamesInertialSignals( "totalAccX" )

trainDF <- cbind(trainDF,totalAccTrainX)


totalAccTrainY <- read.table("total_acc_y_train.txt")

colnames(totalAccTrainY) <- createColNamesInertialSignals( "totalAccY" )

trainDF <- cbind(trainDF,totalAccTrainY)


totalAccTrainZ <- read.table("total_acc_z_train.txt")

colnames(totalAccTrainZ) <- createColNamesInertialSignals( "totalAccZ" )

trainDF <- cbind(trainDF,totalAccTrainZ)






################################################################################## TEST DATA

testSubjects <- read.table("subject_test.txt")

head(testSubjects)

testSubjects <- rename(testSubjects, subjectId = V1)

head(testSubjects)

############################################################################################

testActivityIds <- read.table("y_test.txt")

head(testActivityIds)

testActivityIds <- rename(testActivityIds, activityId = V1)

head(testActivityIds)

############################################################################################

testDF <- cbind(testSubjects,testActivityIds)

str(testDF)

############################################################################################

testFeatureVectors <- read.table("X_test.txt")

str(testFeatureVectors)

############################################################################################

colnames(testFeatureVectors) <- featuresLabels$V2

str(testFeatureVectors)

testFeatureVectors <- testFeatureVectors[,!duplicated(featuresLabels$V2)]

finalTestFeatureVectors <- select(testFeatureVectors, matches('Mean\\(\\)|Std\\(\\)'))

str(finalTestFeatureVectors)

############################################################################################

testDF <- cbind(testDF,finalTestFeatureVectors)

############################################################################################

bodyAccTestX  <- read.table("body_acc_x_test.txt")

colnames(bodyAccTestX) <- createColNamesInertialSignals( "bodyAccX" )

testDF <- cbind(testDF,bodyAccTestX)


bodyAccTestY <- read.table("body_acc_y_test.txt")

colnames(bodyAccTestY) <- createColNamesInertialSignals( "bodyAccY" )

testDF <- cbind(testDF,bodyAccTestY)


bodyAccTestZ <- read.table("body_acc_z_test.txt")

colnames(bodyAccTestZ) <- createColNamesInertialSignals( "bodyAccZ" )

testDF <- cbind(testDF,bodyAccTestZ)


bodyGyroTestX <- read.table("body_gyro_x_test.txt")

colnames(bodyGyroTestX) <- createColNamesInertialSignals( "bodyGyroX" )

testDF <- cbind(testDF,bodyGyroTestX)


bodyGyroTestY <- read.table("body_gyro_y_test.txt")

colnames(bodyGyroTestY) <- createColNamesInertialSignals( "bodyGyroY" )

testDF <- cbind(testDF,bodyGyroTestY)


bodyGyroTestZ <- read.table("body_gyro_z_test.txt")

colnames(bodyGyroTestZ) <- createColNamesInertialSignals( "bodyGyroZ" )

testDF <- cbind(testDF,bodyGyroTestZ)


totalAccTestX <- read.table("total_acc_x_test.txt")

colnames(totalAccTestX) <- createColNamesInertialSignals( "totalAccX" )

testDF <- cbind(testDF,totalAccTestX)


totalAccTestY <- read.table("total_acc_y_test.txt")

colnames(totalAccTestY) <- createColNamesInertialSignals( "totalAccY" )

testDF <- cbind(testDF,totalAccTestY)


totalAccTestZ <- read.table("total_acc_z_test.txt")

colnames(totalAccTestZ) <- createColNamesInertialSignals( "totalAccZ" )

testDF <- cbind(testDF,totalAccTestZ)






###################################################################### Final Transformations

unorderedFinalDF <- rbind(trainDF, testDF)

FinalDF <- unorderedFinalDF[order(unorderedFinalDF$subjectId),]

colnames(FinalDF) <- sapply(colnames(FinalDF), removeParentheses)

FinalDF$activityId <- sapply(FinalDF$activityId, labelActivities)

FinalDF <- rename(FinalDF, activity = activityId)






############################################################################ Average Dataset

groupedDF <- group_by(FinalDF, subjectId, activity)

avgDF <- summarise_all(groupedDF, mean)

write.table(avgDF, "average_values.txt", row.names = FALSE)






################################################################################# Functions


removeDashes <- function ( value ) 
{
  str1 <- character()
  str2 <- character()
  str3 <- character()
  
  chars <- unlist(strsplit(value,""))
  
  if ( length(chars[chars == "-"]) == 2 )
  {
    str1 <- strsplit(value, "-")[[1]][1]
    str2 <- strsplit(value, "-")[[1]][2]
    str3 <- strsplit(value, "-")[[1]][3]
    
    str2 <- paste0(toupper(substr(str2, 1, 1)), substr(str2, 2, nchar(str2)))
    
    finalString <- paste0(str1,str2,str3)
    
    finalString <- sub(",", "", finalString)
    
    return(finalString)
  }
  else if ( length(chars[chars == "-"]) == 1 )
  {
    str1 <- strsplit(value, "-")[[1]][1]
    str2 <- strsplit(value, "-")[[1]][2]
    
    str2 <- paste0(toupper(substr(str2, 1, 1)), substr(str2, 2, nchar(str2)))
    
    finalString <- paste0(str1,str2)
    
    finalString <- sub(",", "", finalString)
    
    return(finalString)
  }
  else
  {
    finalString <- sub(",", "", value)
    
    return(finalString)
  }
}



removeParentheses <- function ( value )
{
  finalString <- sub("\\(", "", value)
  finalString <- sub("\\)", "", finalString)
  return(finalString)
}



labelActivities <- function ( value )
{
  if ( value == 1 )
  {
    return("walking")
  }
  else if ( value == 2 )
  {
    return("walking_upstairs")
  }
  else if ( value == 3 )
  {
    return("walking_downstairs")
  }
  else if ( value == 4 )
  {
    return("sitting")
  }
  else if ( value == 5 )
  {
    return("standing")
  }
  else
  {
    return("laying")
  }
}



createColNamesInertialSignals <- function ( value )
{
  newColNames <- as.character()
  
  for( i in 1:128)
  {
    newColNames <- c(newColNames, paste0(value, i))
  }
  
  return(newColNames)
}








