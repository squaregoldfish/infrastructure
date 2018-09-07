program flextraset;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { TMyApplication }
  statrec = record lon,lat,hght : double;nam:string[40] end;

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    StationNr,
    NrStat,
    OutIntervalHr,
    ReleaseStepSec,
    SpinUpTime,
    NrParticles : longint;
    StartDate,
    EndDate     : TDatetime;
    meteopath,
    outputpath,
    Stationfile : String;
    stats       : array of statrec;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    procedure readstationlist(fname:string);
    procedure WriteReleases(startt,endt,stept:tdatetime;mass:double;nrpart,stat:longint);
    procedure WriteCommand(Startt,EndT:tdatetime;OutIntvlHr:integer);
    procedure Writepathnames(m,o:String);
  end;

CONST
  species = 24;

procedure TMyApplication.readstationlist(fname:string);
var
  t : system.text;
begin
  system.assign(t,fname);
  reset(t);
  readln(t); // skip header
  nrstat:=0;
  while not eof(t) and not eoln(t)  do
  begin
    setlength(stats,nrstat+1);
    with stats[nrstat] do
      read(t,lon,lat,hght,nam);
    readln(t);
    inc(nrstat);
  end;
  closefile(t);
end;

procedure TMyApplication.Writepathnames(m,o:String);
var
    f : system.text;
begin
  assignfile(f,'pathnames');
  rewrite(f);
  writeln(f,'./options/');
  writeln(f,o);
  writeln(f,m);
  writeln(f,m+'AVAILABLE');
  writeln(f,'============================================');
  closefile(f);
end;

procedure TMyApplication.WriteReleases(startt,endt,stept:tdatetime;mass:double;nrpart,stat:longint);
var
//  i,
  CurStat : integer;
  f       : system.text;
  tim     : tdatetime;
