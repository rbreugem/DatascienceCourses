library(data.table)
setwd("D:/rbreugem/Documents/Courses/DS04 Data cleaning/Project/UCI HAR Dataset")

#replace variables codes with names
colnames(X_test)<-as.character(read.table(file="./features.txt")$V2)
colnames(X_train)<-as.character(read.table(file="./features.txt")$V2)

#add subjects-data to test-data and provide useful variable name
X_test<-cbind(X_test,read.table(file="./test/subject_test.txt"))
colnames(X_test)[562]<-"subject_id"

#add activities-data to test-data
X_test<-cbind(X_test,read.table(file="./test/y_test.txt"))
colnames(X_test)[563]<-"activity_id"

#add subjects to train-data
X_train<-cbind(X_train,read.table(file="./train/subject_train.txt"))
colnames(X_train)[562]<-"subject_id__"

#add activities to train-data
X_train<-cbind(X_train,read.table(file="./train/y_train.txt"))
colnames(X_train)[563]<-"activity_id"

#combine test and train datasets
data<-rbind(X_train,X_test)

#read activity data labels and merge with test/train dataset
activity_labels<-read.table(file="./activity_labels.txt")
data<-merge(data,activity_labels,by.x="activity_id",by.y="V1")
colnames(data)[564]<-"activity"

##Extract the columns with standard deviation and mean
a<-names(data) #unique vector with all column names
colsStd<-grep("std",a,value=T) #vector with values where variable names contains std
colsMean<-grep("mean",a,value=T) #vector with values where variable names contains mean
cols<-c(colsStd,colsMean) #joint vector of std and mean labels
cols<-c(cols,"subject_id","activity") #joint vector of std/mean and activity labels

#Create tidy dataset by using only that part of the dataset with right labels 
#and then summarize the data by taking the mean of the data for each combination
#of subject-ID/activity combination

data2<-aggregate(data[,cols][1:79], by=list(data$subject_id,data$activity), FUN=mean)

#adjust names
colnames(data2)[1]<-"Subject_id"
colnames(data2)[2]<-"Activity"
colnames(data2)[3:81]<-paste0("Mean_",colnames(data2)[3:81])

#write to file
write.table(data2,row.name=F,file = "courseproject.txt")
