# %%
import numpy as np
import xarray as xr
import statsmodels.api as sm



##--##--##--##--##--##--   (d) Marine  heatwave  coincidence (lag)   --##--##--##--##--##--##
link_number0 = np.zeros([25,23])
Alink_strength0 = np.zeros([25,23])
ds1 = xr.open_dataset("5_analysis_gt015/fig1_degree_gt015/Link_number_lag0to720_globe_gt015.nc")
link_number0[:,:] = (ds1.link_number[:,0:23].data)
Alink_strength0[:,:] = (ds1.link_strength[:,0:23].data)


print(np.shape(Alink_strength0))
link_number = np.zeros_like(link_number0)
Alink_strength = np.zeros_like(Alink_strength0)
link_number = link_number0.copy()
Alink_strength = Alink_strength0.copy()
for i in range(25):
  link_number[i,:] = link_number[i,:] / link_number0[i,0]
  Alink_strength[i,:] = Alink_strength[i,:] / Alink_strength0[i,0]







##--##--##--##--##--##--   (a) Marine  heatwave  coincidence   --##--##--##--##--##--##
ds1 = xr.open_dataset("5_analysis_gt015/fig1_degree_gt015/Link_number_lag0to720_globe_gt015.nc")
mhw_link_number = (ds1.link_number[:,0].data)
mhw_link_strength = (ds1.link_strength[:,0].data)
mhw_average_strength = (ds1.link_strength.data) / (ds1.link_number.data)
print(mhw_link_strength)

mhw_link_number = mhw_link_number / mhw_link_number[0]
mhw_link_strength = mhw_link_strength / mhw_link_strength[0]
mhw_average_strength = mhw_average_strength / mhw_average_strength[0]
print(" (MHW) link number =  ",np.nanmax(mhw_link_number))
print(" (MHW) link strength =  ",np.nanmax(mhw_link_strength))
print(" (MHW) average strength =  ",np.nanmax(mhw_average_strength))




##--##--##--##--##--##--   (e-f) Marine  heatwave  coincidence (lag)   --##--##--##--##--##--##
link_number0 = np.zeros([25,23])
link_strength0 = np.zeros([25,23])
ds1 = xr.open_dataset("5_analysis_gt015/fig1_degree_gt015/Link_number_lag0to720_globe_gt015.nc")
link_number0[:,:] = (ds1.link_number[:,0:23].data)
link_strength0[:,:] = (ds1.link_strength[:,0:23].data)


link_number = np.zeros_like(link_number0)
link_strength = np.zeros_like(link_strength0)
link_number = link_number0.copy()
link_strength = link_strength0.copy()
for i in range(25):
  link_number[i,:] = link_number0[i,:] / link_number0[0,:]
  link_strength[i,:] = link_strength0[i,:] / link_strength0[0,:]
for i in range(25):
  link_number0[i,:] = link_number0[i,:] / link_number0[i,0]
  link_strength0[i,:] = link_strength0[i,:] / link_strength0[i,0]








x = np.linspace(1,24,24)
# %%
## Plotting Import
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.use('agg')

## Define a Map Function for plotting
def create_map(ax):
  # plt.axes( xscale="log" )
  # plt.xlim(1.0+5+4,45.0-5-5)
  # plt.ylim(0.9,20.5)
  plt.rcParams['text.usetex'] = False
  ax.spines['bottom'].set_linewidth(0.7)
  ax.spines['top'].set_linewidth(0.7)
  ax.spines['left'].set_linewidth(0.7)
  ax.spines['right'].set_linewidth(0.7)
  ax.spines['left'].set_color('black')
  ax.tick_params(axis='both', length=4.5, width=0.7, labelsize=6.5)
  ax.tick_params(axis="both", which="minor", length=3.1, width=0.6)
  return ax


##--##--##--  create figure  --##--##--##
width_in_inches = 210 / 25.4  ## A4 page
height_in_inches = 297 / 25.4
fig = plt.figure(dpi=600,figsize=(width_in_inches,height_in_inches))




