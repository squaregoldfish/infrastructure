import netCDF4 as cdf
import numpy as np
import datetime as dt
import os
import pandas as pd

mask_north = np.zeros((180,360))
mask_north[120:,:] = 1
mask_south = np.zeros((180,360))
mask_south[:60,:] = 1
mask_tropics = np.zeros((180,360))
mask_tropics[60:120,:] = 1
mask_global = np.zeros((180,360))
mask_global[:] = 1

mask=mask_global

fac1=12./1.e12
fac2=86400.*365.*12./1.e15

filename_MACC='../data/MACC_v14r2_allmonths.nc'
filename_CT='../data/CTE2015_monthly.nc'
filename_Jena='../data/Jena_s99_v3.7_monthly.nc'
filename_Ocean='../data/GCP_Ocean_results.csv'

#MACC
f_MACC = cdf.Dataset(filename_MACC)
dates_MACC     = []
bio_prior_MACC = []
bio_poste_MACC = []
oce_prior_MACC = []
oce_poste_MACC = []
ff_MACC        = []
for m in range(420):
    dates_MACC.append(dt.datetime(2000,1,1,0,0,0)+dt.timedelta(days=f_MACC.variables['time'][m]))
    bio_prior_MACC.append((f_MACC.variables['flux_apri_bio'][m,:,:]*f_MACC.variables['area'][:]*fac1).sum())
    oce_prior_MACC.append((f_MACC.variables['flux_apri_ocean'][m,:,:]*f_MACC.variables['area'][:]*fac1).sum())
    bio_poste_MACC.append((f_MACC.variables['flux_apos_bio'][m,:,:]*f_MACC.variables['area'][:]*fac1).sum())
    oce_poste_MACC.append((f_MACC.variables['flux_apos_ocean'][m,:,:]*f_MACC.variables['area'][:]*fac1).sum())
    ff_MACC.append((f_MACC.variables['flux_foss'][m,:,:]*f_MACC.variables['area'][:]*fac1).sum())
dates_MACC     = np.array(dates_MACC)
bio_prior_MACC = np.array(bio_prior_MACC)
oce_prior_MACC = np.array(oce_prior_MACC)
bio_poste_MACC = np.array(bio_poste_MACC)
oce_poste_MACC = np.array(oce_poste_MACC)
ff_MACC        = np.array(ff_MACC)

# Jena
f_Jena=cdf.Dataset(filename_Jena)
dates_Jena=f_Jena.variables['mtime'][:]
dates_Jena=[dt.datetime(2000,1,1,0,0,0) + dt.timedelta(seconds=s.item()) for s in dates_Jena]
area_Jena=f_Jena.variables['dxyp'][:]
bio_poste_Jena=f_Jena.variables['co2flux_land'][:]
oce_poste_Jena=f_Jena.variables['co2flux_ocean'][:]
ff_Jena=f_Jena.variables['co2flux_subt'][:]
bio_poste_Jena=(bio_poste_Jena).sum(axis=1).sum(axis=1)
oce_poste_Jena=(oce_poste_Jena).sum(axis=1).sum(axis=1)
ff_Jena=(ff_Jena).sum(axis=1).sum(axis=1)

#CTE2015
f_CTE = cdf.Dataset(filename_CT)
dates_CTE     = []
bio_prior_CTE = []
bio_poste_CTE = []
oce_prior_CTE = []
oce_poste_CTE = []
ff_CTE        = []
fire_CTE      = []
for m in range(168):
    bio_prior_CTE.append((f_CTE.variables['bio_flux_prior'][m,:,:]*f_CTE.variables['cell_area'][:]*fac2).sum())
    bio_poste_CTE.append((f_CTE.variables['bio_flux_opt'][m,:,:]*f_CTE.variables['cell_area'][:]*fac2).sum())
    oce_prior_CTE.append((f_CTE.variables['ocn_flux_prior'][m,:,:]*f_CTE.variables['cell_area'][:]*fac2).sum())
    oce_poste_CTE.append((f_CTE.variables['ocn_flux_opt'][m,:,:]*f_CTE.variables['cell_area'][:]*fac2).sum())
    fire_CTE.append((f_CTE.variables['fire_flux_imp'][m,:,:]*f_CTE.variables['cell_area'][:]*fac2).sum())
    ff_CTE.append((f_CTE.variables['fossil_flux_imp'][m,:,:]*f_CTE.variables['cell_area'][:]*fac2).sum())
    dates_CTE.append(dt.datetime(2000,1,1,0,0,0)+dt.timedelta(days=f_CTE.variables['date'][m]))
