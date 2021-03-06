######Load content from POSTGRESQL - gpxcontent table#####
#install.packages("RPostgreSQL")
require("RPostgreSQL")

# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = "DjangoDB",
                 host = "localhost", port = 5432,
                 user = "postgres", password = 'Subha8jit')

# check for the gpxcontenttable
dbExistsTable(con, "gpxcontenttable")


# query the data from postgreSQL 
gpxcontent <- dbGetQuery(con, "SELECT * from gpxcontenttable")
###########################################################



#project GPX:

##Loading the raw data from csv file####
#setwd("C:/subhajit/projectX/PyCharm-GPX")
#gpxcontent <- read.csv("gpxcontent.csv")
#head(gpxcontent)
########################################

##Ordering the data as per files and then Time
gpxcontent <- gpxcontent[order(gpxcontent$filename, gpxcontent$time),]
str(gpxcontent)
##

head(gpxcontent$time)
v <- as.POSIXlt(gpxcontent$time[1],"%Y-%m-%d %H:%M:%OS")



##correctly date time formated
gpxcontent$DateTime<- as.POSIXlt(gpxcontent$time,"%Y-%m-%d %H:%M:%OS")

difftime(gpxcontent$DateTime[2],gpxcontent$DateTime[1], units = "secs")


##time difference calculation

TimeDiffCalc<- function(x){
  x <- x[order(x$filename, x$time),]
  
  vect=0
  filenameTemp=x$filename[1]
  for(i in 1:length(x$DateTime))
  {
    if(i==1) {next()}
    else if(filenameTemp==x$filename[i]){
      vect<- c(vect,difftime(x$DateTime[i],x$DateTime[i-1], units = "secs"))
    }
    else{
      vect<- c(vect,0)
      
    }
    filenameTemp=x$filename[i]
  }
  vect
}

gpxcontent$TimeDiff<- TimeDiffCalc(gpxcontent)

##---------------

##distance covered per each node
gpxcontent$DistanceCovered<- gpxcontent$TimeDiff*gpxcontent$speed/3600
##----------------

##Calculate change in elevation:
ElevationChange<- function(x){
  x <- x[order(x$filename, x$time),]
  
  vect=0
  filenameTemp=x$filename[1]
  for(i in 1:length(x$altitude))
  {
    if(i==1) {next()}
    else if(filenameTemp==x$filename[i]){
      vect<- c(vect,(x$altitude[i]-x$altitude[i-1]))
    }
    else{
      vect<- c(vect,0)
    }
    filenameTemp=x$filename[i]
  }
  vect
}

gpxcontent$altitude <- as.numeric(gpxcontent$altitude)
gpxcontent$longitude <- as.numeric(gpxcontent$longitude)
gpxcontent$latitude <- as.numeric(gpxcontent$latitude)
gpxcontent$DeltaElev<- ElevationChange(gpxcontent)
##------------------------------------

##----calculate the distance betw 2 Geoms in R--------
##install.packages("geosphere")
##install.packages("purrr")
get_geo_distance = function(long1, lat1, long2, lat2, units = "miles") {
  loadNamespace("purrr")
  loadNamespace("geosphere")
  longlat1 = purrr::map2(long1, lat1, function(x,y) c(x,y))
  longlat2 = purrr::map2(long2, lat2, function(x,y) c(x,y))
  distance_list = purrr::map2(longlat1, longlat2, function(x,y) geosphere::distHaversine(x, y))
  ##distance_m = list_extract(distance_list, position = 1)
  distance_m = distance_list[1]
  if (units == "km") {
    distance = distance_m[[1]] / 1000.0;
  }
  else if (units == "miles") {
    distance = distance_m[[1]] / 1609.344
  }
  else {
    distance = distance_m[[1]]
    # This will return in meter as same way as distHaversine function. 
  }
  distance
}


DistanceCalc<- function(x){
  x <- x[order(x$filename, x$time),]
  
  vect=0
  filenameTemp=x$filename[1]
  for(i in 1:length(x$DateTime))
  {
    if(i==1) {next()}
    else if(filenameTemp==x$filename[i]){
      vect<- c(vect,get_geo_distance(x$longitude[i],x$latitude[i],x$longitude[i-1], x$latitude[i-1], units = "km"))
    }
    else{
      vect<- c(vect,0)
    }
    filenameTemp=x$filename[i]
  }
  vect
}

gpxcontent$GeoPointsDist<- DistanceCalc(gpxcontent)
##--------------------------------------------------------

##------calculate complexity/angle between 2 paths:

files<- unique(gpxcontent$filename)
length(files)