ax1 = plt.axes([0.01,0.30, 0.25,0.10])
create_map(ax1)

y = np.arange(link_strength.shape[0])  # 0..12
x = np.arange(link_strength.shape[1])  # 0..23
X, Y = np.meshgrid(x, y)   # X,Y shape (13,24)

# levels = np.linspace(np.nanmin(link_strength), np.nanmax(link_strength), 21)  # 20个等值区间
# levels = np.array([1.0,2.0,3.0,4.0])
# cf = ax1.contourf(X, Y, link_strength, levels=levels, extend='both', cmap='OrRd')
# fig.colorbar(cf, ax=ax1, label='A value')



# levels = np.linspace(np.nanmin(link_strength), np.nanmax(link_strength), 21)
from matplotlib.colors import BoundaryNorm
levels = np.array([1.0,1.3,3.0,5.0,8.0,12.0,20])
# levels = np.array([1.0,1.3,3.0,5.0,10.0,15.0,20])
# cmap = plt.get_cmap("OrRd").copy()
# cmap.set_over('black')
norm = BoundaryNorm(levels, ncolors=plt.get_cmap("OrRd").N, clip=False)


cf = ax1.pcolormesh(
    x, y, Alink_strength,      # 注意：先 x 后 y
    cmap="OrRd",
    norm=norm,                 # 分档（等价于 contourf 的 levels 观感）
    shading="nearest",         # 用中心坐标时，推荐 nearest / auto
    edgecolors="none"
)

cbar = fig.colorbar(cf, ax=ax1, orientation="vertical",label="", extend="both",  pad=0.035,fraction=0.07,shrink=1.0)
for t in cbar.ax.get_yticklabels():  # 水平色标用 x, 垂直色标用 y
    t.set_fontsize(6.5)
    # t.set_fontweight("bold")  # 可选


ax1.set_xticks(np.linspace(0,22,12), minor=True)
ax1.set_xticks([0,10,20]); ax1.set_xticklabels(["1982-2003","1992-2013","2002-2023"])
ax1.set_yticks(np.linspace(0,24,9), minor=True)
ax1.set_yticks([0,6,12,18,24]); ax1.set_yticklabels(["0","6","12","18","24"])
# ax1.set_xlabel(" Soil   moisture   trend ", size=12.0)
ax1.set_ylabel("Lagged   months", size=7.5)
ax1.set_xlabel("22-year   window", size=7.5)
plt.title("Amplified   ratio", size=8.0)









# %%
## Plotting Import
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.use('agg')

## Define a Map Function for plotting
def create_map(ax):
  # plt.axes( xscale="log" )
  plt.xlim(1.0+5+4,45.0-5-5)
  # plt.ylim(0.9,20.5)
  plt.rcParams['text.usetex'] = False
  ax.spines['bottom'].set_linewidth(0.7)
  ax.spines['top'].set_linewidth(0.7)
  ax.spines['left'].set_linewidth(0.7)
  ax.spines['right'].set_linewidth(0.7)
  ax.spines['left'].set_color('black')
  ax.tick_params(axis='both', length=4.5, width=0.7, labelsize=6.5)
  ax.tick_params(axis='y', right=False, length=4.5, width=0.7, labelsize=6.5, color='black')
  ax.tick_params(axis="both", which="minor", length=3.1, width=0.6)
  return ax



