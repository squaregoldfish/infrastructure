!*******************************************************************************
!  access to IER human emission data file with aggregation
!*******************************************************************************
!
!  On the MPI Jena cluster, the compile command reads (in one line)
!     ifort -I/Net/Groups/BSY/tools/STILT/netCDF/netcdf-3.6.2/f90 -fPIC -shared -o getfireBARCAnetCDF.so getfireBARCAnetCDF.f90
!     /Net/Groups/BSY/tools/STILT/netCDF/netcdf-3.6.2/fortran/.libs/libnetcdff.so /Net/Groups/BSY/tools/STILT/netCDF/netcdf-3.6.2/libsrc/.libs/libnetcdf.so
!
!-------------------------------------------------------------------------------
!  History
!  -------
!
!  17.09.2009  Initial version. Christpoph Gerbig, adapted from getfossEUnetCDF.f90 v 1.4 2009/01/27
!
!  $Id: getfireBARCAnetCDF.f90,v 1.1 2009-11-25 08:51:03 gerbig Exp $
!-------------------------------------------------------------------------------

INCLUDE 'date_sub.f90'
INCLUDE 'mrgrnk.f90'

MODULE common_data

   USE netCDF
   IMPLICIT NONE

   SAVE

   INTEGER, PARAMETER :: maxfiles=300
   CHARACTER(255)     :: fnames(maxfiles)=' '
   INTEGER            :: ncstat, ncid(maxfiles)=-HUGE(1), varid(maxfiles)=-HUGE(1), lon_id(maxfiles)=-HUGE(1), lat_id(maxfiles)=-HUGE(1)
   LOGICAL            :: time_dependent(maxfiles)
 
   INTEGER :: lon_dim_array(maxfiles)
   INTEGER :: lat_dim_array(maxfiles)
   INTEGER :: time_dim_array(maxfiles)
   REAL :: lon_res_array(maxfiles)
   REAL :: lat_res_array(maxfiles)
   REAL :: lon_ll_array(maxfiles)
   REAL :: lat_ll_array(maxfiles)
   character(80) :: emission_name 


CONTAINS


   !***********************************************************************
   !  error handler for netCDF
   !***********************************************************************

   SUBROUTINE nc_handle_err (stat)
      INTEGER, INTENT(IN) :: stat
      IF (stat /= nf90_noerr) THEN
         PRINT '(2a)', 'ERROR netCDF error: ', NF90_STRERROR(stat)
         STOP 'ERROR Stop.'
      ENDIF
   END SUBROUTINE nc_handle_err

!   SUBROUTINE get_now(ccc)
!      character(len=20), intent(out)  :: ccc
!      integer :: now(8)
!      call date_and_time(values=now)
!      write(ccc,'(I4,A1,I2.2,A1,I2.2,A1,I2.2,A1,I2.2,A1,I2.2,1X)') &
!         now(1),'-',now(2),'-',now(3),'T',now(5),':',now(6),':',now(7)
!   END SUBROUTINE get_now

END MODULE common_data



!***********************************************************************
!  assign a file index to the given file name
!***********************************************************************

SUBROUTINE fname2fi (fname, fi)
   USE common_data
   USE date_sub, ONLY: get_now
   IMPLICIT NONE

   CHARACTER(*), INTENT(IN)  :: fname                     ! filename
   INTEGER     , INTENT(OUT) :: fi                          ! file index

   INTEGER :: k,lon_dim,lat_dim,time_dim
   character(20)  :: now_iso
!----------------------------------------------------------------------------------------------------

   call get_now(now_iso)

   DO k=1,maxfiles
      IF (fname == fnames(k)) EXIT
   END DO
   IF (k <= maxfiles) THEN
      fi = k                                                ! already in
      RETURN
   ELSE                                                     ! not in
      ! find in fnames the first index with empty string
      DO k=1,maxfiles
         IF (fnames(k) == ' ') EXIT
      END DO
      IF (k > maxfiles) THEN
         STOP now_iso//'ERROR Subroutine fname2fi: all file entries allocated. Stop.'
      ELSE
         fi = k
         fnames(fi) = fname
         CALL IER_Open (fi,lon_dim,lat_dim,time_dim)
!          WRITE (*,*) now_iso,'DEBUG: after call IER_open lon_dim,lat_dim,time_dim fi',lon_dim,lat_dim,time_dim,fi
         lon_dim_array(fi)=lon_dim
         lat_dim_array(fi)=lat_dim
         time_dim_array(fi)=time_dim
      END IF

   END IF


END SUBROUTINE fname2fi


