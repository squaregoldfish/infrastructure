##script to create object "Times" w/ starting times for HF
##output is a matrix with 4 columns: 
##-fjul (fractional julian day since 1/1/1960)
##-lat (deg N)
##-lon (deg E)
##-altitude (meters above ground)
##

sourcepath<-"./stiltR/";source(paste(sourcepath,"sourceall.r",sep=""))#provide STILT functions

##############

path<-"./Output/RData/"              # path of directories with RData files for each station (no other subdirectories in this location)
                                     # directory name = station id

pathFP<-"./Output/Footprints/"              # path tho save footprints in nc-files

pathResults<-"./Output/Results/"      # path to save file with list of available stations
                                     # this path contains all run-specific parameters

# get run identifier from environment variable set in stilt.batch.sh
#
run_id <- Sys.getenv(c("RUN_ID"), unset = NA)
print(paste("run id:",run_id,sep=" "))
pathResults<-paste(pathResults,run_id,"/",sep="")

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
  stations_avail<-stations_avail[nchar(stations_avail)==3]
  print(paste("stations available:",stations_avail,sep=" "))

#-----------------------------------------------------------------------------------------------------------------
  station <- selected_station$station
  lat <- selected_station$lat
  lon <- selected_station$lon
  agl <- selected_station$agl

  if(station %in% stations_avail){
    list_rdata<-dir(paste(path,station,sep="/"),all.files=T)
    list_rdata<-list_rdata[nchar(list_rdata)==40]
    #print((substring(list_rdata,nchar(list_rdata)-20,nchar(list_rdata))))
    ident_avail<-unique(substring(list_rdata,nchar(list_rdata)-19,nchar(list_rdata)))
    #print(ident_avail)
    ident<-pos2id(0,lat,lon,agl)
    ident<-substring(ident,nchar(ident)-19,nchar(ident))
    #print(ident)
    if(ident %in% ident_avail){

      outname<-paste(".",station,".request",sep="") #name for object with receptor information

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
        print(paste("start_date: ",year_start,month_start,day_start,sep=" "))
        print(paste("end_date: ",year_end,month_end,day_end,sep=" "))
      }
      # 3-hourly
      dh<-3
      dhpd<-24/dh
      fjul<-((julian(month_start,day_start,year_start)*dhpd):(julian(month_end,day_end,year_end)*dhpd))/dhpd
      fjul<-c(fjul,fjul[length(fjul)]+(1:dhpd-1)/dhpd)  #get full last day
      fjul<-round(fjul,6)

      ident<-pos2id(fjul,lat,lon,agl)
      ident_time<-substring(list_rdata,nchar(list_rdata)-33,nchar(list_rdata))
      #print(length(ident))
      good<-(ident %in% ident_time)
      print(length(ident))
      fjul<-fjul[good]
      
      pathFP<-paste(pathFP,station,"/",sep="")
      system(paste("mkdir -p ",pathFP,sep=""))

      pathResults<-paste(pathResults,station,"/",sep="")
#      system(paste("rm -rf ", pathResults,"XXX",sep=""))
#      pathResults<-paste(pathResults,"XXX","/",sep="")
      system(paste("mkdir -p ",pathResults,sep=""))

      print(paste(outname,pathResults))

#-----------------------------------------
      assignr(outname,cbind(fjul,lat,lon,agl),path=pathResults,printTF=T)
      system(paste("./run.stilt.sh ",station," ",run_id," > run.stilt.",station,run_id,".log",sep=""))      ## start STILT run
    }else{
      print(paste("prepare_input.r: lon, lat, agl ",ident," do not agree with available identification ",ident_avail," for ",station,sep=""))
      #stop('prepare_input.r: lon, lat, agl "ident" do not agree with available identification "ident_avail" for "station" -> stop')
    } # end if(ident %in% ident_avail)
  }else{
    print(paste("prepare_input.r: no footprints for station ",station," available",sep=""))
    #stop('prepare_input.r: no footprints for station "station" available -> stop')
  } # end if(station %in% stations_avail)
}else{
  print(paste("prepare_input.r: station ",selected," not available",sep=""))
  #stop('prepare_input.r: station "selected" not available -> stop')
} # end if(selected %in% allstations$station)
