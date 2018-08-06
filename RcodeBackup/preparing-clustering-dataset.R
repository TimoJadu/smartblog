gpxcontent[gpxcontent$filename=='activity_1580981561.gpx',]
typeof(gpxcontent)
typeof(statSet)

head(summaryList[[1]][[1]])

#altitude
as.numeric(strsplit(summaryList[[1]][[1]][["altitude"]][6],":")[[1]][2])- as.numeric(strsplit(summaryList[[1]][[1]][["altitude"]][1],":")[[1]][2])

#time
v<- as.POSIXlt(strsplit(summaryList[[1]][[1]][["time"]][6]," :")[[1]][2],"%Y-%m-%d %H:%M:%OS")
v1<- as.POSIXlt(strsplit(summaryList[[1]][[1]][["time"]][1],":")[[1]][2],"%Y-%m-%d %H:%M:%OS")

difftime(v,v1, units = "secs")

#speed
as.numeric(strsplit(summaryList[[1]][[1]][["speed"]][3],":")[[1]][2])
#timediff
as.numeric(strsplit(summaryList[[1]][[1]][["TimeDiff"]][3],":")[[1]][2])
#distancecovered
as.numeric(strsplit(summaryList[[1]][[1]][["speed"]][3],":")[[1]][2])

#GeoPointDistance
sum(gpxcontent[gpxcontent$filename=='activity_1580981561.gpx',]$GeoPointsDist)

#Angle
as.numeric(strsplit(summaryList[[1]][[1]][["Angle"]][3],":")[[1]][2])



length(summaryList)
filename<- 'activity_1580981561.gpx'
j<- 0
for(i in 1:length(summaryList)){
  if(summaryList[[i]][[1]][["filename"]][1]==filename)
  {j=i
  break}
}
j

length(summaryList)
summaryList
typeof(gpxcontent)
unique(gpxcontent$filename)[2]


##################################################################
dataSet2Analysis<- data.frame(matrix(ncol = 8, nrow = 0))
columnnames<- c("filename","altitude","time","speed","timediff","distancecovered","GeoPointDistance","Angle")
colnames(dataSet2Analysis)<- columnnames



populate_dataset2Analysis<- function (fname){
  j<- 0
  for(i in 1:length(summaryList)){
    if(summaryList[[i]][[1]][["filename"]][1]==fname)
    {j=i
    break}
  }
  j
  print(j)
  print(fname)
  #nrow(dataSet2Analysis)
  #fname<- 'activity_1666612514.gpx'
  fname<- 'activity_2842747188.gpx'
  fname<- 'activity_2743179162.gpx'
  v<- as.POSIXlt(strsplit(summaryList[[j]][[1]][["time"]][6]," :")[[1]][2],"%Y-%m-%d %H:%M:%OS")
  v1<- as.POSIXlt(strsplit(summaryList[[j]][[1]][["time"]][1],":")[[1]][2],"%Y-%m-%d %H:%M:%OS")
  
  dataSet2Analysis[nrow(dataSet2Analysis)+1,]<- c(fname,
  #altitude
  as.numeric(strsplit(summaryList[[j]][[1]][["altitude"]][6],":")[[1]][2])- as.numeric(strsplit(summaryList[[1]][[1]][["altitude"]][1],":")[[1]][2]),
  #time
  difftime(v,v1, units = "secs"),
  #speed
  as.numeric(strsplit(summaryList[[j]][[1]][["speed"]][3],":")[[1]][2]),
  #timediff
  as.numeric(strsplit(summaryList[[j]][[1]][["TimeDiff"]][3],":")[[1]][2]),
  #distancecovered
  as.numeric(strsplit(summaryList[[j]][[1]][["speed"]][3],":")[[1]][2]),
  #GeoPointDistance
  sum(gpxcontent[gpxcontent$filename==fname,]$GeoPointsDist),
  #Angle
  as.numeric(strsplit(summaryList[[j]][[1]][["Angle"]][3],":")[[1]][2])
  )
  
}

for(i in 1:length(unique(gpxcontent$filename)))
{
  populate_dataset2Analysis(unique(gpxcontent$filename)[2])
}

##############################################################################
dataSet2Analysis$filename

dataSet2Analysis$time<- as.numeric(dataSet2Analysis$time)/3600
dataSet2Analysis$altitude<- as.numeric(dataSet2Analysis$altitude)
dataSet2Analysis$speed<- as.numeric(dataSet2Analysis$speed)
dataSet2Analysis$timediff<- as.numeric(dataSet2Analysis$timediff)
dataSet2Analysis$distancecovered<- as.numeric(dataSet2Analysis$distancecovered)
dataSet2Analysis$GeoPointDistance<- as.numeric(dataSet2Analysis$GeoPointDistance)
dataSet2Analysis$Angle<- as.numeric(dataSet2Analysis$Angle)
########################################################

dataSet2Analysis.feat<- dataSet2Analysis[,4:8]
pairs(dataSet2Analysis.feat,col=dataSet2Analysis$filename)

dataSet2Analysis<- t(dataSet2Analysis)

km <- kmeans(dataSet2Analysis, 4,nstart=10)
clusk <- km$cluster
o <- order(clusk)
stars(educ[o,],nrow=3, col.stars=clusk[o]+1)

typeof(educ)
educ <- read.table("C:\\Maynooth University\\ST464\\educ.txt",row.names=1,header=TRUE)
educ<- educ[,-19]
educ<- t(educ)
km <- kmeans(educ, 4,nstart=10)
clusk <- km$cluster
o <- order(clusk)
stars(educ[o,],nrow=3, col.stars=clusk[o]+1)





typeof(unique(gpxcontent$filename))
noquote(unique(gpxcontent$filename)[1])
gsub("\"","\'", unique(gpxcontent$filename)[1])

unique(gpxcontent$filename)[1][2]

dataSet2Analysis
warning()

typeof(summaryList[[1]][[1]][["altitude"]][1])

strsplit(summaryList[[1]][[1]][["altitude"]][1],":")[[1]][2]
typeof(strsplit(summaryList[[1]][[1]][["altitude"]][1],":")[[1]][2])
as.numeric(strsplit(summaryList[[1]][[1]][["altitude"]][1],":")[[1]][2])

v<- strsplit(summaryList[[1]][[1]][["altitude"]][1],":")[[1]][2]

gpxMLData<- table()