SUBROUTINE IER_Open (fi,lon_dim,lat_dim,time_dim)
   USE common_data
   USE date_sub, ONLY: iday, izlr, get_now
   IMPLICIT NONE

   INTEGER, INTENT(IN) :: fi                                ! file index, file name is fnames(fi)

   INTEGER             :: dimid_lon,dimid_lat,dimid_time, k,i
   INTEGER , INTENT(OUT)  :: lon_dim,lat_dim,time_dim

   integer :: var_type(4),var_dim(4)  ! is here maximum 4 : lat,lon,time,emission field
   integer :: var_len(4) ! how many entries have each variable
   integer :: nDims,nVars,nGlobalAttrs,unlimDimid,formatNum ! number of
   LOGICAL :: center_check
   real    :: lon(2),lat(2), tmp
   character(80) :: var_name(4)
   character(80) :: lat_name,lon_name,time_name
   character(20)  :: now_iso 
!---------------------------------------------------------------------------------------------------

   CALL get_now(now_iso)
   
   IF (fi < 1 .OR. fi > maxfiles) THEN
      PRINT '(a,2(a,i0))', now_iso,'ERROR Subroutine IER_Open: argument fi must be >= 1 and <= ', maxfiles, &
         ' but is ', fi
      STOP now_iso//'ERROR Stop.'
   END IF

   WRITE (*,'(4a)', ADVANCE='NO') now_iso,'DEBUG Opening file ', TRIM(fnames(fi)), '... '
   ncstat = NF90_OPEN(TRIM(fnames(fi)), nf90_nowrite, ncid(fi))

   CALL nc_handle_err (ncstat)
!   WRITE (*,'(a)', ADVANCE='NO') 'done.'

!------------------------------------
! returns the number of dimensions, number of variables, numbe of global attributes and ID of the unlimited dimension
  ncstat =  nf90_inquire(ncid(fi),nDims,nVars,nGlobalAttrs,unlimDimid,formatNum)
   CALL nc_handle_err (ncstat)

!--------------
   do i=1,nDims
          ncstat = NF90_INQUIRE_DIMENSION(ncid(fi), i, len=var_len(i)) ! get the length of each dimension
         CALL nc_handle_err (ncstat)
         ! WRITE (*,*) now_iso,"DEBUG 3b var_len(i):",var_len(i)
    enddo


!------------
 do i=1,nVars  !is here maximum 4 : lat,lon,time,emission
    
     ncstat = nf90_inquire_variable(ncid(fi),i,var_name(i),var_type(i),var_dim(i)) ! get variable name, tyes, shapes
     CALL nc_handle_err (ncstat)
  !   ncstat = NF90_INQUIRE_DIMENSION(ncid(fi), var_dim(i), len=var_len(i))

     if (var_dim(i) .gt. 1) then
        ! means is the emission variable
         emission_name=var_name(i)
     else if (index(var_name(i),'lat').gt.0.or.index(var_name(i),'Lat').gt.0.or.index(var_name(i),'LAT').gt.0) then
        ! means is lat
         lat_name=var_name(i)
     else if(index(var_name(i),'lon').gt.0.or.index(var_name(i),'Lon').gt.0.or.index(var_name(i),'LON').gt.0) then 
        ! means is lon
         lon_name=var_name(i)
     else
           ! means is time
           time_name=var_name(i)
     endif 

 enddo


!----------------------------------

   !--- get ID of variable

