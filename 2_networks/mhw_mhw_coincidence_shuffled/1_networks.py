import numpy as np
import xarray as xr
ds1 = xr.open_dataset("topography/topo_2x2.nc")
topo0 = ds1.topo.loc[-90:90,:]
lat = topo0.lat; lon = topo0.lon





def shuffle_by_blocks_1d(arr):
    """
    0 完全随机打乱（离散化），连续的 1 保持原样作为整体块，
    最后将所有的 0 和 1 块随机混合打乱。
    """
    arr = np.asarray(arr)
    blocks = []

    # 找出连续 1 的区间
    is_one = (arr == 1).astype(int)
    padded = np.concatenate(([0], is_one, [0]))
    diff = np.diff(padded)

    starts = np.where(diff == 1)[0]
    ends = np.where(diff == -1)[0]

    # 收集所有的“1 块”和单个“0”
    last_idx = 0
    for start, end in zip(starts, ends):
        zeros_count = start - last_idx
        if zeros_count > 0:
            blocks.extend([np.array([0])] * zeros_count)

        blocks.append(arr[start:end])
        last_idx = end

    # 处理结尾剩余的 0
    if last_idx < len(arr):
        zeros_count = len(arr) - last_idx
        blocks.extend([np.array([0])] * zeros_count)

    # 随机打乱所有块
    np.random.shuffle(blocks)

    # 拼接回一维数组
    return np.concatenate(blocks) if len(blocks) > 0 else arr


def shuffle_blocks_3d(data):

    data = np.asarray(data)
    shape = data.shape

    year_dim, day_dim, lat_dim, lon_dim = shape
    shuffled_data = np.zeros([year_dim*day_dim, lat_dim, lon_dim])

    for ilat in range(lat_dim):
        for ilon in range(lon_dim):
            matrix_2d = data[:, :, ilat, ilon]

            # 展平成一维
            ts_combined = matrix_2d.reshape(-1)

            # 区块打乱
            shuffled_ts = shuffle_by_blocks_1d(ts_combined)

            # # 恢复为二维
            # shuffled_matrix = shuffled_ts.reshape(time_dim, lev_dim)

            # 写回结果
            shuffled_data[:, ilat, ilon] = shuffled_ts

    return shuffled_data






##--##--##--##--                     --##--##--##--##
##--##--##--##--  1982-2024, 43 yrs  --##--##--##--##
##--##--##--##--                     --##--##--##--##
for ilag in range(720,750,60):
  print('ilag = ',ilag)
  for iyear in range(2,5):
    print("                   ")
    print('iyear = ',iyear+1982)
    print("                   ")
    

    ##--##--##--##--  read extreme events   --##--##--##--##
    ds1 = xr.open_dataset("1_threshold/OISST_marine_heatwave_1982_2024_lag0.nc")
    hw0 = ds1.heatwave_day[iyear:iyear+20,:,:,:]
    hw = shuffle_blocks_3d(hw0); del hw0
    ds2 = xr.open_dataset("1_threshold/OISST_marine_heatwave_1982_2024_lag"+str(ilag)+".nc")
    hw_lag0 = ds2.heatwave_day[iyear:iyear+20,:,:,:]
    hw_lag = shuffle_blocks_3d(hw_lag0); del hw_lag0




    ##--##--##--##--  network  --##--##--##--##
    networks0 = np.zeros((np.shape(hw)[1],np.shape(hw)[2], np.shape(hw_lag)[1],np.shape(hw_lag)[2]), dtype=np.float32)
    # print(networks0.size * networks0.itemsize / 1073741824.0)

    for alat in range(np.shape(hw_lag)[1]):
      print('alat = ',alat)
      for alon in range(np.shape(hw_lag)[2]):

        t_True_3D = np.tile(hw_lag[:,alat,alon], (np.shape(hw)[1],np.shape(hw)[2],1)).transpose(2,0,1)   ## day|365* lat|45* lon|180
        
        concurrent_days = np.sum(t_True_3D[:,:,:]+hw[:,:,:]==2,axis=0)
        networks0[:,:,alat,alon] = concurrent_days

        del  t_True_3D, concurrent_days
    del hw, hw_lag
    print("network ", np.max(networks0), np.min(networks0))




    ##--##--##--##--  to nc file  --##--##--##--##
    networks_array0= xr.DataArray(data=networks0.data, dims=['lat1', 'lon1', 'lat2', 'lon2'],
                                    coords={'lat1':lat.data,'lon1':lon.data,
                                            'lat2':lat.data,'lon2':lon.data})
    ds0 = xr.Dataset(data_vars=dict(networks0=networks_array0))
    ds0.to_netcdf("2_networks/mhw_mhw_coincidence_shuffled/lag"+str(ilag)+"/network_mhw_mhw_shuffled_lag"+str(ilag)+"_"+str(iyear+1982)+"_"+str(iyear+1982+19)+".nc")
    ds0.close()
    del networks0, networks_array0




