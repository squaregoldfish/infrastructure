##script to create object "Times" w/ starting times for HF
##output is a matrix with 4 columns:
##-fjul (fractional julian day since 1/1/1960)
##-lat (deg N)
##-lon (deg E)
##-altitude (meters above ground)
##

sourcepath<-"./stiltR/";source(paste(sourcepath,"sourceall.r",sep=""))#provide STILT functions
source(paste("./create_times.r"))

mdy<-month.day.year
getmdy<-function(fjday){#get date and time formatted 
MDY<-mdy(floor(fjday))
return(ISOdate(MDY$year, MDY$month, MDY$day, hour = (fjday-floor(fjday))*24, 
       min = 0, sec = 0.0, tz = "GMT"))
}

######

# get run identifier from environment variable set in start.stilt.sh
#
run_id <- Sys.getenv(c("RUN_ID"), unset = NA)
cat(format(Sys.time(), "%FT%T"),"INFO run id:",run_id,"\n")

path_log<-paste("./",run_id,"/",sep="")                 # path for run-specific log files

path_id<-paste("./Output/",run_id,"/",sep="")             # path of new run-specific directory

#-----------------------------------------------------------------------------------------------------------------
# get station name, latitude, longitude, altitude from environment variable set in start.stilt.sh
#
station <- Sys.getenv(c("STILT_NAME"), unset = NA)
cat(format(Sys.time(), "%FT%T"),"INFO selected station: ",station,"\n")
lat <- as.numeric(Sys.getenv(c("STILT_LAT"), unset = NA))
cat(format(Sys.time(), "%FT%T"),"INFO selected latitude: ",lat,"\n")
lon <- as.numeric(Sys.getenv(c("STILT_LON"), unset = NA))
cat(format(Sys.time(), "%FT%T"),"INFO selected longitude: ",lon,"\n")
agl <- as.numeric(Sys.getenv(c("STILT_ALT"), unset = NA))
cat(format(Sys.time(), "%FT%T"),"INFO selected inlet height: ",agl,"\n")

pathResults<-paste(path_id,"Results/",sep="")             # path to save run-specific parameters and time series files
cat(format(Sys.time(), "%FT%T"),"DEBUG run-specific path for time series files ",pathResults,"\n")
pathResults<-paste(pathResults,station,"/",sep="")
system(paste("mkdir -p ",pathResults,sep=""))

sel_startdate <- Sys.getenv(c("START_DATE"), unset = NA)
sel_enddate <- Sys.getenv(c("END_DATE"), unset = NA)

# default 3-hourly time slots
dh<-3

# compute list of julian days for frequency dh
fjul_all <- create_times(sel_startdate,sel_enddate,dh=dh)

# output list as ascii file (only for prepration, not used in stilt)
ymdh<-format(getmdy(fjul_all),'%Y%m%d%H')
write(ymdh, paste(path_log,"output.txt",sep=""), sep="\n")

# split into separate runs for each year
fjul_start<-fjul_all[1]
fjul_end<-fjul_all[length(fjul_all)]
year_start<-mdy(floor(fjul_start))$year
year_end<-mdy(floor(fjul_end))$year

for (year in year_start:year_end) {
  fjul_1<-max(fjul_start,julian(1,1,year))
  fjul_2<-min(fjul_end,julian(12,31,year)+(1-dh/24))
  fjul<-fjul_all[(fjul_all>=fjul_1) & (fjul_all<=fjul_2)]
  fjul<-unique(fjul)

  outname<-paste(".",station,".",as.character(year),".request",sep="") #name for object with receptor information
  assignr(outname,cbind(fjul,lat,lon,agl),path=pathResults,printTF=T)
  
## define directory names and make directories
  path<-paste(path_id,"RData/",sep="")         # path of directories with RData files for each station 
  path<-paste(path,station,"/",sep="")
  path<-paste(path,as.character(year),"/",sep="")
  system(paste("mkdir -p ",path,sep=""))
  cat(format(Sys.time(), "%FT%T"),"DEBUG run-specific path for partical location files ",path,"\n")
  pathFP<-paste(path_id,"Footprints/",sep="")  # path to save footprints in nc-files
  pathFP<-paste(pathFP,station,"/",sep="")
  pathFP<-paste(pathFP,as.character(year),"/",sep="")
  system(paste("mkdir -p ",pathFP,sep=""))
  cat(format(Sys.time(), "%FT%T"),"DEBUG run-specific path for footprint files ",pathFP,"\n")
  
## split STILT run into parts
  copydirs<-dir("STILT_Exe")
  allowed_parts<-max(as.integer(substring(copydirs,5)))
  cat(format(Sys.time(), "%FT%T"),"DEBUG no of allowed parts:",allowed_parts,"\n")
  stilt_part <- as.numeric(Sys.getenv(c("PARTS2"), unset = NA))
  print(paste("stilt_part ",stilt_part))
  if (is.na(stilt_part)) {
    stilt_part <- length(fjul)
  }
  if ( stilt_part > allowed_parts) {
    stop(cat(format(Sys.time(), "%FT%T"),"INFO need ",stilt_part," Copy directories, have only ",allowed_parts,"\n"))
  }
  cat(format(Sys.time(), "%FT%T"),"INFO run split into",stilt_part,"part(s)\n",sep=" ")
## start STILT run
#  cat(format(Sys.time(), "%FT%T")," DEBUG ","./run.stilt.sh ",station," ",year," ",run_id," ",stilt_part," > ",path_log,"run.stilt.",station,as.character(year),run_id,".log","\n",sep="")      
#  system(paste("./run.stilt.sh ",station," ",year," ",run_id," ",stilt_part," > ",path_log,"run.stilt.",station,as.character(year),run_id,".log",sep=""))      ## start STILT run
} # end for years
      
