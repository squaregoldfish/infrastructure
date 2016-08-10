##script to create a list of all stations form which RData files are available
##output is a text file with 4 columns: 
##-station id 
##-lat (deg N)
##-lon (deg E)
##-altitude (meters above ground)
##

sourcepath<-"./stiltR/";source(paste(sourcepath,"sourceall.r",sep=""))#provide STILT functions

#------------------------------------------------------------------------------------------------------------------
# function id2zpos based on id2pos but w/o time
id2zpos<-function(id,sep="x"){
sep="x"
cpos<-regexpr(sep,id) #position of first sep
lat<-as.numeric(substring(id,1,cpos-2));
if(substring(id,cpos-1,cpos-1)=="S")lat<-(-lat)
id<-substring(id,cpos+1);cpos<-regexpr(sep,id)
lon<-as.numeric(substring(id,1,cpos-2));
if(substring(id,cpos-1,cpos-1)=="W")lon<-(-lon)
id<-substring(id,cpos+1)
if(regexpr("[a-z]",id)-1>0)id<-substring(id,1,regexpr("[a-z]",id)-1) #remove any trailing non-numeric letters
alt<-as.numeric(id)
pos<-c(lat,lon,alt)
names(pos)<-c("lat","lon","alt")
return(pos)
}

#-----------------------------------------------------------------------------------------------------------------
# list all available stations (on ICOS data server)
#
path<-"./Output/RData/"              # path of directories with RData files for each station (no other subdirectories or files in this location!!)
                                     # directory name = station id

station<-dir(path)
station<-station[nchar(station)==3]
print(paste("station available:",station,sep=" "))

lat<-c()
lon<-c()
agl<-c()

for (st in station) {
  list_rdata<-dir(paste(path,st,sep="/"),all.files=T)
  list_rdata<-list_rdata[nchar(list_rdata)==40]
  id<-unique(substring(list_rdata,nchar(list_rdata)-19,nchar(list_rdata)))
  print(paste("station:",st,"latxlonxalt:",id,sep=" "))
  lat<-c(lat,unname(id2zpos(id)["lat"]))
  lon<-c(lon,unname(id2zpos(id)["lon"]))
  agl<-c(agl,unname(id2zpos(id)["alt"]))
}

ttt<-as.data.frame(cbind(station,lat,lon,agl))
print(ttt)
write.table(ttt,file="allstations.txt",quote=FALSE,row.names=FALSE)

