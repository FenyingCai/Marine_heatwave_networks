

import numpy as np
import xarray as xr


##--##--##--##--  read OISST  --##--##--##--##
ds0 = xr.open_dataset("OISST_daily2x2/OISST_1982.nc")
t0 = ds0.sst.loc[:,-90:90,:]
lat = t0.lat
lon = t0.lon
print(np.shape(t0))




ds1 = xr.open_dataset("1_threshold/OISST_marine_heatwave_1982_2025.nc")
hw = ds1.heatwave_day   ## 43 x 365 x lat x lon

hw_3D = np.zeros((44*365, np.shape(t0)[1],np.shape(t0)[2]), dtype=np.float32)
for iyear in range(44):
  hw_3D[iyear*365:iyear*365+365,:,:] = hw[iyear,:,:,:]



for ilag in range(390,750,30):
  print(" ilag = ",ilag)
  hw_lag_3D = hw_3D[ilag:ilag+42*365,:,:]

  hw_lag = np.zeros((42, 365, np.shape(t0)[1],np.shape(t0)[2]), dtype=np.float32)
  for iyear in range(42):
    hw_lag[iyear,:,:,:] = hw_lag_3D[iyear*365:iyear*365+365,:,:]
  del hw_lag_3D


  ##--##--##--##--  to nc file  --##--##--##--##
  heatwave_day_array = xr.DataArray(data=hw_lag.data, dims=['year', 'day', 'lat', 'lon'],
                                  coords={'year':np.linspace(1982,2023,42),'day':np.linspace(1,365,365), 'lat':lat.data, 'lon':lon.data})


  ds0 = xr.Dataset(data_vars=dict(heatwave_day=heatwave_day_array))
  ds0.to_netcdf("1_threshold/OISST_marine_heatwave_1982_2024_lag"+str(ilag)+".nc")
  ds0.close()
  del hw_lag, heatwave_day_array




