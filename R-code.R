#project GPX:

##Loading the raw data
setwd("C:/subhajit/projectX/PyCharm-GPX")
gpxcontent <- read.csv("gpxcontent.csv")
head(gpxcontent)
##

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


##write output to csv
write.csv(gpxcontent,"C:/subhajit/projectX/PyCharm-GPX/GPX_output.csv")
##



















## Rough work############
str(gpxcontent)
unique(gpxcontent$filename)
head(gpxcontent$time)
gpxcontent$speed

dim(gpxcontent)[1]
typeof(gpxcontent)
gpxcontent[gpxcontent$filename=='activity_19578949_complex_looped.gpx',]

derivedColumns <- function(){
  x <- vector()
  for(i in dim(gpxcontent[gpxcontent$filename=='activity_19578949_complex_looped.gpx',])[1]){
    x[i] <- gpxcontent[gpxcontent$filename=='activity_19578949_complex_looped.gpx','id'][i]
  }
  return x
}


# creating an ordered data.frame
#df <- data.frame(category, randtime)
gpxcontent <- gpxcontent[order(gpxcontent$filename, gpxcontent$time),]

# calculating the timedifference
# option 1:
gpxcontent$Tdiff <- unlist(tapply(gpxcontent$time, INDEX = gpxcontent$filename,
                          FUN = function(x) c(0, `units<-`(diff(x), "secs"))))

gpxcontent$Tdiff <- unlist(tapply(gpxcontent$time, INDEX = gpxcontent$filename,
                                  FUN = function(x) c(0, `units<-`(diff(x), "secs"))))
##=======================
?tapply
as.difftime(c("0:3:20", "11:23:15"))
z <- as.difftime(c("11:23:12", "11:23:15"), units = "secs")
z
# option 2:
gpxcontent$tdiff <- unlist(tapply(gpxcontent$time, INDEX = gpxcontent$filename,
                          FUN = function(x) c(0, diff(as.double(x)))))


library(data.table)
# creating an ordered/keyed data.table
dt <- data.table(gpxcontent$filename, time, key = c("filename", "time"))

# calculating the timedifference
# option 1:
dt[, tdiff := difftime(randtime, shift(randtime, fill=randtime[1L]), units="secs"), by=category]
# option 2:
dt[, tdiff := c(0, `units<-`(diff(randtime), "secs")), by = category]
# option 3:
dt[ , test := c(0, diff(as.numeric(randtime))), category]





gpxcontent[gpxcontent$filename=='activity_19578949_complex_looped.gpx','Time']

difftime(gpxcontent[gpxcontent$filename=='activity_19578949_complex_looped.gpx','Time'],gpxcontent[gpxcontent$filename=='activity_19578949_complex_looped.gpx','Time'], units = "secs")


gpxcontent[gpxcontent$filename=='activity_19578949_complex_looped.gpx','id'][1]
derivedColumns()

length(gpxcontent$speed)
?which

tms <- c("2:06:00", "3:34:30", "4:12:59", "08:09:10",
         "09:10:11", "10:11:12", "11:12:13")
tms <- c(gpxcontent$time)
gpxcontent$time[1].split
ta <- as.difftime(tms)
?split
split(gpxcontent$time[1]," ")[1]

str_split(gpxcontent$time[1],'\t')[1]
?str_split



dtime <- strptime(gpxcontent$time[2], "%YYYY-%mm-%ddT%HH:%MM:%SSZ")
format(dtime, "%H:%M:%S")

gpxcontent$time <- data.frame(lapply(gpxcontent$time, as.character), stringsAsFactors=FALSE)

?lapply
gpxcontent$time <- lapply(gpxcontent$time, toString)

install.packages("stringr")
?strptime
library("stringr")
str_split(gpxcontent$time," ")[[1]][2]
x <- lapply(gpxcontent$time, str_split(gpxcontent$time, " "))


##//not worked yet
timecalc <- function(x){
  as.POSIXlt(x,"%Y-%m-%d %H:%M:%OS")
}

timecalc(gpxcontent$time[1])


gpxcontent$DateTime <- tapply(gpxcontent$time,INDEX = gpxcontent$time, FUN = timecalc)
warnings()
?tapply

TimeDiffCalc<- function(){
  f<- 0
  vrr<- c(0)
  for(i in gpxcontent$DateTime){
    vrr<- c(vrr,i)
    vrr
  }
}

TimeDiffCalc()
##//
