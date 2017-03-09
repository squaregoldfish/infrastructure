#***************************************************************************************************
# Function that loops over all starting times
#***************************************************************************************************

Trajecmod <- function(partarg=NULL, totpartarg=NULL, nodeoffset=NULL) {

#---------------------------------------------------------------------------------------------------
# Calls 'Trajec' for each starting time
# arguments assigned from call to setStiltparam.r
#
# $Id: Trajecmod.r,v 1.22 2010/02/23 19:24:19 trn Exp $
#---------------------------------------------------------------------------------------------------


# need to assign parameters; also save parameter setting in archive file with date in name
source("setStiltparam.r")
savename <- gsub(" ", ".", date())
savename <- substring(savename,4)
runs.done.dir <- NULL
#if (file.exists('./Runs.done')) runs.done.dir <- './Runs.done/'
#if (is.null(runs.done.dir) && file.exists(paste(sourcepath,'Runs.done',sep='')))
#  runs.done.dir <- paste(sourcepath,'/Runs.done/',sep='')
#if (is.null(runs.done.dir) &&
#    substring(path, nchar(path)-nchar("Runs.done"), nchar(path)) == "Runs.done/")
#  runs.done.dir <- sourcepath
#if (!is.null(runs.done.dir)) {
#   file.copy("setStiltparam.r",
#             paste(runs.done.dir, "setStiltparam", savename, ".r", sep=""),
#             overwrite=T)
#   cat("Saving copy of setStiltparam.r in ",
#       paste(runs.done.dir, "setStiltparam", savename, ".r", sep=""),
#       "\n",sep="")
#} else {
#   cat("No Runs.done directory; parameter information not saved\n")
#}

# ICOS-CP specific settings
cat(format(Sys.time(), "%FT%T"),"DEBUG run_id ",run_id,"\n")
cat(format(Sys.time(), "%FT%T"),"DEBUG path ",path,"\n")

runs.done.dir <- NULL
if (file.exists(paste('./',run_id,'/Runs.done',sep=''))) runs.done.dir <- paste('./',run_id,'/Runs.done/',sep='')
#if (is.null(runs.done.dir) && file.exists(paste(sourcepath,'Runs.done',sep='')))
#  runs.done.dir <- paste(sourcepath,'/Runs.done/',sep='')
#if (is.null(runs.done.dir) &&
#    substring(path, nchar(path)-nchar("Runs.done"), nchar(path)) == "Runs.done/")
#  runs.done.dir <- sourcepath
if (!is.null(runs.done.dir)) {
   file.copy("setStiltparam.r",
             paste(runs.done.dir, "setStiltparam", savename, ".r", sep=""),
             overwrite=T)
   cat(format(Sys.time(), "%FT%T"),"DEBUG Saving copy of setStiltparam.r in ",
       paste(runs.done.dir, "setStiltparam", savename, ".r", sep=""),
       "\n")
} else {
   cat(format(Sys.time(), "%FT%T"),"DEBUG No Runs.done directory; parameter information not saved\n")
}



totpart <- 1
if (!is.null(totpartarg)) {
    cat(format(Sys.time(), "%FT%T"),'DEBUG resetting totpart=', totpart, ' to totpartarg=', totpartarg, '\n')
  totpart <- totpartarg
}
part <- 1
if (!is.null(partarg)) {
    cat(format(Sys.time(), "%FT%T"),'DEBUG Using totpart=', totpart, ' resetting part=', part, ' to partarg=', partarg, '\n')
  part <- partarg
}
if (!is.null(nodeoffset)) {
  nummodel <- part+nodeoffset
    cat(format(Sys.time(), "%FT%T"),'DEBUG Using nodeoffset= ', nodeoffset, ' ,results in nummmodel= ', nummodel, '\n')
} else {
  nummodel <- part
}



# get Starting info
if (!existsr(Timesname, pathResults)) stop(paste("cannot find object ", Timesname, " in directory ", pathResults, sep=""))
StartInfo <- getr(paste(Timesname, sep=""), pathResults) # object containing fractional julian day, lat, lon, agl for starting position and time

  cat(format(Sys.time(), "%FT%T"),"DEBUG StartInfo ",StartInfo[1,]," - ",StartInfo[dim(StartInfo)[1],],"\n")
# SELECTION OF A FEW Receptors for testing!
if (Times.startrow > 0) StartInfo <- StartInfo[Times.startrow:Times.endrow,, drop=FALSE] # can be just one (Times.startrow=Times.endrow)

# divide job into "totpart" parts to speed up
if (dim(StartInfo)[1] < totpart) {
  cat ('Warning: resetting totpart=', totpart, ' to dim(StartInfo)[1]=', dim(StartInfo)[1], '\n', sep='')
  totpart <- dim(StartInfo)[1]
}
if (part > totpart) {
  stop.message <- paste('ERROR Specified part=', part, ' > totpart=', totpart, ', stopping\n')
  cat(format(Sys.time(), "%FT%T"),stop.message)
  stop(stop.message)
}
start.rows <- c(1 + (0:(totpart-1))*floor(dim(StartInfo)[1]/totpart), dim(StartInfo)[1]+1)
StartInfo <- StartInfo[start.rows[part]:(start.rows[part+1]-1),, drop=FALSE]
dimnames(StartInfo)[[2]] <- toupper(dimnames(StartInfo)[[2]])

if (biomassburnTF) {
   biomassburnoutmat <- matrix(nrow=dim(StartInfo)[[1]], ncol=2)
   dimnames(biomassburnoutmat) <- list(NULL, c("ident", "CO"))
}

if (file.access(pathResults,0)!=0) {
     system(paste("mkdir ",pathResults,sep=""))
}

###### added for CP setup UK ########
l.remove.Resultfile <- FALSE
if (exists('remove.Resultfile')) l.remove.Resultfile <- remove.Resultfile

# OVERWRITE WARNING
if(existsr(paste("stiltresult_",stilt_year,"_",part,sep=""),path=pathFP)) {
   if(l.remove.Resultfile){
      cat(format(Sys.time(), "%FT%T"),"DEBUG You are attempting to overwrite an existing stiltresult object\n")
      unix(paste("rm -f ",paste(pathFP,".Rdata","stiltresult_",stilt_year,"_",part,sep=""),sep=""))
      unix(paste("rm -f ",paste(pathFP,"stiltresult_",stilt_year,"_",part,".csv",sep=""),sep=""))
      cat(format(Sys.time(), "%FT%T"),"DEBUG Notice: New stiltresult object will be written \n")
   }else{ 
      cat(format(Sys.time(), "%FT%T"),"DEBUG You are not computing new timeseries you are using an existing stiltresult object\n")
      cat(format(Sys.time(), "%FT%T"),"DEBUG Notice: If you have changed parameters and Trajecmod fails, first try to move or remove the existing stiltresult object\n")
      fluxTF<-F    # no new time series are computed
   }
}else{
   cat(format(Sys.time(), "%FT%T"),"DEBUG Notice: New stiltresult object will be written \n")
}
###### end: added for CP setup UK ########

nrows <- length(StartInfo[,1]) # 1 row for each trajectory
rownum <- 1
firsttraj <- T
firstflux <- T
l.remove.Trajfile <- FALSE
if (exists('remove.Trajfile')) l.remove.Trajfile <- remove.Trajfile
for (j in 1:nrows) {

  ###############################################
  ##### run trajectories and save output ########
  ###############################################
  lat <- StartInfo[j, "LAT"]; lon <- StartInfo[j, "LON"]; agl <- StartInfo[j, "AGL"]
  identname <- pos2id(StartInfo[j,1], lat, lon, agl)
  cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): ", identname, " running at ", date(), "\n")
  dat <- month.day.year(floor(StartInfo[j,1])) # from julian to mmddyy
  yr4 <- dat$year # 4 digit year
  yr <- yr4%%100 # 2 digit year (or 1 digit...)
  mon <- dat$month
  day <- dat$day
  hr <- round((StartInfo[j,1]-floor(StartInfo[j,1]))*24)
  l.ziscale <- NULL
  if (exists('ziscale')) l.ziscale <- ziscale
  l.zsg.name <- NULL
  if (exists('zsg.name')) l.zsg.name <- zsg.name
  l.create.X0 <- FALSE
  if (exists('create.X0')) l.create.X0 <- create.X0
  l.use.multi <- TRUE
  if (exists('use.multi')) l.use.multi <- use.multi
  l.hymodelc.exe <- NULL
  if (exists('hymodelc.exe')) l.hymodelc.exe <- hymodelc.exe
  if (l.use.multi) {
    l.setup.list <- list()
    if (exists('setup.list')) l.setup.list <- setup.list
    info <- Trajecmulti(yr=yr, mon=mon, day=day, hr=hr, lat=lat, lon=lon, agl=agl, nhrs=nhrs,
                   numpar=nparstilt, doublefiles=T, metd=metsource, metlib=metpath,
                   conv=convect, overwrite=overwrite, outpath=path, varsout=varstrajec, rundir=rundir,
                   nummodel=nummodel, sourcepath=sourcepath, ziscale=l.ziscale, zsg.name=l.zsg.name,
                   create.X0=l.create.X0,setup.list=l.setup.list,hymodelc.exe=l.hymodelc.exe,
                   siguverr=siguverr,TLuverr=TLuverr,zcoruverr=zcoruverr,horcoruverr=horcoruverr,
                   sigzierr=sigzierr,TLzierr=TLzierr,horcorzierr=horcorzierr)
  } else {
    info <- Trajec(yr=yr, mon=mon, day=day, hr=hr, lat=lat, lon=lon, agl=agl, nhrs=nhrs,
                   maxdist=stepsize, numpar=nparstilt, doublefiles=T, metd=metsource, metlib=metpath,
                   conv=convect, overwrite=overwrite, outpath=path, varsout=varstrajec, rundir=rundir,
                   nummodel=nummodel, sourcepath=sourcepath, ziscale=l.ziscale, zsg.name=l.zsg.name,
                   create.X0=l.create.X0,
                   siguverr=siguverr,TLuverr=TLuverr,zcoruverr=zcoruverr,horcoruverr=horcoruverr,
                   sigzierr=sigzierr,TLzierr=TLzierr,horcorzierr=horcorzierr)
  }
  if (firsttraj) { # set up array for run info
    run.info <- matrix(NA, nrow=nrows, ncol=length(info))
    dimnames(run.info) <- list(NULL, names(info))
    firsttraj <- F
  } else {
    havenames <- dimnames(run.info)[[2]]
    for (nm in names(info)) {
      ndx <- which(havenames == nm)[1] # check if there are new column names
      if (is.na(ndx)) { # new column name, need to add column
        run.info <- cbind(run.info, rep(NA, dim(run.info)[1]))
        dimnames(run.info)[[2]][dim(run.info)[2]] <- nm
      } else { havenames[ndx] <- paste(havenames[ndx], "done", sep="")} # dummy
    }
  }
  run.info[j, names(info)] <- info

  #########################################################################
  ###### TM3-STILT ################
  if(writeBinary == T){

    ####### variables for writing to binary files ######
    dlat   <-as.numeric(lat,digits=10)
    dlon   <-as.numeric(lon,digits=10)
    dagl   <-as.numeric(agl,digits=10)
    dlatres<-as.numeric(lat.res,digits=10)
    dlonres<-as.numeric(lon.res,digits=10)

    ####### construct filename for binary file #########
    cyr<-as.character(2000+yr)
    cmon<-as.character(mon)
    cday<-as.character(day)
    chr<-as.character(hr)
    x1<-""; x2<-""; x3<-""
    if(mon<10) x1<-paste(x1,"0",sep="")
    if(day<10) x2<-paste(x2,"0",sep="")
    if(hr<10)  x3<-paste(x3,"0",sep="")

    pathBinFootprintstation<-paste(pathBinFootprint,station,"/",sep="")
    if (file.access(pathBinFootprintstation,0)!=0) {
i
D
D
D
D
D
D
     system(paste("mkdir ",pathBinFootprintstation,sep=""))
     }

    filename<-paste(pathBinFootprintstation,station,"_",as.character(-nhrs),"h0",as.character(ftintr),
                    "h_",cyr,x1,cmon,x2,cday,x3,chr,"_",gridtag,cendian,".d",sep="")
# Jan's version with height in filename
#    filename<-paste(pathBinFootprintstation,station,"_",as.character(-nhrs),"h0",as.character(ftintr),
#                    "h_",cyr,x1,cmon,x2,cday,x3,chr,"_",sprintf("%5.5d",as.integer(agl)),"_",gridtag,cendian,".d",sep="")

    if (file.exists(filename)) {
    print(paste("Binary footprint file ",filename," already exists"))
    print(paste("not replaced !!"))
    }else{

    ident<-info["outname"]
    print(paste(path,".RData",ident,sep=""))
    if (file.exists(paste(path,".RData",ident,sep=""))) {

    #for longer than hourly intervals for footprints, first make sure to match time intervals of flux fields
    #assume those are e.g. 0-3, 3-6 etc. UTC, or 0-24 UTC 
    #NOTE: only for hourly intervals variables "foottimes", "nfoottimes" and "nftpix" are computed in setStiltparam.r 
    if(ftintr>1){	
      nfoottimes <- -nhrs/ftintr+2               #number of footprints computed
      foottimes<-rep(c(0),nfoottimes)            #vector of times (backtimes) in hours between which footprint is computed
      nftpix<-rep(c(0),nfoottimes)               #vector of numbers of pixels in each footprint
      for(ft in 2:nfoottimes){ 
      foottimes[ft]<- hr+(ft-2)*ftintr 
      }
          foottimes[nfoottimes]<- -nhrs
      if(hr==0){				 #special case when starting at midnight
        foottimes<-foottimes[2:nfoottimes]
        nftpix<-nftpix[2:nfoottimes]
        nfoottimes<-nfoottimes-1
      }
    }

    ####### call Trajecfoot ############################ 
    ident<-info["outname"]
     foot <- Trajecfoot(ident, pathname=path, foottimes=foottimes, zlim=c(zbot, ztop),fluxweighting=NULL, coarse=1, vegpath=vegpath,
                   numpix.x=numpix.x, numpix.y=numpix.y,lon.ll=lon.ll, lat.ll=lat.ll, lon.res=lon.res, lat.res=lat.res)
#    foot<-Trajecfoot(ident=ident,pathname=path,foottimes=foottimes,zlim=c(zbot,ztop),fluxweighting=NULL,coarse=1,vegpath=vegpath,
#                  numpix.x=numpix.x,numpix.y=numpix.y,lon.ll=lon.ll,lat.ll=lat.ll,lon.res=lon.res,lat.res=lat.res)
    nameslat<-rownames(foot)
    nameslon<-colnames(foot)
#    print(paste("nameslat, nameslon: ",nameslat, nameslon))
    if(is.null(foot)){
      print(paste("is.null(foot): ",is.null(foot),foot))
      print(paste("No binary footprint file for TM3 written!!!!"))

    }else{
 
#### write the output file ####
#    cyr<-as.character(2000+yr)
#    cmon<-as.character(mon)
#    cday<-as.character(day)
#    chr<-as.character(hr)
#    x1<-""; x2<-""; x3<-""
#    if(mon<10) x1<-paste(x1,"0",sep="")
#    if(day<10) x2<-paste(x2,"0",sep="")
#    if(hr<10)  x3<-paste(x3,"0",sep="")
#
#    pathBinFootprintstation<-paste(pathBinFootprint,station,"/",sep="")
#    if (file.access(pathBinFootprintstation,0)!=0) {
#     system(paste("mkdir ",pathBinFootprintstation,sep=""))
#     }
#
##    filename<-paste(pathBinFootprintstation,station,"_",as.character(-nhrs),"h0",as.character(ftintr),
##                    "h_",cyr,x1,cmon,x2,cday,x3,chr,"_",gridtag,cendian,".d",sep="")
## Jan's version with height in filename
#    filename<-paste(pathBinFootprintstation,station,"_",as.character(-nhrs),"h0",as.character(ftintr),
#                    "h_",cyr,x1,cmon,x2,cday,x3,chr,"_",sprintf("%5.5d",as.integer(agl)),"_",gridtag,cendian,".d",sep="")

    print(paste("Writing binary footprint file: ",filename))
    con<-file(filename, "wb")
# write first: hours backward, hours interval, lat, lon, altitude, lat resolution, and lon resolution
    writeBin(as.numeric(c(nhrs,ftintr,lat,lon,agl,lat.res,lon.res)),con,size=4,endian=endian) 

    nftpix<-apply(foot,c(3),function(x)return(sum(x>0)))
    ftmax<-which(nftpix>0)[sum(nftpix>0)]
    for(ft in 1:(nfoottimes-1)){
      writeBin(as.numeric(c(ft,nftpix[ft])),con,size=4,endian=endian)          # index of footprint and # grids in footprint
      #### pixel by pixel #####
      if(nftpix[ft]>0){
        id<-which((foot[,,ft])>0,arr.ind=T)
        foot_data<-cbind(as.numeric(nameslat[id[,1]]),as.numeric(nameslon[id[,2]]),foot[,,ft][id])# save coordinates of pixels of each footprint and footprint value
        foot_data<-foot_data[order(foot_data[,1],foot_data[,2]),]
        if(nftpix[ft]==1)foot_data<-matrix(foot_data,nrow=1) #convert back to matrix; ordering turned one-row matrices into vectors
        writeBin(as.vector(t(foot_data)),con,size=4,endian=endian)
        if(any(foot_data[,3]<0))browser()
      } #if(nftpix[ft]>0)
    } #for(ft   
     print(paste("ftmax: ",ftmax))
 
   close(con)
   } #if is.null(foot) 

   }else{
   print(paste(path,outname," does exist -> no new STILT run !!",sep=""))
   } #if (file.exists(paste(path,outname,sep=""))) 

   } #if (file.exists(filename))


  }  #end if(writeBinary == T)

  ###### end of TM3-STILT output ################
  #########################################################################

  #########################################################################
  ##### map trajectories to flux grids and vegetation maps ################
  ##### calculate mixing ratios at receptor points, save in result ########

  if (fluxTF) {

       cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): rownumber j:", j,"\n")

     traj <- Trajecvprm(ident=identname, pathname=path, tracers=fluxtracers, coarse=aggregation,
                dmassTF=T, nhrs=nhrs, vegpath=vegpath, evilswipath=evilswipath,
                vprmconstantspath=vprmconstantspath, vprmconstantsname=vprmconstantsname, nldaspath=nldaspath,
                nldasrad=usenldasrad, nldastemp=usenldastemp, pre2004=pre2004,
                keepevimaps=keepevimaps, detailsTF=detailsTF, bios=fluxmod, landcov=landcov,
                numpix.x=numpix.x, numpix.y=numpix.y, lon.ll=lon.ll, lat.ll=lat.ll,
                lon.res=lon.res, lat.res=lat.res)


     # 'traj' is a vector
     if (existsr(paste("stiltresult_",stilt_year,"_", part, sep=""), path=pathFP)) {
        result <- getr(paste("stiltresult_",stilt_year,"_", part, sep=""), path=pathFP)
        if (dim(result)[1] != nrows) {
           if (firstflux) cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): existing stiltresult has wrong dimension; creating new one.\n")
        } else {
           if (firstflux) cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): found existing stiltresult, update rows in that.\n")
           firstflux <- FALSE
        }
     }
     if (firstflux) { # at beginning create result object
        ncols <- length(traj) # all from Trajec(), + 3 from StartInfo (agl, lat, lon)
        result <- matrix(NA, nrow=nrows, ncol=ncols)
        firstflux <- F
     }
     result[rownum, ] <- traj
     dimnames(result) <- list(NULL, c(names(traj)))
     dimnames(result) <- list(NULL, dimnames(result)[[2]])
     # write the object into default database; object names are, e.g., "Crystal.1"
     assignr(paste("stiltresult_",stilt_year,"_", part, sep=""), result, path=pathFP)
  }
  rownum <- rownum+1

  ##### calculate footprint, assign in object ########
  if (footprintTF) {
    rerunfoot <- FALSE
    if(existsr(paste("foot", identname, sep=""),pathFP)){
       #print(paste("Trajecmod(): found object", paste("foot", identname, sep=""), " in ", pathFP))
       cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): found object: foot", identname)
       foot <- getr(paste("foot", identname, sep=""), pathFP)
       # test if object has same foottimes, if not rerun Trajecfoot
       foothr <- as.numeric(dimnames(foot)[[3]])
       if (!all(foothr==foottimes[1:(length(foottimes)-1)])) {
         rerunfoot<-TRUE
         print(paste("; but dimensions do not match.\n"))
       } else {
         print(paste("; use this.\n"))
       }
    } else {
       rerunfoot <- TRUE
    }

    if (rerunfoot) {
       #print(paste("Trajecmod(): ", identname, " running footprint at ", unix("date"), sep=""))
       cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): ", identname, " running footprint at ",format(Sys.time(), "%d %b %Y %H:%M:%S"),"\n")
       #print(paste("Trajecmod(): memory in use:", memory.size()[1]))
       foot <- Trajecfoot(identname, pathname=path, foottimes=foottimes, zlim=c(zbot, ztop),
                          fluxweighting=NULL, coarse=1, vegpath=vegpath,
                          numpix.x=numpix.x, numpix.y=numpix.y,
                          lon.ll=lon.ll, lat.ll=lat.ll, lon.res=lon.res, lat.res=lat.res)
       # uk check if foot is valid
