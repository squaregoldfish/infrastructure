#Reformat STILT results
#source("/Net/Groups/BSY/people/cgerbig/Rsource/CarboEurope/stiltR.bialystok/lookstilt.r")
#6/12/2016 by UK

station <- Sys.getenv(c("STILT_NAME"), unset = NA)
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: selected station: ",station,"\n")
run_id <- Sys.getenv(c("RUN_ID"),unset = NA)
stilt_year <- Sys.getenv(c("STILT_YEAR"),unset = NA)

tp <- Sys.getenv(c("STILT_TOTPART"),unset = NA)  # number of parts 

# settings for CarbonPortal
#large EU2 region
lon.res <- 1/8                 #resolution in degrees longitude
lat.res <- 1/12                #resolution in degrees latitude
lon.ll  <- -15                 #lower left corner of grid
lat.ll  <-  33                 #lower left corner of grid
fluxmod <- "VPRM"
landcov <- "SYNMAP.VPRM8"

path<-paste("./Output/",run_id,"/RData/",station,"/",sep="")
pathFP<-paste("./Output/",run_id,"/Footprints/",station,"/",sep="")
sourcepath<-"./stiltR/";source(paste(sourcepath,"sourceall.r",sep=""))#provide STILT functions
pathResults<-paste("./Output/",run_id,"/Results/",station,"/",sep="")

Timesname<-paste(".",station,".",stilt_year,".request",sep="")
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: Timesname ",Timesname,"\n")
StartInfo <- getr(paste(Timesname, sep=""), pathResults) # object containing fractional julian day, lat, lon, agl for starting position and time
identname <- pos2id(StartInfo[1,1],StartInfo[1,2],StartInfo[1,3],StartInfo[1,4])
stiltresultname <- paste("stiltresult",stilt_year,substr(identname,14,34),sep="")
cat(format(Sys.time(), "%FT%T"),"INFO new result filename: ",stiltresultname,"\n")

#merge STILT result objects  ## not used at them moment in CP version 
rnam<-stiltresultname
dat<-NULL
for(part in 1:tp){
dat<-rbind(dat,getr(paste(rnam,"_",part,sep=""),pathFP))} #standard simulation

cat(format(Sys.time(), "%FT%T"),"DEBUG reform: part ",part,"\n")
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: dim(dat) ",dim(dat),"\n")
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: dimnames(dat) ",paste(dimnames(dat),sep=" "),"\n")
mdy<-month.day.year

getmdy<-function(fjday){#nice x axis
MDY<-mdy(floor(fjday))
#get date and time formatted; setting sec to 0.1 avoids skipping the time for midnight
return(ISOdate(MDY$year, MDY$month, MDY$day, hour = round((fjday-floor(fjday))*24), 
       min = 0, sec = 0.0, tz = "GMT"))
}

startdate<-format(getmdy(min(StartInfo[,1])),'%Y%m%d')
enddate<-format(getmdy(max(StartInfo[,1])),'%Y%m%d')
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: startdate: ",startdate,"  enddate: ",enddate,"\n")

list_FP<-dir(pathFP,all.files=T)
list_FP<-list_FP[(nchar(list_FP)==44) & (substring(list_FP,2,10)=="RDatafoot")]
ident_time<-substring(list_FP,nchar(list_FP)-33,nchar(list_FP))
ident_test<-pos2id(dat[,1],dat[,2],dat[,3],dat[,4])
good<-(ident_test %in% ident_time)
dat<-dat[good,,drop=F]
dat<-unique(dat)

ymdh<-getmdy(dat[,1])
MDY<-mdy(floor(dat[,1]))
year<-MDY$year
month<-MDY$month
day<-MDY$day
hour<-round((dat[,1]-floor(dat[,1]))*24)

zi<-dat[,"zi"]
dat2<-dat[,1:4,drop=F]
isodate<-as.numeric(as.POSIXct(ymdh))
date<-format(ymdh,'%Y/%m/%d#%H:%M')
dat2<-cbind(date,isodate,year,month,day,hour,dat2,zi)