dates_CTE     = np.array(dates_CTE)
bio_prior_CTE = np.array(bio_prior_CTE)
bio_poste_CTE = np.array(bio_poste_CTE)
oce_prior_CTE = np.array(oce_prior_CTE)
oce_poste_CTE = np.array(oce_poste_CTE)
ff_CTE        = np.array(ff_CTE)
fire_CTE      = np.array(fire_CTE)

d_MACC = {'ff_MACC' : (ff_MACC),'oce_poste_MACC' : (oce_poste_MACC),'bio_poste_MACC' : (bio_poste_MACC)}
df_MACC = pd.DataFrame(d_MACC,index=dates_MACC)
d_Jena = {'ff_Jena' : (ff_Jena),'oce_poste_Jena' : (oce_poste_Jena),'bio_poste_Jena' : (bio_poste_Jena)}
df_Jena = pd.DataFrame(d_Jena,index=dates_Jena)
d_CTE = {'ff_CTE' : (ff_CTE),'oce_poste_CTE' : (oce_poste_CTE),'bio_poste_CTE' : (bio_poste_CTE)}
df_CTE = pd.DataFrame(d_CTE,index=dates_CTE)

df_Jena_yr=df_Jena.resample('A',how='mean',label='left',loffset='183d')
df_MACC_yr=df_MACC.resample('A',how='mean',label='left',loffset='183d')
df_CTE_yr=df_CTE.resample('A',how='mean',label='left',loffset='183d')

dfgcp = pd.DataFrame.from_csv(filename_Ocean)

def read_My_Model(MM_X=None,MM_Y=None):
    global MMX, MMY
    MMX = [dt.datetime(i,7,1,0,0,0) for i in MM_X]
    MMY = MM_Y

def fig_ff(Jena=False, MACC=False, CTE=False, Temporal_Resolution='Yearly'): 
    import matplotlib.pyplot as plt
    plt.figure(figsize=(10,7))
    if Temporal_Resolution == 'Monthly':
        if Jena: plt.plot(df_Jena.index,df_Jena.ff_Jena,label='Jena',linewidth=2)
        if MACC: plt.plot(df_MACC.index,df_MACC.ff_MACC,label='MACC',linewidth=2)
        if CTE: plt.plot(df_CTE.index,df_CTE.ff_CTE,label='CTE2015',linewidth=2)
    if Temporal_Resolution == 'Yearly':
        if Jena: plt.plot(df_Jena_yr.index,df_Jena_yr.ff_Jena,label='Jena',linewidth=2)
        if MACC: plt.plot(df_MACC_yr.index,df_MACC_yr.ff_MACC,label='MACC',linewidth=2)
        if CTE: plt.plot(df_CTE_yr.index,df_CTE_yr.ff_CTE,label='CTE2015',linewidth=2)
    plt.ylim(6,11)
    plt.xlim(dt.datetime(2000,1,1),dt.datetime(2015,1,1))
    if MACC or Jena or CTE: plt.legend(loc='best',fontsize=16)
    if Temporal_Resolution == 'Monthly':
        plt.title('Global monthly fossil fuel emissions',size=20)
    elif Temporal_Resolution == 'Yearly':
        plt.title('Global yearly fossil fuel emissions',size=20)
    plt.ylabel('Fossil fuel emissions [PgC/yr]', size=16, labelpad=20)
    plt.show()

def fig_bio(Jena=False, MACC=False, CTE=False, Temporal_Resolution='Monthly'): 
    import matplotlib.pyplot as plt
    plt.figure(figsize=(10,7))
    if Temporal_Resolution == 'Monthly':
        if Jena: plt.plot(df_Jena.index,df_Jena.bio_poste_Jena,label='Jena',linewidth=2)
        if MACC: plt.plot(df_MACC.index,df_MACC.bio_poste_MACC,label='MACC',linewidth=2)
        if CTE: plt.plot(df_CTE.index,df_CTE.bio_poste_CTE,label='CTE2015',linewidth=2)
    if Temporal_Resolution == 'Yearly':
        if Jena: plt.plot(df_Jena_yr.index,df_Jena_yr.bio_poste_Jena,label='Jena',linewidth=2)
        if MACC: plt.plot(df_MACC_yr.index,df_MACC_yr.bio_poste_MACC,label='MACC',linewidth=2)
        if CTE: plt.plot(df_CTE_yr.index,df_CTE_yr.bio_poste_CTE,label='CTE2015',linewidth=2)
    plt.xlim(dt.datetime(2000,1,1),dt.datetime(2015,1,1))
    if MACC or Jena or CTE: plt.legend(loc='best',fontsize=16)
    if Temporal_Resolution == 'Monthly':
        plt.title('Global monthly biosphere fluxes',size=20)
    elif Temporal_Resolution == 'Yearly':
        plt.title('Global yearly biosphere fluxes',size=20)
    plt.ylabel('Biosphere fluxes [PgC/yr]', size=16, labelpad=20)
    plt.show()

