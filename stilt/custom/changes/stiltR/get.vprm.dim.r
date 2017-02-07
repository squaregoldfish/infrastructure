#***************************************************************************************************
#  read dimension of VPRM fields from netcdf files
#***************************************************************************************************

get.vprm.dim <- function(evilswipath) {
#evilswipath: input path for VPRM EVI and LSWI files

      if (!is.element("package:ncdf4", search())) library("ncdf4") # Load ncdf library

      #check directory, get EVI_MAX file
      fnames<-dir(evilswipath)
      fname<-fnames[substring(fnames,1,nchar("VPRM_input_VEG_FRA_"))=="VPRM_input_VEG_FRA_"][1]
      evifile <- nc_open(paste(evilswipath,fname,sep=""), write=F)

      # get dimensions
      if(regexpr("d01",fname)>0){ #old format (before June 2009)
        nx<-length(ncvar_get(evifile,"west_east"))
        ny<-length(ncvar_get(evifile,"south_north"))
        nv<-length(ncvar_get(evifile,"vprm_classes"))
      } else {#new format
        nx<-length(ncvar_get(evifile,"lon"))
        ny<-length(ncvar_get(evifile,"lat"))
        nv<-length(ncvar_get(evifile,"vprm_classes"))
      }
      nc_close(evifile)
      result<-c(nx,ny,nv)
      names(result)<-c("nx","ny","nv")
      return(result)
}
