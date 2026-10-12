import numpy as np
import xarray as xr


ds1 = xr.open_dataset("/public/data2/model/fcai/data0/topography/topo_2x2.nc")
topo0 = ds1.topo.loc[-90:90,:]
lat = topo0.lat; lon = topo0.lon



##--##--##--##--                     --##--##--##--##
##--##--##--##--  1982-2024, 43 yrs  --##--##--##--##
##--##--##--##--                     --##--##--##--##
for iyear_start in range(1):
  print("                   ")
  print('iyear_start = ',iyear_start+1982)
  print("                   ")
  networks0 = np.zeros((90,180, 90,180), dtype=np.float32)
    # print(networks0.size * networks0.itemsize / 1073741824.0)

  for iyear in range(20):
    print('iyear = ',iyear_start+iyear+1982)
    ##--##--##--##--  read extreme events   --##--##--##--##
    ds1 = xr.open_dataset("/public/home/fcai/extreme5_degree/42_marine_heatwaves/1_threshold/top10_extremes/OISST_top10extremes_moving20yrs_"+str(iyear_start+1982)+"_"+str(iyear_start+1982+19)+".nc")
    hw = ds1.sst90[iyear,:,:,:]
    hw_lag = ds1.sst90[iyear,:,:,:]



    ##--##--##--##--  network  --##--##--##--##
    networks_yearly = np.zeros((np.shape(hw)[1],np.shape(hw)[2], np.shape(hw_lag)[1],np.shape(hw_lag)[2]), dtype=np.float32)
    for alat in range(np.shape(hw_lag)[1]):
      if alat%10==0: print('alat = ',alat)
      for alon in range(np.shape(hw_lag)[2]):

        t_True_3D = np.tile(hw_lag[:,alat,alon], (np.shape(hw)[1],np.shape(hw)[2],1)).transpose(2,0,1)   ## day|92* lat|45* lon|180
        
        concurrent_days = np.sum(t_True_3D[:,:,:]+hw[:,:,:]==2,axis=0)
        networks_yearly[:,:,alat,alon] = concurrent_days

        del  t_True_3D, concurrent_days
    del hw, hw_lag
    networks0 = networks0 + networks_yearly
    print("networks ",np.nanmax(networks0), np.nanmin(networks0))
    del networks_yearly





  ##--##--##--##--  to nc file  --##--##--##--##
  networks_array0= xr.DataArray(data=networks0.data, dims=['lat1', 'lon1', 'lat2', 'lon2'],
                                  coords={'lat1':lat.data,'lon1':lon.data,
                                          'lat2':lat.data,'lon2':lon.data})
  ds0 = xr.Dataset(data_vars=dict(networks0=networks_array0))
  ds0.to_netcdf("/public/home/fcai/extreme5_degree/42_marine_heatwaves/2_networks/heat90_heat90_lag0/network_heat90_heat90_lag0_"+str(iyear_start+1982)+"_"+str(iyear_start+1982+19)+".nc")
  ds0.close()
  del networks0, networks_array0