x = np.linspace(0,23,24)
ax5 = plt.axes([0.36,0.3, 0.23,0.10])
create_map(ax5)
ax5.set_xlabel('22-year   window', size=7.5)
ax5.set_ylabel('Ratio', size=7.5)
ax5.set_xticks(np.linspace(0,22,12), minor=True)
ax5.set_xticks([0,10,20]); ax5.set_xticklabels(["1982-2003","1992-2013","2002-2023"])
ax5.set_yticks(np.linspace(0,17,18), minor=True)
ax5.set_yticks(np.linspace(0,15,6)); ax5.set_yticklabels([0,3,6,9,12,15], color='black')
plt.ylim(0.0,17.0)
plt.xlim(-1.0,23.0)
ax5.plot([-1.0,45.0-5-5], [1.0,1.0], color='black', linewidth=0.8,  linestyle='-', alpha=0.35)
ax5.plot(x[0:23], link_strength0[0,:], label=' lag = 0 day', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=0.72, linewidth=1.0,  markersize=4.2, linestyle='--')
# ax5.plot(x[0:24]+10, link_strength0[3,:], label=' lag = 90 days', color='#009E74', markerfacecolor='#C0E7DA', markeredgecolor='#009E74', marker='o', markeredgewidth=0.75, linewidth=1.0,  markersize=6.0, linestyle='-')
# ax5.plot(x[0:24]+10, link_strength0[6,:], label=' lag = 180 days', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=0.75, linewidth=1.0,  markersize=6.0, linestyle='-')#, alpha=0.5)
ax5.plot(x[0:23], link_strength0[12,:], label=' lag = 12 months', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=0.62, linewidth=1.0,  markersize=4.65, linestyle='--')#, alpha=0.5)

ax5.legend(loc=(0.07, 0.45), fontsize=7.0, frameon=False)
plt.title("Amplified   Synchrony", size=8.0)
print(link_strength0[0,:])
print(link_strength0[12,:])





x_lag = np.linspace(0,24,25)
ax6 = plt.axes([0.68,0.3, 0.23,0.10])
create_map(ax6)
ax6.set_xlabel('Lagged   months', size=7.5)
ax6.set_ylabel('Ratio', size=7.5)
ax6.set_yscale('log')
plt.ylim(0.25,1.08)
plt.xlim(0.0,24.0)
ax6.set_xticks(np.linspace(0,24,13), minor=True)
ax6.set_xticks([0,4,8,12,16,20,24]); ax6.set_xticklabels(["0","4","8","12","16","20","24"])
ax6.set_yticks(np.linspace(0.3,1.0,8), minor=True); ax6.set_yticklabels(["","","","","","","",""], minor=True)
ax6.set_yticks([0.4,0.6,0.8,1.0]); ax6.set_yticklabels(["40%","60%","80%","100%"])
ax6.plot(x_lag, np.linspace(1.0,1.0,25), color='black', linewidth=0.8,  linestyle='-', alpha=0.35)
line1, = ax6.plot(x_lag, link_strength[:,22], label='2004-2025', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='o', markeredgewidth=0.5, linewidth=0.9,  markersize=3.8, linestyle='-', alpha=0.9)
line2, = ax6.plot(x_lag, link_strength[:,18], label='2000-2021', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='^', markeredgewidth=0.6, linewidth=0.9,  markersize=3.8, linestyle='-', alpha=0.9)
line3, = ax6.plot(x_lag, link_strength[:,12], label='1994-2005', color='#009E74', markerfacecolor='#C0E7DA', markeredgecolor='#009E74', marker='o', markeredgewidth=0.5, linewidth=0.9,  markersize=3.8, linestyle='-', alpha=0.8)
line4, = ax6.plot(x_lag, link_strength[:,6], label='1988-2009', color='#57B4E9', markerfacecolor='#D2ECFA', markeredgecolor='#57B4E9', marker='^', markeredgewidth=0.6, linewidth=0.9,  markersize=3.8, linestyle='-', alpha=0.8)
line5, = ax6.plot(x_lag, link_strength[:,0], label='1982-2003', color='#333a8c', markerfacecolor='#989CC8', markeredgecolor='#333a8c', marker='o', markeredgewidth=0.5, linewidth=0.9,  markersize=3.8, linestyle='-', alpha=0.8)

cbar1 = ax6.legend(handles=[line1, line2], loc=(0.56, 0.585), fontsize=6.6, frameon=False)
cbar2 = ax6.legend(handles=[line3, line4, line5], loc=(0.020, 0.015), fontsize=6.6, frameon=False)
ax6.add_artist(cbar1)
plt.title("Lagged   difference", size=8.0)





fig.savefig('5_analysis_gt015/Figure1b_gt015.png', bbox_inches = 'tight')
plt.show()