#       if (is.null(dim(foot))) stop(paste(" Trajecfoot returned empty footprint for ",identname,sep=""))
       if (!is.null(foot)) {
         assignr(paste("foot", identname, sep=""), foot, pathFP)
           cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): foot", identname, " assigned\n")
       } #if (!is.null(dim(foot)))
    } # if (rerunfoot)

    if (is.null(foot)) { # uk check if foot is valid
      print(paste("No footprint file written!!!!"))
    } else {	    
    # write aggregated footprint to netcdf file
    # prepare for ncdf output 
    if (ftintr > 0 | length(foottimes) > 10) {
      ncf_name <- paste("foot",identname,".nc",sep="")
    } else {
      ncf_name <- paste("foot",identname,"_aggreg.nc",sep="")
    }

    require("ncdf4")
    epoch <- ISOdatetime(2000,1,1,0,0,0,"UTC")
    digits=10
    fac.dig <- 1+10^(-digits)
    errors <- NULL
	    
    # foot has dimensions lat,lon,(backward-)time
    # introduce initial time as time dimension (needed to contruct yearly files with aggregated footprints)
    # define backward time as 4th dimension
    footlon <- as.numeric(dimnames(foot)[[2]])
    footlat <- as.numeric(dimnames(foot)[[1]])
    foothr <- 1
    footbhr <- as.numeric(dimnames(foot)[[3]])
    # shift footbhr to represent start time of integration rather than end time
    # assuming that first integration intervall ends at initial time
    footbhr <- foottimes[2:(length(foottimes))]
    hr <- round((StartInfo[j,1]-floor(StartInfo[j,1]))*24)
    inittime<-ISOdatetime(dat$year,dat$month,dat$day,hr,0,0,tz="UTC")
    foottime <- inittime-footbhr*3600

    footdate <- as.numeric(difftime(inittime,epoch,units="days")) # subtract the epoch to make days-since
    footbdate <- as.numeric(difftime(foottime,epoch,units="days")) # subtract the epoch to make days-since

    # if netcdf file does not exist or has different content, write new netcdf file
    if (file.exists(paste(pathFP,ncf_name,sep=""))) {
      cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): found netcdf file ", ncf_name,"\n")
      ncf <- nc_open(paste(pathFP,ncf_name,sep=""))
        cat(format(Sys.time(), "%FT%T"),"DEBUG Trajecmod(): found netcdf file ", ncf_name, " in ", pathFP,"\n")
        #cat(format(Sys.time(), "%FT%T"),"DEBUG open ",ncf,"\n")
      for( i in 1:ncf$nvars ) {
        z <- ncf$var[[i]]
        if (z$name=="foot") testfoot<-ncf$var[[i]]
      }

      zfoot <- ncvar_get( ncf, testfoot )
      if(compare.signif(zfoot,drop(aperm(foot,c(2,1,3))),digits,fac.dig) !=0) errors <- c(errors,'foot mismatch')
      #if(compare.signif(z$lat,footlat,digits,fac.dig) !=0) errors <- c(errors,'footlat mismatch')
      #if(compare.signif(z$lon,footlon,digits,fac.dig) !=0) errors <- c(errors,'footlon mismatch')
      #if(sum(z$time != footdate) !=0) errors <- c(errors,'footdate mismatch')
      cat(format(Sys.time(), "%FT%T"),"DEBUG ",paste(errors,sep=" "),"\n")
      nc_close(ncf)
      if (!is.null(errors)) {
         cat(format(Sys.time(), "%FT%T"),"DEBUG ; but content does not match.\n")
         cat(format(Sys.time(), "%FT%T"),"DEBUG ; mismatch in ",errors,"\n")
      } else {
         cat(format(Sys.time(), "%FT%T"),"DEBUG ; use this.\n")
         #system(paste("rsync ",pathFP,ncf_name," ",pathResults,ncf_name,sep=""))
      }
    }
    if (!file.exists(paste(pathFP,ncf_name,sep="")) | !is.null(errors)) {
      # dimensions for netcdf file
      footlon.dim <- ncdim_def( "lon", "degrees_east", footlon, longname="degrees longitude of center of grid boxes" )
      footlat.dim <- ncdim_def( "lat", "degrees_north", footlat, longname="degrees latitude of center of grid boxes"  )
      footdate.dim <- ncdim_def( "time", "days since 2000-01-01 00:00:00 UTC", footdate, longname="footprint initial date",unlim=TRUE )
      #footbdate.dim <- ncdim_def( "back", "days since 2000-01-01 00:00:00 UTC", footbdate, longname="footprint intervalls backward time" )

      # missing values
      mv <- -1.e30 # missing value to use
      # define variable
      # compress is not working... hdf5 not correctly installed/linked?
      #footprint <- ncvar_def( "foot", "ppm per (micromol m-2 s-1)", list(footbdate.dim,footlon.dim,footlat.dim,footdate.dim), mv, longname="STILT footprints integrated over backward time intervall btime-time" , prec="double", compression=9)
      footprint <- ncvar_def( "foot", "ppm per (micromol m-2 s-1)", list(footlon.dim,footlat.dim,footdate.dim), mv, longname="STILT footprints integrated over backward time intervall backtime" , prec="double", compression=9)

    # Create output file
      ncf <- nc_create( paste(pathFP,ncf_name,sep=""), list(footprint) )

      # write data to the file
      #rearange dimensions for netcdf because netcdf standard requires lon,lat,time, use btime as 4th dimension
      footT<-aperm(foot,c(2,1,3))   
      #footT<-array(footT,dim=c(dim(footT)[3],dim(footT)[1],dim(footT)[2],1))
      #ncvar_put( ncf, footprint, footT, start=c(1,1,1,1), count=c(-1,-1,-1,-1) )
      ncvar_put( ncf, footprint, footT, start=c(1,1,1), count=c(-1,-1,-1) )

      # add attributes
      ncatt_put( ncf, 0, "backtime",paste(-nhrs,"hours",sep=" ") )
      ncatt_put( ncf, 0, "description",
                      paste("aggregated STILT footprints on lon/lat/time grid,",
		            "aggregated in grid boxes (lat,lon) and stilt start time (time),",
			    "aggregated over backtime hours prior to start time") )
      nc_close(ncf)
      cat(format(Sys.time(), "%FT%T"),"DEBUG Footprint written to NetCDF file ",ncf_name,"\n")
      #system(paste("rsync ",pathFP,ncf_name," ",pathResults,ncf_name,sep=""))
    } 
  } # !is.null(foot) 
  } # footprintTF

  ##### plot footprint ########
  if (footplotTF) { # plot footprints
    if(!file.exists(paste(pathResults,"Footprints/",identname,".png",sep=""))) {
    foot <- getr(paste("foot", identname, sep=""), pathFP)
    footplot(foot,identname,lon.ll,lat.ll,lon.res,lat.res)
    }
    for (foottimespos in 1:(length(foottimes)-1)) {
    ############# NOT READY YET ###############
    }
  }

  # Specify the function parameters
  if (biomassburnTF) {
     biomassburnoutmat[j, ] <- biomassburn(timesname=StartInfo, burnpath=burnpath, endpath=path, pathname=path, nhrs=nhrs, timesrow=j)
     print(paste("Biomassburning influence calculated to be ", biomassburnoutmat[j,2], " ppbv. Inserted into fireinfluence matrix row ", j, sep=""))
  }

  if(l.remove.Trajfile)unix(paste("rm -f ",paste(path,".RData",identname,sep=""),sep=""))

}                                                           # for (j in 1:nrows)


