#***************************************************************************************************
# Function that creates a list of starting times
#***************************************************************************************************

create_times <- function(sel_startdate,sel_enddate,dh=3) {

##-fjul (fractional julian day since 1/1/1960)

sourcepath<-"./stiltR/";source(paste(sourcepath,"sourceall.r",sep=""))#provide STILT functions

# default 3-hourly (dh=3)
dhpd<-24/dh

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
}
if ((nchar(sel_startdate) < 10) | (nchar(sel_enddate) < 10)){
  hour_start<-0
  hour_end<-((dhpd-1)*dh)
}else{
  hour_start<-as.numeric(substr(sel_startdate,9,10))
  hour_end<-as.numeric(substr(sel_enddate,9,10))
}

cat(format(Sys.time(), "%FT%T"),"INFO start_date: ",year_start,month_start,day_start,hour_start,"\n",sep=" ")
cat(format(Sys.time(), "%FT%T"),"INFO end_date: ",year_end,month_end,day_end,hour_end,"\n",sep=" ")
cat(format(Sys.time(), "%FT%T"),"INFO frequency: ",dh,"hourly","\n",sep=" ")

fjul_start<-julian(month_start,day_start,year_start)
fjul_end<-julian(month_end,day_end,year_end)

fjul<-((fjul_start*dhpd):(fjul_end*dhpd))/dhpd
fjul<-c(fjul,fjul[length(fjul)]+(1:dhpd-1)/dhpd)  #get full last day
fjul<-fjul[(fjul>=(fjul_start+(hour_start/24))) & (fjul<=(fjul_end+(hour_end/24)))]
fjul<-round(fjul,6)
fjul<-unique(fjul)

return(fjul)
}