AngleMessure<- function(x){
  x <- x[order(x$filename, x$time),]
  
  vect=0
  filenameTemp=x$filename[1]
  for(i in 1:length(x$id))
  {
    if(i==1) {next()}
    else if(i==length(x$id)){vect<- c(vect,0)}
    else if(filenameTemp==x$filename[i]){
      vect<- c(vect,(180 - acos(((get_geo_distance(gpxcontent$longitude[i-1],gpxcontent$latitude[i-1],gpxcontent$longitude[i+1],gpxcontent$latitude[i+1])^2
                            -(gpxcontent$GeoPointsDist[i])^2)-(gpxcontent$GeoPointsDist[i+1])^2)
                          /(-2*(gpxcontent$GeoPointsDist[i]*gpxcontent$GeoPointsDist[i+1])))*180/pi))
    }
    else{
      vect<- c(vect,0)
    }
    filenameTemp=x$filename[i]
  }
  vect
}

gpxcontent$Angle<- AngleMessure(gpxcontent)
gpxcontent[is.na(gpxcontent$Angle),]$Angle<- 0

##------------------------------------------------

##Now we have the required fields formed. Lets find out statistics on basis of different files----
unique(gpxcontent$filename)[1]
gpxcontent[gpxcontent$filename==unique(gpxcontent$filename)[1],]

unique(gpxcontent[gpxcontent$filename==unique(gpxcontent$filename)[1],]$filename)

statSet<- data.frame(gpxcontent[gpxcontent$filename==unique(gpxcontent$filename)[1],c(1,3:7,9:14)])
summary(statSet)

statSet<- data.frame(gpxcontent[gpxcontent$filename==unique(gpxcontent$filename)[2],c(1,3:7,9:14)])
summary(statSet)

statSet<- data.frame(gpxcontent[gpxcontent$filename==unique(gpxcontent$filename)[3],c(1,3:7,9:14)])
summary(statSet)

statSet<- data.frame(gpxcontent[gpxcontent$filename==unique(gpxcontent$filename)[4],c(1,3:7,9:14)])
summary(statSet)
##

# check for the summarytable
require("RPostgreSQL")
dbExistsTable(con, "summarytable")


summaryList<- list()
## forms the summary table
for(i in 1:length(unique(gpxcontent$filename))){
  statSet<- data.frame(gpxcontent[gpxcontent$filename==unique(gpxcontent$filename)[i],c(1,3:7,9:14)])
  
  dff <- data.frame(unclass(summary(statSet)), check.names = FALSE, stringsAsFactors = FALSE)
  
  dff$filename <- unique(gpxcontent$filename)[i]
  
  for(j in 1:length(colnames(dff))){
    colnames(dff)[j]<- trimws(colnames((dff)[j]),"b")
  }
  
  colnames(dff)[1]<- "id_gist"
  
  summaryList[[length(summaryList)+1]] <- list(dff)
  
  dbWriteTable(con, "summarytable", 
               value = dff, row.names = FALSE, append=TRUE)
}



#statSet<- data.frame(gpxcontent[gpxcontent$filename==unique(gpxcontent$filename)[1],c(1,3:7,9:14)])
#?trimws
###########################

##write output to csv
#write.csv(gpxcontent,"C:/subhajit/projectX/PyCharm-GPX/GPX_output.csv")
##

#write.csv(gpxcontent,"C:/subhajit/projectX/PyCharm-GPX/gpxcontent_output.csv")
#write.csv(summaryList,"C:/subhajit/projectX/PyCharm-GPX/summaryList_output.csv")
#saveRDS(gpxcontent, "C:/subhajit/projectX/PyCharm-GPX/gpxcontent.rds")
#saveRDS(summaryList, "C:/subhajit/projectX/PyCharm-GPX/summaryList.rds")

#saveRDS(full.ds, "F:/MSc/Dissertation/SolarFlareForecasting/full.ds.rds")

###################31st August: dataset prepared and Kmean applied####################
dataSet2Analysis<- c()