# Wrap up all of the CO biomassburning calculations
if (biomassburnTF)
  write.table(biomassburnoutmat, file=paste(path, "fireinfluencex", nhrs, "hr_", part, ".txt", sep=""), row.names=F)

##### save mixing ratios at receptor points in file, e.g. stiltresult1.csv for part=1 ########
if (fluxTF) {
   dimnames(result) <- list(NULL, dimnames(result)[[2]])
   # write the object into default database; object names are, e.g., "Crystal.1"
   assignr(paste("stiltresult_",stilt_year,"_", part, sep=""), result, path=pathFP)
     cat(format(Sys.time(), "%FT%T"),"DEBUG stiltresult_",stilt_year,"_", part, " assigned in ", pathFP, "\n")
   write.table(result, file=paste(pathFP, "stiltresult_",stilt_year,"_", part, ".csv", sep=""), na="", row.names=F)
}

# If evi and lswi maps from vprm calculations is saved to the global environment; it should be removed here

rm(list=objects(pattern="GlobalEvi"), envir=globalenv())
rm(list=objects(pattern="GlobalLswi"), envir=globalenv())
gc(verbose=F)

return(run.info)

}

compare.signif <- function(x,y,digits=6,fac.dig=1+10^(-digits)) {
  # comparison of f.p. numbers to within specified significant digits
  # Uses signif function, but with added handling of rounding of 5
#print(paste("digits ",digits,sep=""))
#print(paste("x ",x,sep=""))
#print(paste("y ",y,sep=""))
mask <- signif(x,digits) != signif(y,digits)
  nfail <- sum(mask)
  if (nfail > 0)
    nfail <- sum(signif(fac.dig*x[mask],digits) != signif(fac.dig*y[mask],digits))
  nfail
}
		