begin
  assignfile(f,'./options/RELEASES');
  rewrite(f);
  writeln(f,'*************************************************************************');
  writeln(f,'*                                                                       *');
  writeln(f,'*                                                                       *');
  writeln(f,'*                                                                       *');
  writeln(f,'*   Input file for the Lagrangian particle dispersion model FLEXPART    *');
  writeln(f,'*                        Please select your options                     *');
  writeln(f,'*                                                                       *');
  writeln(f,'*                                                                       *');
  writeln(f,'*                                                                       *');
  writeln(f,'*************************************************************************');
  writeln(f,'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
  writeln(f,'1                          Total number of species emitted');
  writeln(f,species:1,'                         Index of species in file SPECIES');
  writeln(f,'=========================================================================');
  tim:=startt;
  while tim<=endt do
  begin
//    for i:=0 to StPerRun.value-1 do
    begin
//      CurStat:=StartSt.Value+i;
      CurStat:=stat;
      if CurStat<=NrStat then with stats[CurStat-1] do
      begin
        writeln(f,'   ',formatdatetime('YYYYMMDD HHMMSS',tim-stept));
        writeln(f,'   ',formatdatetime('YYYYMMDD HHMMSS',tim));
        writeln(f,'   ',lon:0:5);
        writeln(f,'   ',lat:0:5);
        writeln(f,'   ',lon:0:5);
        writeln(f,'   ',lat:0:5);
        writeln(f,'   2');
        writeln(f,'   ',hght:0:1);
        writeln(f,'   ',hght:0:1);
        writeln(f,'   ',nrpart:0);
        writeln(f,'   ',mass:0:5);
        writeln(f,stats[CurStat-1].nam+'_'+formatdatetime('YYYYMMDDHHMMSS',tim-stept/2));
        writeln(f,'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      end;
    end;
    tim:=tim+stept;
  end;
  closefile(f);
end;


procedure TMyApplication.WriteCommand(Startt,EndT:tdatetime;OutIntvlHr:integer);
var
  f : system.text;
begin
  assignfile(f,'./options/COMMAND');
  rewrite(f);
  writeln(f,'********************************************************************************');
  writeln(f,'*                                                                              *');
  writeln(f,'*      Input file for the Lagrangian particle dispersion model FLEXPART        *');
  writeln(f,'*                           Please select your options                         *');
  writeln(f,'*                                                                              *');
  writeln(f,'********************************************************************************');
  writeln(f,'');
  writeln(f,'-1              LDIRECT           1 FOR FORWARD SIMULATION, -1 FOR BACKWARD SIMULATION');
  writeln(f,formatdatetime('YYYYMMDD HHMMSS',StartT),'   BEGINNING DATE OF SIMULATION');
  writeln(f,formatdatetime('YYYYMMDD HHMMSS',EndT),'   ENDING DATE OF SIMULATION');
  writeln(f,OutIntvlHr*3600:1,'            SSSSS             OUTPUT EVERY SSSSS SECONDS');
  writeln(f,OutIntvlHr*3600:1,'            SSSSS             TIME AVERAGE OF OUTPUT (IN SSSSS SECONDS)');
  writeln(f,'1800            SSSSS             SAMPLING RATE OF OUTPUT (IN SSSSS SECONDS)');
  writeln(f,'9999999         SSSSSSS           TIME CONSTANT FOR PARTICLE SPLITTING (IN SECONDS)');
  writeln(f,'900             SSSSS             SYNCHRONISATION INTERVAL OF FLEXPART (IN SECONDS)');
  writeln(f,'-5.0            CTL               FACTOR, BY WHICH TIME STEP MUST BE SMALLER THAN TL');
  writeln(f,'4               IFINE             DECREASE OF TIME STEP FOR VERTICAL MOTION BY FACTOR IFINE');
  writeln(f,'13              IOUT              1 CONC. (RESID. TIME FOR BACKWARD RUNS) OUTPUT,2 MIX. RATIO OUTPUT,3 BOTH,4 PLUME TRAJECT.,5=1+4, add 8 for netcdf output');
  writeln(f,'1               IPOUT             PARTICLE DUMP: 0 NO, 1 EVERY OUTPUT INTERVAL, 2 ONLY AT END');
  writeln(f,'1               LSUBGRID          SUBGRID TERRAIN EFFECT PARAMETERIZATION: 1 YES, 0 NO');
  writeln(f,'1               LCONVECTION       CONVECTION: 1 YES, 0 NO');
  writeln(f,'1               LAGESPECTRA       AGE SPECTRA: 1 YES, 0 NO');
  writeln(f,'0               IPIN              CONTINUE SIMULATION WITH DUMPED PARTICLE DATA: 1 YES, 0 NO');
  writeln(f,'1               IOUTPUTFOREACHREL CREATE AN OUPUT FILE FOR EACH RELEASE LOCATION: 1 YES, 0 NO');
  writeln(f,'0               IFLUX             CALCULATE FLUXES: 1 YES, 0 NO');
  writeln(f,'0               MDOMAINFILL       DOMAIN-FILLING TRAJECTORY OPTION: 1 YES, 0 NO');
  writeln(f,'1               IND_SOURCE        1=MASS UNIT , 2=MASS MIXING RATIO UNIT');
  writeln(f,'1               IND_RECEPTOR      1=MASS UNIT , 2=MASS MIXING RATIO UNIT');
  writeln(f,'0               MQUASILAG         QUASILAGRANGIAN MODE TO TRACK INDIVIDUAL PARTICLES: 1 YES, 0 NO');
  writeln(f,'0               NESTED_OUTPUT     SHALL NESTED OUTPUT BE USED? YES, 0 NO');
  writeln(f,'2               LINIT_COND        INITIAL COND. FOR BW RUNS: 0=NO,1=MASS UNIT,2=MASS MIXING RATIO UNIT');
  writeln(f,'0               SURF_ONLY         IF THIS IS SET TO 1, OUTPUT IS WRITTEN ONLY OUT FOR LOWEST LAYER');
  closefile(f);
 (*
  1. Simulation direction, 1 for forward, -1 for backward in time

  2. Beginning date and time of simulation. Must be given in format
     YYYYMMDD HHMISS, where YYYY is YEAR, MM is MONTH, DD is DAY, HH is HOUR,
     MI is MINUTE and SS is SECOND. Current version utilizes UTC.

  3. Ending date and time of simulation. Same format as 3.

  4. Average concentrations are calculated every SSSSS seconds.

  5. The average concentrations are time averages of SSSSS seconds
     duration. If SSSSS is 0, instantaneous concentrations are outputted.

  6. The concentrations are sampled every SSSSS seconds to calculate the time
     average concentration. This period must be shorter than the averaging time.

  7. Time constant for particle splitting. Particles are split into two
     after SSSSS seconds, 2xSSSSS seconds, 4xSSSSS seconds, and so on.

  8. All processes are synchronized with this time interval (lsynctime).
     Therefore, all other time constants must be multiples of this value.
     Output interval and time average of output must be at least twice lsynctime.

  9. CTL must be >1 for time steps shorter than the  Lagrangian time scale
     If CTL<0, a purely random walk simulation is done

  10.IFINE=Reduction factor for time step used for vertical wind

  11.IOUT determines how the output shall be made: concentration
     (ng/m3, Bq/m3), mixing ratio (pptv), or both, or plume trajectory mode,
     or concentration + plume trajectory mode.
     In plume trajectory mode, output is in the form of average trajectories.

  12.IPOUT determines whether particle positions are outputted (in addition
     to the gridded concentrations or mixing ratios) or not.
     0=no output, 1 output every output interval, 2 only at end of the
     simulation

  13.Switch on/off subgridscale terrain parameterization (increase of
     mixing heights due to subgridscale orographic variations)

  14.Switch on/off the convection parameterization

  15.Switch on/off the calculation of age spectra: if yes, the file AGECLASSES
     must be available

  16. If IPIN=1, a file "partposit_end" from a previous run must be available in
      the output directory. Particle positions are read in and previous simulation
      is continued. If IPIN=0, no particles from a previous run are used

  17. IF IOUTPUTFOREACHRELEASE is set to 1, one output field for each location
      in the RLEASE file is created. For backward calculation this should be
      set to 1. For forward calculation both possibilities are applicable.

  18. If IFLUX is set to 1, fluxes of each species through each of the output
      boxes are calculated. Six fluxes, corresponding to northward, southward,
      eastward, westward, upward and downward are calculated for each grid cell of
      the output grid. The control surfaces are placed in the middle of each
      output grid cell. If IFLUX is set to 0, no fluxes are determined.

  19. If MDOMAINFILL is set to 1, the first box specified in file RELEASES is used
      as the domain where domain-filling trajectory calculations are to be done.
      Particles are initialized uniformly distributed (according to the air mass
      distribution) in that domain at the beginning of the simulation, and are
      created at the boundaries throughout the simulation period.

  20. IND_SOURCE switches between different units for concentrations at the source
      NOTE that in backward simulations the release of computational particles
      takes place at the "receptor" and the sampling of particles at the "source".
            1=mass units (for bwd-runs = concentration)
            2=mass mixing ratio units
  21. IND_RECEPTOR switches between different units for concentrations at the receptor
            1=mass units (concentrations)
            2=mass mixing ratio units

  22. MQUASILAG indicates whether particles shall be numbered consecutively (1) or
      with their release location number (0). The first option allows tracking of
      individual particles using the partposit output files

  23. NESTED_OUTPUT decides whether model output shall be made also for a nested
      output field (normally with higher resolution)

  24. LINIT_COND determines whether, for backward runs only, the sensitivity to initial
      conditions shall be calculated and written to output files
      0=no output, 1 or 2 determines in which units the initial conditions are provided.

  25. SURF_ONLY: When set to 1, concentration/emission sensitivity is written out only
      for the surface layer; useful for instance when only footprint emission sensitivity is needed
      but initial conditions are needed on a full 3-D grid
*)
end;



{ TMyApplication }

procedure TMyApplication.DoRun;
var
  s,
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('hsenfrpimo', 'help');
  if ErrorMsg<>'' then
  begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then
  begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  if HasOption('s') then
  begin
    StartDate:=StrtoDate(GetOptionValue('s'),'YYYY-MM-DD');
  end
  else
    StartDate:=EncodeDate(2012,1,1);
  if HasOption('e') then
  begin
    EndDate:=StrtoDate(GetOptionValue('e'),'YYYY-MM-DD');
  end
  else
    EndDate:=EncodeDate(2012,3,31);
  EndDate:=EndDate+1;
  if HasOption('n') then
  begin
    NrParticles:=StrtoInt(GetOptionValue('n'));
  end
  else
    NrParticles:=60000;
  if HasOption('f') then
  begin
    StationFile:=GetOptionValue('f');
  end
  else
    StationFile:='candidate_sites_v2.txt';
  if HasOption('r') then
  begin
    s:=GetOptionValue('r');
    StationNr:=StrtoInt(s);
  end
  else
    StationNr:=1;
  if HasOption('p') then
  begin
    SpinUpTime:=StrtoInt(GetOptionValue('p'));
  end
  else
    SpinupTime:=10;
  if HasOption('i') then
  begin
    OutIntervalHr:=StrtoInt(GetOptionValue('i'));
  end
  else
    OutIntervalHr:=3;

  if HasOption('o') then
  begin
    outputpath:=GetOptionValue('o');
    try
      MkDir(outputpath)
    except
      writeln('Error creating ',outputpath);
    end;
  end
  else
    outputpath:='/output/';

  if HasOption('m') then
    meteopath:=GetOptionValue('m')
  else
    meteopath:='/meteo/';

  ReadStationList(StationFile);
  WriteCommand(StartDate-SpinUpTime,EndDate,OutInterValHr);
  WriteReleases(StartDate,EndDate,OutInterValHr/24,12,NrParticles,StationNr);
  Writepathnames(meteopath,outputpath);

  // stop program loop
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h -s StartDate -e EndDate -n NrParticles -r Station -f stationlistfile -p spinuptimedays -i OutputIntervalHour -o OutputPath -m MeteoPath');
  writeln('        Defaults: 2012-01-01 2012-03-31 60000 1 candidate_sites_v2.txt 10 3 /output /meteo');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='FlexpartSet';
  Application.Run;
  Application.Free;
end.

