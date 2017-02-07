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
print(paste("run id:",run_id,sep=" "))

path_log<-paste("./",run_id,"/",sep="")                 # path for run-specific log files

path_id<-paste("./Output/",run_id,"/",sep="")             # path of new run-specific directory

path<-paste(path_id,"RData/",sep="")                      # path of directories with RData files for each station (no other subdirectories in this location)
                                                          # directory name = station id
print(paste(path,sep=""))
# make new run-specific path 
system(paste("mkdir -p ",path, sep=""))

pathFP<-paste(path_id,"Footprints/",sep="")               # path to save footprints in nc-files
print(paste(pathFP,sep=""))

pathResults<-paste(path_id,"Results/",sep="")             # path to save run-specific parameters and time series files
print(paste(pathResults,sep=""))


#------------------------------------------------------------------------------------------------------------------
# search file system for available stations and extract latitude and longitude from filename (write_sellist.r)
# results are written to allstations.txt
#system(paste("./liststations.sh",station,sep=" "))
# read allstations data.frame from file
# lines starting with # are not processed
#
allstations<-read.table("allstations.txt",header=TRUE)
#
#-----------------------------------------------------------------------------------------------------------------
# get station name from environment variable set in stilt.batch.sh
#
selected <- Sys.getenv(c("STILT_NAME"), unset = NA)
print(paste("selected station:",selected,sep=" "))

if(selected %in% allstations$station){
  selected_station<-allstations[ allstations$station == selected, ]
  print(selected_station)

#-----------------------------------------------------------------------------------------------------------------
# list all stations available at this moment
#
  stations_avail<-dir(path)
  #stations_avail<-stations_avail[nchar(stations_avail)==3]
  #print(paste("stations available:",stations_avail,sep=" "))

#-----------------------------------------------------------------------------------------------------------------
  station <- selected_station$station
  lat <- selected_station$lat
  lon <- selected_station$lon
  agl <- selected_station$agl
}else{
  #print(paste("prepare_input.r: station ",selected," not available",sep=""))
  # get lat, lon, agl from environment
  stop(paste("prepare_input.r: station ",selected," not available -> stop"))
} # end if(selected %in% allstations$station)

if(station %in% stations_avail){
  list_rdata<-dir(paste(path,station,sep="/"),all.files=T)
  list_rdata<-list_rdata[nchar(list_rdata)==40]
  #print((substring(list_rdata,nchar(list_rdata)-20,nchar(list_rdata))))
  ident_avail<-unique(substring(list_rdata,nchar(list_rdata)-19,nchar(list_rdata)))
  #print(ident_avail)
  ident<-pos2id(0,lat,lon,agl)
  ident<-substring(ident,nchar(ident)-19,nchar(ident))
  #print(ident)
  if(!(ident %in% ident_avail)){
    if(cprun){
      #print(paste("prepare_input.r: lon, lat, agl ",ident," do not agree with available identification ",ident_avail," for ",station,sep=""))
      stop(paste("prepare_input.r: lon, lat, agl ",ident," do not agree with available identification ",ident_avail," for ",station," -> stop"))
    }
  }
}else{
  if(cprun){
    #print(paste("prepare_input.r: no particle location files for station ",station," available",sep=""))
    stop(paste("prepare_input.r: no particle location files for station ",station," available -> stop"))
  }
  path<-paste(path,station,"/",sep="")
  system(paste("mkdir -p ",path,sep=""))
  ### link existing particle location files for all sites (must be read-only!!!)
  print(paste("ln -s ./Input/RData/",station,"/.RData* ",path,".",sep=""))
  if (file.exists(paste("./Input/RData/",station,sep=""))) {system(paste("ln -s ./Input/RData/",station,"/.RData* ",path,".",sep=""))}
  print(paste("prepare_input.r: no particle location files for station ",station," available  -> full STILT run required !!!",sep=""))
} # end if(station %in% stations_avail)

pathFP<-paste(pathFP,station,"/",sep="")
system(paste("mkdir -p ",pathFP,sep=""))
### link existing footprint files for all sites (must be read-only!!!)
if (file.exists(paste("./Input/Footprints/",station,sep=""))) {
  print(paste("ln -s ./Input/Footprints/",station,"/foot* ",pathFP,".",sep=""))
  system(paste("ln -s ./Input/Footprints/",station,"/foot* ",pathFP,".",sep=""))
  print(paste("ln -s ./Input/Footprints/",station,"/.RDatafoot* ",pathFP,".",sep=""))
  system(paste("ln -s ./Input/Footprints/",station,"/.RDatafoot* ",pathFP,".",sep=""))
}

pathResults<-paste(pathResults,station,"/",sep="")
system(paste("mkdir -p ",pathResults,sep=""))

sel_startdate <- Sys.getenv(c("START_DATE"), unset = NA)
sel_enddate <- Sys.getenv(c("END_DATE"), unset = NA)
if ((nchar(sel_startdate) < 8) | (nchar(sel_enddate) < 8)){
  print(paste("Undefined start or end date:",sel_startdate,sel_enddate,sep=" "))
  year_start<-year_end<-2011
  month_start<-7
  day_start<-1
  month_end<-7
  day_end<-2
}else{
  year_start<-as.numeric(substr(sel_startdate,1,4))
  month_start<-as.numeric(substr(sel_startdate,5,6))
  day_start<-as.numeric(substr(sel_startdate,7,8))
  year_end<-as.numeric(substr(sel_enddate,1,4))
  month_end<-as.numeric(substr(sel_enddate,5,6))
  day_end<-as.numeric(substr(sel_enddate,7,8))
}
print(paste("start_date: ",year_start,month_start,day_start,sep=" "))
print(paste("end_date: ",year_end,month_end,day_end,sep=" "))

# 3-hourly
dh<-3
dhpd<-24/dh

fjul_start<-julian(month_start,day_start,year_start)
fjul_end<-julian(month_end,day_end,year_end)
stilt_part<-0
stilt_totpart<-year_end-year_start+1
for (year in year_start:year_end) {
  stilt_part<-stilt_part+1
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
  #outname<-paste(".",station,".",as.character(stilt_part),".request",sep="") #name for object with receptor information

#-----------------------------------------
  assignr(outname,cbind(fjul,lat,lon,agl),path=pathResults,printTF=T)
  stilt_part <- Sys.getenv(c("PART2"), unset = 1)
  print(paste("run split into",stilt_part,"part(s)",sep=" "))
  system(paste("./run.stilt.sh ",station," ",year," ",run_id," ",stilt_part," > ",path_log,"run.stilt.",station,as.character(year),run_id,".log",sep=""))      ## start STILT run
  #system(paste("./run.stilt.sh ",station," ",year," ",run_id," > ",path_log,"run.stilt.",station,as.character(year),run_id,".log",sep=""))      ## start STILT run
  #system(paste("echo exit status $?",sep=""))
  #print(paste("run.stilt.sh started",sep=""))
  #system(paste("./run.stilt.sh ",station," ",stilt_part," ",stilt_totpart," ",run_id," > run.stilt.",station,run_id,as.character(year),".log",sep=""))      ## start STILT run
} # end for years
      