def fig_oce(Jena=False, MACC=False, CTE=False, MyModel=False, Temporal_Resolution='Monthly'): 
    import matplotlib.pyplot as plt
    import numpy as np
    plt.figure(figsize=(10,7))
    if Temporal_Resolution == 'Monthly':
        if Jena: plt.plot(df_Jena.index,df_Jena.oce_poste_Jena,label='Jena',linewidth=2)
        if MACC: plt.plot(df_MACC.index,df_MACC.oce_poste_MACC,label='MACC',linewidth=2)
        if CTE: plt.plot(df_CTE.index,df_CTE.oce_poste_CTE,label='CTE2015',linewidth=2)
    if Temporal_Resolution == 'Yearly':
        if Jena: plt.plot(df_Jena_yr.index,df_Jena_yr.oce_poste_Jena,label='Jena',linewidth=2)
        if MACC: plt.plot(df_MACC_yr.index,df_MACC_yr.oce_poste_MACC,label='MACC',linewidth=2)
        if CTE: plt.plot(df_CTE_yr.index,df_CTE_yr.oce_poste_CTE,label='CTE2015',linewidth=2)
    if MyModel and len(MMX)>0 and len(MMY)>0: 
        #plt.plot(dfgcp['GCP'].index,-(dfgcp['GCP']),color='black',label='MyModel',linewidth=3)
        plt.plot(MMX,MMY,color='black',label='MyModel',linewidth=3)
    plt.xlim(dt.datetime(2000,1,1),dt.datetime(2015,1,1))
    if MACC or Jena or CTE or MyModel: plt.legend(loc='best',fontsize=16)
    if Temporal_Resolution == 'Monthly':
        plt.title('Global monthly ocean fluxes',size=20)
    elif Temporal_Resolution == 'Yearly':
        plt.title('Global yearly ocean fluxes',size=20)
    plt.ylabel('Ocean fluxes [PgC/yr]', size=16, labelpad=20)
    plt.show()

def fig_oce_gcp(Data_Based_Products=False,Jena=False, MACC=False, CTE=False): 
    import matplotlib.pyplot as plt
    plt.figure(figsize=(10,7))
    plt.xlim(dt.datetime(1958,1,1),dt.datetime(2015,1,1))
    plt.ylim(0,4)
    plt.yticks(np.arange(0,5,1),fontsize = 16)
    plt.fill_between([dt.datetime(1955,1,1),dt.datetime(2017,1,1)],-2,20,color='lightyellow')
    for i in dfgcp:
        l=1
        rivercorr=0.0
        lab=i
        show = True
        if i == 'GCP':
            c='black'
            l=2
        elif i == 'Landschutzer':
            c='purple'
            rivercorr=0.45
            l=2
            show = Data_Based_Products
        elif i == 'Rodenbeck': 
            c='salmon'
            rivercorr=0.45
            l=2
            show = Data_Based_Products
        else: 
            c='dodgerblue'
            lab=''
        if i == 'CSIRO': lab='Individual ocean models'
        if show: plt.plot(dfgcp[i].index,(dfgcp[i]+rivercorr),color=c,linewidth=l,label=lab)
    if MACC: 
        oceyr_MACC=df_MACC.oce_poste_MACC.resample('A',how='mean',label='left',loffset='183d')
        plt.plot(oceyr_MACC.index,(-oceyr_MACC+0.45),label='MACC',linewidth=2)  
    if Jena: 
        oceyr_Jena=df_Jena.oce_poste_Jena.resample('A',how='mean',label='left',loffset='183d')
        plt.plot(oceyr_Jena[1:-1].index,(-oceyr_Jena[1:-1]+0.45),label='Jena',linewidth=2)
    if CTE: 
        oceyr_CTE=df_CTE.oce_poste_CTE.resample('A',how='mean',label='left',loffset='183d')
        plt.plot(oceyr_CTE.index,(-oceyr_CTE+0.45),label='CTE2015',linewidth=2)
    plt.fill_between(dfgcp['GCP'].index,(dfgcp['GCP']-0.5),(dfgcp['GCP']+0.5),color='lightgrey')
    plt.ylabel('CO2  (GtC/yr)',fontsize=18,labelpad=20)
    plt.legend(loc='best',ncol=3,fontsize=14)
    plt.title('Comparison GCP ocean models, data products and inverse models',fontsize=20)
    plt.show()


