

import numpy as np
import xarray as xr

##--##--##--##--  read OISST  --##--##--##--##
ds0 = xr.open_dataset("OISST_daily2x2/OISST_1982.nc")
t0 = ds0.sst.loc[:,-90:90,:]
lat = t0.lat
lon = t0.lon
print(np.shape(t0))
t = np.zeros((44, 365, np.shape(t0)[1],np.shape(t0)[2]))


for iyear in range(44):
  print('iyear = ',iyear+1982)    ##   1991-2010, for heatwave threshold
  ds1 = xr.open_dataset("OISST_daily2x2/OISST_"+str(iyear+1982)+".nc")
  t[iyear,:,:,:] = ds1.sst.loc[:,-90:90,:]
  ds1.close()




##--##--##--##--  read 90th percentile  --##--##--##--##
ds1 = xr.open_dataset("1_threshold/OISST_th90_1991_2020.nc")
t_th90 = ds1.sst_th90




##--##--##--##--  heatwaves: > 90th, >= 3days  --##--##--##--##
t_True = np.zeros((44, 365, np.shape(t0)[1],np.shape(t0)[2]), dtype=np.float32)
t_True[:,:,:,:] = np.array(t) > np.array(t_th90)
del t; print("Heat days",np.sum(t_True), np.size(t_True))
t_True_3D = np.zeros((44*365, np.shape(t0)[1],np.shape(t0)[2]), dtype=np.float32)
for iyear in range(44):
  t_True_3D[iyear*365:iyear*365+365,:,:] = t_True[iyear,:,:,:]
del t_True


def keep_consecutive_five(t_in):
    
    ## 输入: t_True (time, lat, lon), 由0/1组成; 输出: t_out (time, lat, lon), 只有连续≥5天的1被保留
    t_out = np.zeros_like(t_in)
    time_len = t_in.shape[0]

    # 使用滑动窗口求和：5天连续窗口内求和, 卷积实现时间方向上的滑动和
    kernel = np.ones(5, dtype=int)
    conv = np.apply_along_axis(lambda m: np.convolve(m, kernel, mode='same'), axis=0, arr=t_in)

    # 当某天处于连续≥5天的1中，则该位置的滑动和 >=5
    t_out[conv >= 5] = 1
    return t_out

t_True2_3D = keep_consecutive_five(t_True_3D)

t_True2 = np.zeros((44, 365, np.shape(t0)[1],np.shape(t0)[2]), dtype=np.float32)
for iyear in range(44):
  t_True2[iyear,:,:,:] = t_True2_3D[iyear*365:iyear*365+365,:,:]
del t_True_3D; print("Heat days",np.sum(t_True2), np.size(t_True2))



heatwave_day = np.zeros((44, 365, np.shape(t0)[1],np.shape(t0)[2]), dtype=np.float32)
# for iyear in range(46):
heatwave_day[np.where(t_True2==True)] = 1.0
del t_True2; print("Heat days",np.sum(heatwave_day), np.size(heatwave_day))



##--##--##--##--  to nc file  --##--##--##--##
heatwave_day_array = xr.DataArray(data=heatwave_day.data, dims=['year', 'day', 'lat', 'lon'],
                                coords={'year':np.linspace(1982,2025,44),'day':np.linspace(1,365,365), 'lat':lat.data, 'lon':lon.data})


ds0 = xr.Dataset(data_vars=dict(heatwave_day=heatwave_day_array))
ds0.to_netcdf("1_threshold/OISST_marine_heatwave_1982_2025.nc")
ds0.close()






