

import numpy as np
import xarray as xr

##--##--##--##--  read OISST  --##--##--##--##
ds0 = xr.open_dataset("OISST_daily2x2/OISST_1982.nc")
t0 = ds0.sst.loc[:,-90:90,:]
print(np.shape(t0))
t = np.zeros((30, 365+14, np.shape(t0)[1],np.shape(t0)[2]))



for iyear in range(30):
  print('iyear = ',iyear+1991)    ##   1991-2010, for heatwave threshold
  ds1 = xr.open_dataset("OISST_daily2x2/OISST_"+str(iyear+1991)+".nc")
  t[iyear,0:7,:,:] = ds1.sst[365-7:365,:,:]    ##  +- 7 days
  t[iyear,7:7+365,:,:] = ds1.sst[:,:,:]
  t[iyear,365+7:365+14,:,:] = ds1.sst[0:7,:,:]
  ds1.close()




##--##--##--##--  150day moving, 90th percentile  --##--##--##--##
t_15days = np.zeros((30*15, 365, np.shape(t0)[1],np.shape(t0)[2]))
print(t_15days.size * t_15days.itemsize / 1073741824)  ## G
for iday in range(365):
  if iday%30==0: print('iday = ',iday)
  for lag in range(15):
    t_15days[30*lag:30*lag+30,iday,:,:] = t[:,iday+lag,:,:]

t_th90 = np.percentile(t_15days, 90, axis=0)
print(np.shape(t_th90),"  ",np.nanmin(t_th90),"  ",np.nanmax(t_th90))




##--##--##--##--  to nc file  --##--##--##--##
sst_th90= xr.DataArray(data=t_th90.data, dims=['day','lat','lon'],
                      coords={'day':np.arange(1,366,1),
                              'lat':t0.lat.data, 'lon':t0.lon.data})
ds2 = xr.Dataset(data_vars=dict(sst_th90=sst_th90))
ds2.to_netcdf("1_threshold/OISST_th90_1991_2020.nc")
ds2.close()