#character to real ...
nms<-dimnames(dat)
dat<-matrix(as.numeric(dat),ncol=length(dimnames(dat)[[2]]),dimnames=nms)

tracer<-"rn"
rn.stilt<-dat[,"rnini"]+dat[,"rn"]
rn<-rn.stilt

tracer<-"co2"

pars<-matrix(NA, ncol=3, nrow=lengths(dimnames(dat)[2]))
colnames(pars)<-c("trac", "cats", "fuels")
for(i in 1:lengths(dimnames(dat)[2])){
  fls<-strsplit(dimnames(dat)[[2]][i], split=".", fixed=T) #fls[[1]][3] 
  pars[i,]<-fls[[1]][1:3]
}
ucats<-unique(pars[,"cats"])  #length: 22
ufs<-unique(pars[,"fuels"])   #length: 13
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: ucats ",ucats,"\n")
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: ufs ",ufs,"\n")

selco2<-pars[(pars[,1]==tracer & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]
co2.cat.fuel.all<-rowSums (dat[,paste(selco2[,1],selco2[,2],selco2[,3],sep="."),drop=F], na.rm = FALSE)

selco2bio<-pars[(pars[,1]==tracer & substring(pars[,3],1,3)=="bio" & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]
selco2gas<-pars[(pars[,1]==tracer & substring(pars[,3],1,3)=="gas" & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]
selco2coal<-pars[(pars[,1]==tracer & substring(pars[,3],1,4)=="coal" & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]
selco2oil<-pars[(pars[,1]==tracer & substring(pars[,3],1,3)=="oil" & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]

co2.cat.fuel.all<-rowSums (dat[,paste(selco2[,1],selco2[,2],selco2[,3],sep="."),drop=F], na.rm = FALSE)
co2.cat.fuel.bio<-rowSums (dat[,paste(selco2bio[,1],selco2bio[,2],selco2bio[,3],sep="."),drop=F], na.rm = FALSE)
co2.cat.fuel.gas<-rowSums (dat[,paste(selco2gas[,1],selco2gas[,2],selco2gas[,3],sep="."),drop=F], na.rm = FALSE)
co2.cat.fuel.coal<-rowSums (dat[,paste(selco2coal[,1],selco2coal[,2],selco2coal[,3],sep="."),drop=F], na.rm = FALSE)
co2.cat.fuel.oil<-rowSums (dat[,paste(selco2oil[,1],selco2oil[,2],selco2oil[,3],sep="."),drop=F], na.rm = FALSE)

selco2energy<-pars[(pars[,1]==tracer & (pars[,2] %in% c("1a1a","1a1bcr")) & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]
selco2transport<-pars[(pars[,1]==tracer & (pars[,2] %in% c("1a3b","1a3ce","1a3a+1c1","1a3d+1c2")) & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]
selco2industry<-pars[(pars[,1]==tracer & (pars[,2] %in% c("1a2+6cd","2a","2befg+3","2c")) & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]
selco2others<-pars[(pars[,1]==tracer & (pars[,2] %in% c("1b2abc","7a","1a4","4f")) & substring(pars[,3],nchar(pars[,3])-2,nchar(pars[,3]))!="ffm" & !is.na(pars[,2])),]

co2.energy<-rowSums (dat[,paste(selco2energy[,1],selco2energy[,2],selco2energy[,3],sep="."),drop=F], na.rm = FALSE)
co2.industry<-rowSums (dat[,paste(selco2industry[,1],selco2industry[,2],selco2industry[,3],sep="."),drop=F], na.rm = FALSE)
co2.transport<-rowSums (dat[,paste(selco2transport[,1],selco2transport[,2],selco2transport[,3],sep="."),drop=F], na.rm = FALSE)
co2.others<-rowSums (dat[,paste(selco2others[,1],selco2others[,2],selco2others[,3],sep="."),drop=F], na.rm = FALSE)

dat<-cbind(dat,co2.cat.fuel.all,co2.cat.fuel.bio,co2.cat.fuel.gas,co2.cat.fuel.coal,co2.cat.fuel.oil,co2.energy,co2.transport,co2.industry,co2.others)
test.all<-c("co2.cat.fuel.bio","co2.cat.fuel.gas","co2.cat.fuel.coal","co2.cat.fuel.oil")
test.plot<-rowSums (dat[,test.all,drop=F], na.rm = FALSE)
dat<-cbind(dat,test.plot)

output.veg <- c("evergreen", "decid", "mixfrst", "shrb", "savan", "crop", "grass", "others") #"peat" is replaced by "others" in Jena VPRM preproc.
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: output.veg",output.veg,"\n")
cat(format(Sys.time(), "%FT%T"),"DEBUG reform: fluxmod ",fluxmod,"\n")
  if (fluxmod == "GSB") {
      output.veg <- c("frst", "shrb", "crop")#, "wetl")
   }
   if (fluxmod != "GSB"&(landcov == "GLCC"|landcov == "SYNMAP"|landcov == "SYNMAP.VPRM8"))
      output.veg <- c("evergreen", "decid", "mixfrst", "shrb", "savan", "crop", "grass", "peat") #"peat" is replaced by "others" in Jena VPRM preproc.
   if (fluxmod != "GSB"&(landcov == "DVN"))
      output.veg <- c("evergreenA", "evergreenB", "evergreenC", "evergreenD", "decid", "mixfrst", "shrb", "savan", "crop", "grass", "peat")
output.veg <- c("evergreen", "decid", "mixfrst", "shrb", "savan", "crop", "grass", "others") #"peat" is replaced by "others" in Jena VPRM preproc.

#calculate CO2 from vegetation
resp.all<-rowSums (dat[,paste("resp",output.veg,sep=""),drop=F], na.rm = FALSE)
gee.all<-rowSums (dat[,paste("gee",output.veg,sep=""),drop=F], na.rm = FALSE)
infl.all<-rowSums (dat[,paste("infl",output.veg,sep=""),drop=F], na.rm = FALSE)#+dat[,"inflwater"]
co2.stilt<-resp.all+gee.all+dat[,"co2ini"]+dat[,"co2.cat.fuel.all"]
co2.bio<-resp.all+gee.all
co2.bio.gee<-gee.all
co2.bio.resp<-resp.all

co2.total<-co2.stilt

co2.fuel<-co2.cat.fuel.all
co2.fuel.coal<-co2.cat.fuel.coal
co2.fuel.gas<-co2.cat.fuel.gas
co2.fuel.oil<-co2.cat.fuel.oil
co2.fuel.bio<-co2.cat.fuel.bio
co2.background<-dat[,"co2ini"]

co2.ini<-dat[,"co2ini"]

dat2<-cbind(dat2,co2.stilt,co2.bio,co2.bio.gee,co2.bio.resp,co2.fuel,co2.fuel.oil,co2.fuel.coal,co2.fuel.gas,co2.fuel.bio,co2.energy,co2.transport,co2.industry,co2.others,co2.background,rn)

# write results incl. wind information - if exists
if ("ubar" %in% colnames(dat)) {
  cat(format(Sys.time(), "%FT%T"),"DEBUG reform: wind info included in stiltresults..._wind.csv","\n")
  wind.u<-dat[,"ubar"]
  wind.v<-dat[,"vbar"]
  wind.w<-dat[,"wbar"]
  wind.dir<-dat[,"wind.dir"]
  dat3<-cbind(dat2,wind.u,wind.v,wind.w,wind.dir)
  cat(format(Sys.time(), "%FT%T"),"DEBUG reform wind: colnames(dat3) ",colnames(dat3),"\n")
  write.table(dat3, file=paste(pathResults,"/",stiltresultname,".csv",sep=""), na="", row.names=F, quote=F)
} else {
  cat(format(Sys.time(), "%FT%T"),"DEBUG reform: colnames(dat2) ",colnames(dat2),"\n")
  write.table(dat2, file=paste(pathResults,"/",stiltresultname,".csv",sep=""), na="", row.names=F, quote=F)
}

