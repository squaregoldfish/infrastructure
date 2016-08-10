#Reformat STILT results
#source("/Net/Groups/BSY/people/cgerbig/Rsource/CarboEurope/stiltR.bialystok/lookstilt.r")
#6/12/2016 by UK

station <- Sys.getenv(c("STILT_NAME"), unset = NA)
print(paste("station: ",station,sep=""))
run_id <- Sys.getenv(c("RUN_ID"),unset = NA)

# settings for CarbonPortal
#large EU2 region
lon.res <- 1/8                 #resolution in degrees longitude
lat.res <- 1/12                #resolution in degrees latitude
lon.ll  <- -15                 #lower left corner of grid
lat.ll  <-  33                 #lower left corner of grid
fluxmod <- "VPRM"
landcov <- "SYNMAP.VPRM8"

path<-paste("./Output/RData/",station,"/",sep="")
pathFP<-paste("./Output/Footprints/",station,"/",sep="")
sourcepath<-"./stiltR/";source(paste(sourcepath,"sourceall.r",sep=""))#provide STILT functions
pathResults<-paste("./Output/Results/",run_id,"/",station,"/",sep="")
#pathResults<-paste("./Output/Results/",run_id,"/","XXX","/",sep="")

Timesname<-paste(".",station,".request",sep="")
print(Timesname)
StartInfo <- getr(paste(Timesname, sep=""), pathResults) # object containing fractional julian day, lat, lon, agl for starting position and
time

#merge STILT result objects  ## not used at them moment in CP version 
rnam<-"stiltresult"
tp<-1
dat<-NULL; for(part in 1:tp){dat<-rbind(dat,getr(paste(rnam,part,sep=""),pathFP))} #standard simulation

mdy<-month.day.year

getmdy<-function(fjday){#nice x axis
MDY<-mdy(floor(fjday))
#get date and time formatted; setting sec to 0.1 avoids skipping the time for midnight
return(ISOdate(MDY$year, MDY$month, MDY$day, hour = (fjday-floor(fjday))*24, 
       min = 0, sec = 0.0, tz = "GMT"))
}

#startdate<-format(getmdy(min(StartInfo[,1])),'%Y%m%d')
#enddate<-format(getmdy(max(StartInfo[,1])),'%Y%m%d')
#print(paste(startdate,enddate,sep=" "))

dat2<-subset(dat,(dat[,1] %in% StartInfo[,1]))
dat<-dat2

ymdh<-getmdy(dat2[,1]) 
MDY<-mdy(floor(dat2[,1])) 
year<-MDY$year 
month<-MDY$month 
day<-MDY$day 
hour<-(dat2[,1]-floor(dat2[,1]))*24 

zi<-dat[,"zi"]
dat2<-cbind(year,month,day,hour,dat[,1:4],zi)
isodate<-as.numeric(as.POSIXct(ymdh))
dat2<-cbind(isodate,dat2)
date<-format(ymdh,'%Y/%m/%d#%H:%M')
dat2<-cbind(date,dat2)

#character to real ...
dat<-dat[!is.na(as.numeric(dat[,1])),]
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
#print(ucats)
#print(ufs)

selco2<-pars[(pars[,1]==tracer & !is.na(pars[,2])),]
co2.cat.fuel.all<-rowSums (dat[,paste(selco2[,1],selco2[,2],selco2[,3],sep=".")], na.rm = FALSE)

selco2bio<-pars[(pars[,1]==tracer & substring(pars[,3],1,3)=="bio" & !is.na(pars[,2])),]
selco2gas<-pars[(pars[,1]==tracer & substring(pars[,3],1,3)=="gas" & !is.na(pars[,2])),]
selco2coal<-pars[(pars[,1]==tracer & substring(pars[,3],1,4)=="coal" & !is.na(pars[,2])),]
selco2oil<-pars[(pars[,1]==tracer & substring(pars[,3],1,3)=="oil" & !is.na(pars[,2])),]

