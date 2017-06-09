##script to create object "Times" w/ starting times for HF
##output is a matrix with 4 columns:
##-fjul (fractional julian day since 1/1/1960)
##-lat (deg N)
##-lon (deg E)
##-altitude (meters above ground)
##

sourcepath<-"./stiltR/";source(paste(sourcepath,"sourceall.r",sep=""))#provide STILT functions

##############

cprun <- F     # T: use only existing particle location files for calculation on icos-cp.eu to prepare files for footprint tool
               # F: allow full STILT run

##############

# get run identifier from environment variable set in stilt.batch.sh
#
run_id <- Sys.getenv(c("RUN_ID"), unset = NA)
cat(format(Sys.time(), "%FT%T"),"INFO run id:",run_id,"\n")

path_log<-paste("./",run_id,"/",sep="")                 # path for run-specific log files

path_id<-paste("./Output/",run_id,"/",sep="")             # path of new run-specific directory

#-----------------------------------------------------------------------------------------------------------------
# get station name, latitude, longitude, altitude from environment variable set in stilt.batch.sh
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

# 3-hourly
dh<-3
dhpd<-24/dh

if ((nchar(sel_startdate) < 10) | (nchar(sel_enddate) < 10)){
  if ((nchar(sel_startdate) < 8) | (nchar(sel_enddate) < 8)){
    cat(format(Sys.time(), "%FT%T"),"ERROR Undefined start or end date: ",sel_startdate," - ",sel_enddate,"\n")
    cat(format(Sys.time(), "%FT%T"),"ERROR stop\n")
    stop
  }else{
    year_start<-as.numeric(substr(sel_startdate,1,4))
    month_start<-as.numeric(substr(sel_startdate,5,6))
    day_start<-as.numeric(substr(sel_startdate,7,8))
    year_end<-as.numeric(substr(sel_enddate,1,4))
    month_end<-as.numeric(substr(sel_enddate,5,6))
    day_end<-as.numeric(substr(sel_enddate,7,8))
    hour_start<-0
    hour_end<-((dhpd-1)*dh)
}}else{
  year_start<-as.numeric(substr(sel_startdate,1,4))
  month_start<-as.numeric(substr(sel_startdate,5,6))
  day_start<-as.numeric(substr(sel_startdate,7,8))
  year_end<-as.numeric(substr(sel_enddate,1,4))
  month_end<-as.numeric(substr(sel_enddate,5,6))
  day_end<-as.numeric(substr(sel_enddate,7,8))
  hour_start<-as.numeric(substr(sel_startdate,9,10))
  hour_end<-as.numeric(substr(sel_enddate,9,10))
}

cat(format(Sys.time(), "%FT%T"),"INFO start_date: ",year_start,month_start,day_start,"\n",sep=" ")
cat(format(Sys.time(), "%FT%T"),"INFO end_date: ",year_end,month_end,day_end,"\n",sep=" ")

cat(format(Sys.time(), "%FT%T"),"INFO frequency: ",dh,"hourly","\n",sep=" ")

fjul_start<-julian(month_start,day_start,year_start)
fjul_end<-julian(month_end,day_end,year_end)
for (year in year_start:year_end) {
  fjul_split1<-julian(1,1,year)
  fjul_split2<-julian(12,31,year)
  fjul_1<-max(fjul_start,fjul_split1)
  fjul_2<-min(fjul_end,fjul_split2)
  fjul<-((fjul_1*dhpd):(fjul_2*dhpd))/dhpd
  fjul<-c(fjul,fjul[length(fjul)]+(1:dhpd-1)/dhpd)  #get full last day
  fjul<-fjul[(fjul>=(fjul_start+(hour_start/24))) & (fjul<=(fjul_end+(hour_end/24)))]
  fjul<-round(fjul,6)
  ident<-pos2id(fjul,lat,lon,agl)
  if(cprun){
    ident_time<-substring(list_rdata,nchar(list_rdata)-33,nchar(list_rdata))
    good<-(ident %in% ident_time)
    fjul<-fjul[good]
  }

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
  #stilt_part <- as.numeric(Sys.getenv(c("PARTS2"), unset = 1))
  stilt_part <- length(fjul)
  if ( stilt_part > allowed_parts) {
    stop(cat(format(Sys.time(), "%FT%T"),"INFO need ",stilt_part," Copy directories, have only ",allowed_parts,"\n"))
  }
  cat(format(Sys.time(), "%FT%T"),"INFO run split into",stilt_part,"part(s)\n",sep=" ")
## start STILT run
  cat(format(Sys.time(), "%FT%T")," DEBUG ","./run.stilt.sh ",station," ",year," ",run_id," ",stilt_part," > ",path_log,"run.stilt.",station,as.character(year),run_id,".log","\n",sep="")      
  system(paste("./run.stilt.sh ",station," ",year," ",run_id," ",stilt_part," > ",path_log,"run.stilt.",station,as.character(year),run_id,".log",sep=""))      ## start STILT run
} # end for years
      
