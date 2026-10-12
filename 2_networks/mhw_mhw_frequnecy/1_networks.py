import numpy as np
import xarray as xr


ds1 = xr.open_dataset("topography/topo_2x2.nc")
topo0 = ds1.topo.loc[-90:90,:]
lat = topo0.lat; lon = topo0.lon



##--##--##--##--                     --##--##--##--##
##--##--##--##--  1982-2024, 43 yrs  --##--##--##--##
##--##--##--##--                     --##--##--##--##
for ilag in range(0,750,30):
  print('ilag = ',ilag)
  for iyear in range(0,24):
    print("                   ")
    print('iyear = ',iyear+1982)
    print("                   ")
    


    ##--##--##--##--  read extreme events   --##--##--##--##
    ds1 = xr.open_dataset("1_threshold/OISST_marine_heatwave_1982_2024_lag0.nc")
    hw = np.nansum(np.nansum(ds1.heatwave_day[iyear:iyear+20,:,:,:],axis=1),axis=0)
    hw = np.sqrt(hw)

    ds2 = xr.open_dataset("1_threshold/OISST_marine_heatwave_1982_2024_lag"+str(ilag)+".nc")
    hw_lag = np.nansum(np.nansum(ds2.heatwave_day[iyear:iyear+20,:,:,:],axis=1),axis=0)
    hw_lag = np.sqrt(hw_lag)




    ##--##--##--##--  network  --##--##--##--##
    networks0 = np.zeros((np.shape(hw)[0],np.shape(hw)[1], np.shape(hw_lag)[0],np.shape(hw_lag)[1]), dtype=np.float32)
    # print(networks0.size * networks0.itemsize / 1073741824.0)

    for alat in range(np.shape(hw)[0]):
      print('alat = ',alat)
      for alon in range(np.shape(hw)[1]):

        a_day = hw[alat,alon]
        networks0[alat,alon,:,:] = a_day*hw_lag[:,:]
    del hw, hw_lag
    print("network ", np.max(networks0), np.min(networks0))




    ##--##--##--##--  to nc file  --##--##--##--##
    networks_array0= xr.DataArray(data=networks0.data, dims=['lat1', 'lon1', 'lat2', 'lon2'],
                                    coords={'lat1':lat.data,'lon1':lon.data,
                                            'lat2':lat.data,'lon2':lon.data})
    ds0 = xr.Dataset(data_vars=dict(networks0=networks_array0))
    ds0.to_netcdf("2_networks/mhw_mhw_frequency_sqrt/lag"+str(ilag)+"/network_mhw_mhw_frequency_sqrt_lag"+str(ilag)+"_"+str(iyear+1982)+"_"+str(iyear+1982+19)+".nc")
    ds0.close()
    del networks0, networks_array0