!   emission_name='EMIS' ! was  'CO.emission'   ! not used more

 !   WRITE (*,'(3a)' ) 'DEBUG: Now test for emission_name'
   ncstat = NF90_INQ_VARID(ncid(fi), trim(adjustl(emission_name)), varid(fi))
   CALL nc_handle_err (ncstat)

   !get lon dimension
   ! lon_name='fakeDim2' ! not use more
   ! WRITE (*,'(3a)') 'DEBUG: Now test for lon_name:',lon_name
    ncstat = NF90_INQ_DIMID(ncid(fi),trim(adjustl(lon_name)), dimid_lon) ! is lon
    CALL nc_handle_err (ncstat)
    ncstat = NF90_INQUIRE_DIMENSION(ncid(fi), dimid_lon, len=lon_dim)
    CALL nc_handle_err (ncstat)
   !get lat dimension
   ! lat_name='fakeDim1'  ! not use more
   !  WRITE (*,'(3a)') 'DEBUG: Now test for lat_name:',lat_name
    ncstat = NF90_INQ_DIMID(ncid(fi), trim(adjustl(lat_name)), dimid_lat)

    CALL nc_handle_err (ncstat)
    ncstat = NF90_INQUIRE_DIMENSION(ncid(fi), dimid_lat, len=lat_dim)

    CALL nc_handle_err (ncstat)

   !get time dimension
   if (nVars .ge. 4) then
     ! time_name='fakeDim0' ! not use more
    ! WRITE (*,'(4a)') now_iso,'DEBUG: Now test for time_name',time_name
      ncstat = NF90_INQ_DIMID(ncid(fi),  trim(adjustl(time_name)), dimid_time)
      CALL nc_handle_err (ncstat)
      ncstat = NF90_INQUIRE_DIMENSION(ncid(fi), dimid_time, len=time_dim)
      CALL nc_handle_err (ncstat)

      !--- check whether there is a time dependence in the emission
      k=time_dim
      time_dependent(fi) = k > 1
      IF (time_dependent(fi)) THEN
        PRINT *
      ELSE
        PRINT '(a)', ' (time-independent emission field)'
      END IF
   else
     time_dependent(fi) = 1 > 1
   endif
   
   !get offset in lat and lon for using smaller domain within larger emission domain
   ncstat = NF90_INQ_VARID(ncid(fi), trim(adjustl(lon_name)), lon_id(fi))
   CALL nc_handle_err (ncstat)
   ncstat = NF90_GET_VAR (ncid(fi), lon_id(fi), start=(/1/), values=lon(1))
   CALL nc_handle_err (ncstat)
   ncstat = NF90_GET_VAR (ncid(fi), lon_id(fi), start=(/lon_dim/), values=lon(2))
   CALL nc_handle_err (ncstat)
   lon = ANINT(lon*1000.0)/1000.0 !avoid rouning errors
   lon_res_array(fi) = (lon(2)-lon(1))/(lon_dim-1)
   lon_res_array(fi) = ANINT(lon_res_array(fi)*1000.0)/1000.0 !avoid rouning errors
   ! check if center coordinates or corner (lower left) are given in ncdf file
   ! characteristic for center coordinates: fractional part of lon_ll is not multiple of resolution
   tmp = lon(1)/lon_res_array(fi)
   tmp=abs(tmp-anint(tmp))
   tmp=ANINT(tmp*1000.0)/1000.0 !avoid rouning errors
   center_check =   tmp.eq.0.5
   if(center_check) then 
      lon_ll_array(fi) = lon(1)-0.5*lon_res_array(fi) !transform to lower left
   else 
      lon_ll_array(fi) = lon(1)
   end if

   ncstat = NF90_INQ_VARID(ncid(fi), trim(adjustl(lat_name)), lat_id(fi))
   CALL nc_handle_err (ncstat)
   ncstat = NF90_GET_VAR (ncid(fi), lat_id(fi), start=(/1/), values=lat(1))
   CALL nc_handle_err (ncstat)
   ncstat = NF90_GET_VAR (ncid(fi), lat_id(fi), start=(/lat_dim/), values=lat(2))
   CALL nc_handle_err (ncstat)
   lat = ANINT(lat*1000.0)/1000.0 !avoid rouning errors
   lat_res_array(fi) = (lat(2)-lat(1))/(lat_dim-1)
   lat_res_array(fi) = ANINT(lat_res_array(fi)*1000.0)/1000.0 !avoid rouning errors
   if(center_check) then 
      lat_ll_array(fi) = lat(1)-0.5*lat_res_array(fi) !transform to lower left
   else 
      lat_ll_array(fi) = lat(1)
   end if
END SUBROUTINE IER_Open

SUBROUTINE getEmisnetCDF (fname, n, date, i, j, ires, jres,lon_ll,lat_ll,numpix_x,numpix_y,f)