co2.cat.fuel.all<-rowSums (dat[,paste(selco2[,1],selco2[,2],selco2[,3],sep=".")], na.rm = FALSE)
co2.cat.fuel.bio<-rowSums (dat[,paste(selco2bio[,1],selco2bio[,2],selco2bio[,3],sep=".")], na.rm = FALSE)
co2.cat.fuel.gas<-rowSums (dat[,paste(selco2gas[,1],selco2gas[,2],selco2gas[,3],sep=".")], na.rm = FALSE)
co2.cat.fuel.coal<-rowSums (dat[,paste(selco2coal[,1],selco2coal[,2],selco2coal[,3],sep=".")], na.rm = FALSE)
co2.cat.fuel.oil<-rowSums (dat[,paste(selco2oil[,1],selco2oil[,2],selco2oil[,3],sep=".")], na.rm = FALSE)

dat<-cbind(dat,co2.cat.fuel.all,co2.cat.fuel.bio,co2.cat.fuel.gas,co2.cat.fuel.coal,co2.cat.fuel.oil)
test.all<-c("co2.cat.fuel.bio","co2.cat.fuel.gas","co2.cat.fuel.coal","co2.cat.fuel.oil")
test.plot<-rowSums (dat[,test.all], na.rm = FALSE)
dat<-cbind(dat,test.plot)

#print(paste("fluxmod ",fluxmod,sep=""))
  if (fluxmod == "GSB") {
      output.veg <- c("frst", "shrb", "crop")#, "wetl")
   }
   if (fluxmod != "GSB"&(landcov == "GLCC"|landcov == "SYNMAP"|landcov == "SYNMAP.VPRM8"))
      output.veg <- c("evergreen", "decid", "mixfrst", "shrb", "savan", "crop", "grass", "peat") #"peat" is replaced by "others" in Jena VPRM preproc.
   if (fluxmod != "GSB"&(landcov == "DVN"))
      output.veg <- c("evergreenA", "evergreenB", "evergreenC", "evergreenD", "decid", "mixfrst", "shrb", "savan", "crop", "grass", "peat")

#calculate CO2 from vegetation
resp.all<-rowSums (dat[,paste("resp",output.veg,sep="")], na.rm = FALSE)
#print(paste("resp.all ",resp.all,sep=""))
gee.all<-rowSums (dat[,paste("gee",output.veg,sep="")], na.rm = FALSE)
infl.all<-rowSums (dat[,paste("infl",output.veg,sep="")], na.rm = FALSE)#+dat[,"inflwater"]
co2.stilt<-resp.all+gee.all+dat[,"co2ini"]+dat[,"co2.cat.fuel.all"]
co2.bio<-resp.all+gee.all
co2.total<-co2.stilt
co2.fuel<-co2.cat.fuel.all
co2.ini<-dat[,"co2ini"]
dat2<-cbind(dat2,co2.total,co2.bio,gee.all,resp.all,co2.fuel,co2.cat.fuel.oil,co2.cat.fuel.coal,co2.cat.fuel.gas,co2.cat.fuel.bio,co2.ini,rn)

# add unit in column name
# components in ppm
#output.nu <- c("co2.total","co2.bio","gee.all","resp.all","co2.fuel","co2.cat.fuel.oil","co2.cat.fuel.coal","co2.cat.fuel.gas","co2.cat.fuel.bio","co2.ini")
#output.unit<-paste(colnames(dat2[,output.nu]),"[ppm]",sep="#")
#colnames(dat2)[colnames(dat2)%in% output.nu] <- output.unit

# components in Bq/m3
#output.nu <- c("rn","rn")
#output.unit<-paste(colnames(dat2[,output.nu]),"[Bq/m2]",sep="#") 
#colnames(dat2)[colnames(dat2)%in% output.nu] <- output.unit

# components in m
#output.nu <- c("zi","zi") 
#output.unit<-paste(colnames(dat2[,output.nu]),"[m]",sep="#")  
#colnames(dat2)[colnames(dat2)%in% output.nu] <- output.unit

print(colnames(dat2))


#write.table(dat2, file=paste(pathResults,"/",station,"_","stiltresult", part, "_isodate.csv",sep=""), na="", row.names=F, quote=F)
write.table(dat2, file=paste(pathResults,"/","stiltresults.csv",sep=""), na="", row.names=F, quote=F)
system(paste("chmod a+rwx ",pathResults,"/","stiltresults.csv",sep=""))
