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

path<-paste(path_id,"RData/",sep="")                      # path of directories with RData files for each station (no other subdirectories in this location)
                                                          # directory name = station id
cat(format(Sys.time(), "%FT%T"),"DEBUG run-specific path for partical location files ",path,"\n")
# make new run-specific path 
system(paste("mkdir -p ",path, sep=""))

pathFP<-paste(path_id,"Footprints/",sep="")               # path to save footprints in nc-files
print(paste(pathFP,sep=""))
cat(format(Sys.time(), "%FT%T"),"DEBUG run-specific path for footprint files ",pathFP,"\n")

pathResults<-paste(path_id,"Results/",sep="")             # path to save run-specific parameters and time series files
print(paste(pathResults,sep=""))
cat(format(Sys.time(), "%FT%T"),"DEBUG run-specific path for time series files ",pathResults,"\n")


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

path<-paste(path,station,"/",sep="")
system(paste("mkdir -p ",path,sep=""))
### link existing particle location files for all sites (must be read-only!!!)
cat(format(Sys.time(), "%FT%T"),"INFO ln -s ./Input/RData/",station,"/.RData* ",path,".","\n")
if (file.exists(paste("./Input/RData/",station,sep=""))) {system(paste("ln -s ./Input/RData/",station,"/.RData* ",path,".",sep=""))}
cat(format(Sys.time(), "%FT%T"),"DEBUG prepare_input.r: no particle location files for station ",station," available  -> full STILT run required !!!","\n")

pathFP<-paste(pathFP,station,"/",sep="")
system(paste("mkdir -p ",pathFP,sep=""))
### link existing footprint files for all sites (must be read-only!!!)
if (file.exists(paste("./Input/Footprints/",station,sep=""))) {
  cat(format(Sys.time(), "%FT%T"),"DEBUG ln -s ./Input/Footprints/",station,"/foot* ",pathFP,".","\n")
  system(paste("ln -s ./Input/Footprints/",station,"/foot* ",pathFP,".",sep=""))
  cat(format(Sys.time(), "%FT%T"),"DEBUG ln -s ./Input/Footprints/",station,"/.RDatafoot* ",pathFP,".","\n")
  system(paste("ln -s ./Input/Footprints/",station,"/.RDatafoot* ",pathFP,".",sep=""))
}

pathResults<-paste(pathResults,station,"/",sep="")
system(paste("mkdir -p ",pathResults,sep=""))

sel_startdate <- Sys.getenv(c("START_DATE"), unset = NA)
sel_enddate <- Sys.getenv(c("END_DATE"), unset = NA)
if ((nchar(sel_startdate) < 8) | (nchar(sel_enddate) < 8)){
  cat(format(Sys.time(), "%FT%T"),"ERROR Undefined start or end date: ",sel_startdate," - ",sel_enddate,"\n")
  cat(format(Sys.time(), "%FT%T"),"ERROR stop\n"
  stop
  #year_start<-year_end<-2011
  #month_start<-7
  #day_start<-1
  #month_end<-7
  #day_end<-2
}else{
  year_start<-as.numeric(substr(sel_startdate,1,4))
  month_start<-as.numeric(substr(sel_startdate,5,6))
  day_start<-as.numeric(substr(sel_startdate,7,8))
  year_end<-as.numeric(substr(sel_enddate,1,4))
  month_end<-as.numeric(substr(sel_enddate,5,6))
  day_end<-as.numeric(substr(sel_enddate,7,8))
}
cat(format(Sys.time(), "%FT%T"),"INFO start_date: ",year_start,month_start,day_start,"\n",sep=" ")
cat(format(Sys.time(), "%FT%T"),"INFO end_date: ",year_end,month_end,day_end,"\n",sep=" ")

# 3-hourly
dh<-3
dhpd<-24/dh
cat(format(Sys.time(), "%FT%T"),"INFO frequency: ",dh,"hourly","\n",sep=" ")

fjul_start<-julian(month_start,day_start,year_start)
fjul_end<-julian(month_end,day_end,year_end)
#stilt_part<-0
#stilt_totpart<-year_end-year_start+1
for (year in year_start:year_end) {
#  stilt_part<-stilt_part+1
  fjul_split1<-julian(1,1,year)
  fjul_split2<-julian(12,31,year)
  fjul_1<-max(fjul_start,fjul_split1)
  fjul_2<-min(fjul_end,fjul_split2)
  fjul<-((fjul_1*dhpd):(fjul_2*dhpd))/dhpd
  fjul<-c(fjul,fjul[length(fjul)]+(1:dhpd-1)/dhpd)  #get full last day
  fjul<-round(fjul,6)
  #print(fjul)
  ident<-pos2id(fjul,lat,lon,agl)
  if(cprun){
    ident_time<-substring(list_rdata,nchar(list_rdata)-33,nchar(list_rdata))
    good<-(ident %in% ident_time)
    fjul<-fjul[good]
  }
  fjul<-unique(fjul)

  outname<-paste(".",station,".",as.character(year),".request",sep="") #name for object with receptor information

#-----------------------------------------
  assignr(outname,cbind(fjul,lat,lon,agl),path=pathResults,printTF=T)
  stilt_part <- Sys.getenv(c("PARTS2"), unset = 1)
  cat(format(Sys.time(), "%FT%T"),"INFO run split into",stilt_part,"part(s)\n",sep=" ")
  cat(format(Sys.time(), "%FT%T"),"DEBUG","./run.stilt.sh ",station," ",year," ",run_id," ",stilt_part," > ",path_log,"run.stilt.",station,as.character(year),run_id,".log\n",sep=""))      ## start STILT run
  system(paste("./run.stilt.sh ",station," ",year," ",run_id," ",stilt_part," > ",path_log,"run.stilt.",station,as.character(year),run_id,".log",sep=""))      ## start STILT run
} # end for years
      