!-------------------------------------------------------------------------------
!
!  Algorithm
!  ---------
!
!  Consult the author :)
!
!-------------------------------------------------------------------------------
   USE common_data
   USE date_sub, ONLY: iday, izlr, get_now
   USE m_mrgrnk, ONLY: mrgrnk
   IMPLICIT NONE
   !DEC$ ATTRIBUTES reference:: fname
   CHARACTER(255), INTENT(IN)  :: fname                     ! filename
   INTEGER       , INTENT(IN)  :: n                         ! number of requested values
   INTEGER       , INTENT(IN)  :: date(5,n),  &             ! YY MM DD hh mm - reference times
                                  i(n), j(n), &             ! indices of cells on aggregated grid
                                  ires(n), jres(n)          ! cell aggregation parameters
   REAL          , INTENT(OUT) :: f(n)                      ! averaged flux values
   INTEGER       , INTENT(IN)  :: lon_ll,lat_ll ! lower left corner for lon at lat
   INTEGER       , INTENT(IN)  :: numpix_x,numpix_y ! length of lat, lon area 
   !--- local variables

   INTEGER  imax, jmax                 ! horiz. field dimensions in file

   INTEGER            :: fi, k, l,                   &
                         i1(n), i2(n), j1(n), j2(n), &      ! field boundaries to read from file
                         i1a(n), i2a(n), &                  ! intermediate field boundaries for global fields
                         ti_file(n), &                      ! time index on file (1..)
                         it_file(n)                         ! ranking array

   !  for file access
   INTEGER            :: ti_file_last                       ! time index of the last loaded field
   LOGICAL            :: mask_ti(n)
   LOGICAL            :: global, readagain(n)
   INTEGER            :: i1_ti, i2_ti, j1_ti, j2_ti         ! envelope for all areas at current time
   real, allocatable, dimension (:,:) :: a  ! a is then   a(imax, jmax)
   integer :: alloc_status,full_day_slice,lon_offset,lat_offset
!---------------------------------------------------------------------------------------------------
 CALL fname2fi (fname, fi)

  ! allocate matrix a
  imax=lon_dim_array(fi)
  jmax=lat_dim_array(fi)
  allocate(a(imax,jmax),stat=alloc_status)
  if (alloc_status/=0) then
      write (*,*) "ERROR cannot allocate a with imax,jmax.:",imax,jmax
      stop
      endif

 !  WRITE (*,*) 'DEBUG imax,jmax,lon_ll,lat_ll,fi:',imax,jmax,lon_ll,lat_ll,fi

  lon_offset = (lon_ll - lon_ll_array(fi))/lon_res_array(fi) !offset in pixels
  lat_offset = (lat_ll - lat_ll_array(fi))/lat_res_array(fi)
!  global = (imax*lon_res_array(fi).eq.360.and.jmax*lat_res_array(fi).eq.180)  
  global = (imax*lon_res_array(fi).eq.360) ! tk 20160615  global is set now if southern or northern hemisphere
 
  if(global.and.lon_offset.lt.0.0)lon_offset=lon_offset + imax  !  lon_ll range (-180/180) and nectdf range (0-360) --> add 180

  if(.not.global.and.(numpix_x.gt.imax+lon_offset.or.numpix_y.gt.jmax+lat_offset)) then
      write (*,*) "ERROR : exceeding boundaries with imax,jmax.:",imax+lon_offset,jmax+lat_offset
      write (*,*) "requested domain boundaries with imax,jmax.:",numpix_x,numpix_x
      stop
   endif

   DO k=1,n
      !--- compute the spatial boundaries of the netCDF field - using also lon.ll, lat.ll
      i1(k) = (i(k)-1)*ires(k)+1 + lon_offset
      if(global) then
      !--- global means i1 should be between 1 and imax, and i2 could be larger than imax, but less than 2*imax
         i2(k) = (i(k)*ires(k) + lon_offset)
         if(i1(k).gt.imax) then 
            i1(k) = i1(k) - imax
            i2(k) = i2(k) - imax
         end if
         readagain(k) = i2(k).gt.imax
         if(readagain(k)) then !split in sections: i1 to imax, 1 to i2-imax
            i2a(k) = i2(k) - imax
            i2(k) = imax
            i1a(k) = 1
!write(*,*)'check: i1(k),i1a(k),i2a(k),i2(k): ',i1(k),i1a(k),i2a(k),i2(k),readagain(k)
         else !need to set i1a and i2a to some default!
            i1a(k) = 1
            i2a(k) = 1
         end if
      else ! for not global
         i2(k) = MIN(i(k)*ires(k) + lon_offset, imax)
      end if
      j1(k) = (j(k)-1)*jres(k)+1 +  lat_offset
      j2(k) = MIN(j(k)*jres(k) + lat_offset, jmax)
      !--- compute the spatial boundaries of the netCDF field