library(lubridate)
populate_dataset2Analysis<- function (fname){
  j<- 0
  
  for(i in 1:length(summaryList)){
    if(summaryList[[i]][[1]][["filename"]][1]==fname)
    {j=i
    break}
  }
  
  v<- ymd_hms(trimws(strsplit(summaryList[[j]][[1]][["time"]][1]," :")[[1]][2],which='b'),tz=Sys.timezone())
  v1<- ymd_hms(trimws(strsplit(summaryList[[j]][[1]][["time"]][6]," :")[[1]][2],which='b'),tz=Sys.timezone())
  
  dataR<- c(fname,
            #altitude
            as.numeric(strsplit(summaryList[[j]][[1]][["altitude"]][6],":")[[1]][2])
              - as.numeric(strsplit(summaryList[[1]][[1]][["altitude"]][1],":")[[1]][2]),
            #time
            difftime(v1,v, units = "secs"),
            #speed
            as.numeric(strsplit(summaryList[[j]][[1]][["speed"]][3],":")[[1]][2]),
            #timediff
            as.numeric(strsplit(summaryList[[j]][[1]][["TimeDiff"]][3],":")[[1]][2]),
            #DeltaElev
            as.numeric(strsplit(summaryList[[j]][[1]][["DeltaElev"]][6],":")[[1]][2])
              - as.numeric(strsplit(summaryList[[1]][[1]][["DeltaElev"]][1],":")[[1]][2]),
            #GeoPointDistance
            sum(gpxcontent[gpxcontent$filename==fname,]$GeoPointsDist),
            #Angle
            as.numeric(strsplit(summaryList[[j]][[1]][["Angle"]][3],":")[[1]][2])
  )
  dataR
}

for(i in 1:length(unique(gpxcontent$filename))){
  dataSet2Analysis<- rbind(dataSet2Analysis,populate_dataset2Analysis(unique(gpxcontent$filename)[i]))
}

#dim(dataSet2Analysis)
#View(dataSet2Analysis)
colnames(dataSet2Analysis) <- c("filename",
                                "altitude",
                                "time",
                                "speed",
                                "timeDiff",
                                "DeltaElev",
                                "totaldist",
                                "Angle")

#typeof(dataSet2Analysis)
dataSet2Analysis <- as.data.frame(dataSet2Analysis)
#typeof(dataSet2Analysis)
#dataSet2Analysis$altitude<- as.numeric(dataSet2Analysis$altitude)
#dataSet2Analysis$time<- as.numeric(dataSet2Analysis$time)
#dataSet2Analysis$speed<- as.numeric(dataSet2Analysis$speed)
#dataSet2Analysis$timeDiff<- as.numeric(dataSet2Analysis$timeDiff)
#dataSet2Analysis$DeltaElev<- as.numeric(dataSet2Analysis$DeltaElev)
#dataSet2Analysis$totaldist<- as.numeric(dataSet2Analysis$totaldist)
#dataSet2Analysis$Angle<- as.numeric(dataSet2Analysis$Angle)
rownames(dataSet2Analysis) <- dataSet2Analysis$filename

#str(dataSet2Analysis)

clusterset<- dataSet2Analysis[,-1]
km <- kmeans(clusterset, 4,nstart=10)
clusk <- km$cluster
o <- order(clusk)
stars(clusterset[o,],nrow=3, col.stars=clusk[o]+1, col.segments = c(2,3,4,5))
dev.copy(jpeg,filename="C:\\subhajit\\projectX\\smartblog\\smartblogproject\\Plots\\ClusterPlot.jpg")
dev.off ()
#?dev.print
?order
?stars
#######################################End:#############################################

dbWriteTable(con, "dataSet2Analysis", 
             value = dataSet2Analysis, row.names = FALSE,overwrite=TRUE)



clusterInfo<- c()
non<- as.data.frame(names(clusk))
non2<- as.data.frame(clusk)
non2['activity_19578949_complex_looped.gpx',]
rownames(non2)<-c()
colnames(non2)<- c()

rownames(non)<-c()
colnames(non)<- c()

clusterInfo<- cbind(non,non2)

colnames(clusterInfo)<- c("filename","GroupNumber")
dim(clusterInfo)
typeof(clusterInfo)

dbWriteTable(con, "clusterInfo", 
             value = clusterInfo, row.names = FALSE,overwrite=TRUE)


####################################
#install.packages("dendextend")
d<- dist(clusterset[,7],"euclidean")
h<- hclust(d,"single")
d1 <- as.dendrogram(h)
library(dendextend)
d2=color_branches(d1,k=4, col=c(2,5,3,4)) # auto-coloring 4 clusters of branches.
plot(d2)



d<- dist(dataSet2Analysis[,8],"euclidean")
h<- hclust(d,"average")
d1 <- as.dendrogram(h)
d2=color_branches(d1,k=4,col=c(2,5,3,4)) # auto-coloring 4 clusters of branches.
plot(d2)
dev.copy(jpeg,filename="C:\\subhajit\\projectX\\smartblog\\smartblogproject\\Plots\\DendoPlot.jpg")
dev.off ()
