import numpy as np
import xarray as xr

EP_lat1 = -10
EP_lat2 = 10
EP_lon1 = 215
EP_lon2 = 280
EP_lat1_ = int((-9 + 89) / 2)
EP_lat2_ = int((9 + 89) / 2)
EP_lon1_ = int((215 - 1) / 2)
EP_lon2_ = int((279 - 1) / 2)

# 读取地形并及时关闭
with xr.open_dataset("topography/topo_2x2.nc") as ds_topo:
    topo0 = ds_topo.topo.loc[-90:90, :]
    lat = topo0.lat.values
    lon = topo0.lon.values
    topo_cep = ds_topo.topo.loc[EP_lat1:EP_lat2, EP_lon1:EP_lon2]
    lat_cep = topo_cep.lat.values
    lon_cep = topo_cep.lon.values

shape_lat_cep = topo_cep.shape[0]
shape_lon_cep = topo_cep.shape[1]

# 固定文件在循环外打开
ds_lag0 = xr.open_dataset("tos_for13marineheatwaves/ssp370_top10extremes_2078_2099_lag0.nc")

for ilag in range(0, 360 + 180, 180):
    print('ilag = ', ilag)
    
    # 动态打开当前 ilag 文件
    ds_lag = xr.open_dataset(f"tos_for13marineheatwaves/ssp370_top10extremes_2078_2099_lag{ilag}.nc")

    for imodel in range(0, 4):
        print(f"\nimodel = {imodel}\n")
        networks0 = np.zeros((shape_lat_cep, shape_lon_cep, 90, 180), dtype=np.float32)

        for iyear in range(20):
            print('iyear = ', iyear + 2004)

            # 提取切片并直接转为 numpy 数组 (.values)，断开延迟计算
            t_slice = slice(iyear * 365, (iyear + 1) * 365)
            hw0 = ds_lag0.sst90[imodel, t_slice, EP_lat1_:EP_lat2_ + 1, EP_lon1_:EP_lon2_ + 1].values
            hw = ds_lag.sst90[imodel, t_slice, :, :].values

            # 计算 coincidence network（利用 NumPy 广播，省去 np.tile 和内存反复申请）
            for alat in range(hw0.shape[1]):
                for alon in range(hw0.shape[2]):
                    # hw0[:, alat, alon, None, None] 形状为 (365, 1, 1)，可直接与 (365, 90, 180) 的 hw 广播相加
                    concurrent_days = np.sum((hw0[:, alat, alon, None, None] + hw) == 2, axis=0)
                    networks0[alat, alon, :, :] += concurrent_days

            print("network ", np.max(networks0), np.min(networks0))

        # 保存结果
        networks_array0 = xr.DataArray(
            data=networks0,
            dims=['lat1', 'lon1', 'lat2', 'lon2'],
            coords={'lat1': lat_cep, 'lon1': lon_cep, 'lat2': lat, 'lon2': lon}
        )
        ds_out = xr.Dataset(data_vars=dict(networks0=networks_array0))
        out_path = f"3_cmip6_networks_CEP/ssp370_2078_2099_CEP_lag{ilag}/network_heat90_heat90_ssp370_2078_2099_CEP_lag{ilag}_model{imodel}.nc"
        ds_out.to_netcdf(out_path)
        ds_out.close()

    # 当前 lag 处理完毕，关闭该文件
    ds_lag.close()

# 全部完成，关闭 lag0 文件
ds_lag0.close()