!      i1(k) = (i(k)-1)*ires(k)+1
!      i2(k) = MIN(i(k)*ires(k),imax)
!      j1(k) = (j(k)-1)*jres(k)+1
!      j2(k) = MIN(j(k)*jres(k),jmax)

      IF (i1(k) < 1 .OR. i1(k) > imax .OR. j1(k) < 1 .OR. j1(k) > jmax) THEN
         PRINT '(a,i0)'      , 'ERROR Subroutine getEmisetCDF: Field index exceedance at input item ', k
         PRINT '(a,5(1x,i0))', 'ERROR i, j, ires, jres, lono, lato : ', i(k), j(k), ires(k), jres(k), lon_offset, lat_offset
         PRINT '(a,4(1x,i0))', 'ERROR i1, i2, j1, j2, imax, jmax   : ', i1(k), i2(k), j1(k), j2(k), imax, jmax
         STOP 'ERROR Stop.'
      END IF


      IF (time_dependent(fi)) THEN
          if (time_dim_array(fi).eq. 12) then

             ! means monthly data
             ti_file(k)=date(2,k) ! is month (tk)
          else if (time_dim_array(fi).eq. 365 .or. time_dim_array(fi).eq. 366 ) then
 
            ! means daily data (365 normal year / 366 data for loop year)
             !  time index on file (= day number in year, starting with 1)
              ti_file(k) = iday(yyyy=date(1,k), mm=date(2,k), dd=date(3,k))
          else if (time_dim_array(fi).eq. (365*24) .or. time_dim_array(fi).eq. (366*24) ) then

             ! means hourly data (365 * 24 normal year / 366 * 24 data for loop year)
             !  time index on file (= day number in year, starting with 1)
              full_day_slice = iday(yyyy=date(1,k), mm=date(2,k), dd=date(3,k)) 
              ti_file(k)=(full_day_slice-1.0)*24+date(4,k)+1
             ! date(4,k) are hours started at: 0 ; test this?
          else  
             ! means annual data for several years
              ti_file(k)=date(1,k)-1984 !assume starts with 1985
          endif 
      ELSE
         ti_file(k) = 1
      END IF


   END DO


   !--- for file access optimization, do a ranking of the reference times
   CALL mrgrnk (XDONT=ti_file, IRNGT=it_file)               ! on output, ti_file(it_file(:)) is
                                                            !    ordered

   !--- read the grid cells, ordered in time

   ti_file_last = -HUGE(ti_file_last)
   DO k=1,n

      l = it_file(k)

      IF (ti_file(l) /= ti_file_last) THEN

         !--- determine the spatial envelope for this time instant

         mask_ti = ti_file==ti_file(l)
         i1_ti = MINVAL(i1, MASK=mask_ti)
         i2_ti = MAXVAL(i2, MASK=mask_ti)
         j1_ti = MINVAL(j1, MASK=mask_ti)
         j2_ti = MAXVAL(j2, MASK=mask_ti)

      ! test ( first i1_ti must be the ll.lon; first j1_ti must be the ll.lat (+ 1 because of stagging grid cell)
       !WRITE (*,*) "DEBUG : now get values from netcdf file"
       ! write (*,*) "DEBUG: lon_ll,lat_ll:",lon_ll,lat_ll
       ! write (*,*) "DEBUG: i1_ti, j1_ti, ti_file(l)",i1_ti, j1_ti, ti_file(l)
       ! write (*,*) "DEBUG: i2_ti, j2_ti, ti_file(l)",i2_ti, j2_ti, ti_file(l)
         ncstat = NF90_GET_VAR (ncid(fi), varid(fi), start=(/i1_ti, j1_ti, ti_file(l)/), &
                                values=a(i1_ti:i2_ti,j1_ti:j2_ti))
         CALL nc_handle_err (ncstat)
         if(global) then
            if(readagain(k)) then
               i1_ti = MINVAL(i1a, MASK=mask_ti)
               i2_ti = MAXVAL(i2a, MASK=mask_ti)
               ncstat = NF90_GET_VAR (ncid(fi), varid(fi), start=(/i1_ti, j1_ti, ti_file(l)/), &
                                   values=a(i1_ti:i2_ti,j1_ti:j2_ti))
               CALL nc_handle_err (ncstat)
            end if
         end if
         ti_file_last = ti_file(l)

      END IF

      !  return the average
      f(l) = SUM(a(i1(l):i2(l),j1(l):j2(l)))/((i2(l)-i1(l)+1)*(j2(l)-j1(l)+1))
   END DO

   deallocate (a)
!  write (*,*) "DEBUG: fortran call getEmisnetCDF finished ok"
END SUBROUTINE getEmisnetCDF



SUBROUTINE IER_Close (fi)
   USE common_data
   IMPLICIT NONE

   INTEGER, INTENT(IN) :: fi

!---------------------------------------------------------------------------------------------------
   ncstat = nf90_close(ncid(fi))
   CALL nc_handle_err (ncstat)
   fnames(fi) = ' '
   ncid(fi)   = -HUGE(1)
   varid(fi)  = -HUGE(1)

END SUBROUTINE IER_Close




