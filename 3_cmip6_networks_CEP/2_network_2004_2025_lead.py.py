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

# 1. 读取地形并及时关闭
with xr.open_dataset("topography/topo_2x2.nc") as ds_topo:
    topo0 = ds_topo.topo.loc[-90:90, :]
    lat = topo0.lat.values
    lon = topo0.lon.values
    topo_cep = ds_topo.topo.loc[EP_lat1:EP_lat2, EP_lon1:EP_lon2]
    lat_cep = topo_cep.lat.values
    lon_cep = topo_cep.lon.values

shape_lat_cep = topo_cep.shape[0]
shape_lon_cep = topo_cep.shape[1]

# 2. 固定文件在最外层打开
ds_lag0 = xr.open_dataset("tos_for13marineheatwaves_ssp370/historical_ssp370_top10extremes_2004_2025_lag0.nc")

for ilag in range(360, 360 + 180, 180):
    print('ilag = ', ilag)
    
    # 动态打开当前 ilag 文件
    ds_lag = xr.open_dataset(f"tos_for13marineheatwaves_ssp370/historical_ssp370_top10extremes_2004_2025_lag{ilag}.nc")

    for imodel in range(0, 19):
        print(f"\nimodel = {imodel}\n")
        networks0 = np.zeros((90, 180, shape_lat_cep, shape_lon_cep), dtype=np.float32)

        for iyear in range(20):
            print('iyear = ', iyear + 2004)

            t_slice = slice(iyear * 365, (iyear + 1) * 365)
            # 一次性读入内存为 numpy 数组 (.values)
            hw0 = ds_lag0.sst90[imodel, t_slice, :, :].values
            hw = ds_lag.sst90[imodel, t_slice, EP_lat1_:EP_lat2_ + 1, EP_lon1_:EP_lon2_ + 1].values

            # 计算 coincidence network（利用 NumPy 广播，省去 np.tile 和 del）
            for alat in range(hw.shape[1]):
                for alon in range(hw.shape[2]):
                    # hw[:, alat, alon, None, None] 形状为 (365, 1, 1)，与 hw0 (365, 90, 180) 广播相加
                    concurrent_days = np.sum((hw[:, alat, alon, None, None] + hw0) == 2, axis=0)
                    networks0[:, :, alat, alon] += concurrent_days

            print("network ", np.max(networks0), np.min(networks0))

        # 保存结果并及时关闭
        networks_array0 = xr.DataArray(
            data=networks0,
            dims=['lat1', 'lon1', 'lat2', 'lon2'],
            coords={'lat1': lat, 'lon1': lon, 'lat2': lat_cep, 'lon2': lon_cep}
        )
        ds_out = xr.Dataset(data_vars=dict(networks0=networks_array0))
        out_path = f"3_cmip6_networks_CEP/ssp370_2004_2025_CEP_lead{ilag}/network_heat90_heat90_ssp370_2004_2025_CEP_lead{ilag}_model{imodel}.nc"
        ds_out.to_netcdf(out_path)
        ds_out.close()

    # 关闭当前 ilag 文件
    ds_lag.close()

# 全部完成，关闭 lag0 文件
ds_lag0.close()

