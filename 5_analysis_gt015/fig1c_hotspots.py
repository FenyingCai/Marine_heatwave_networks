# %%
import numpy as np
import xarray as xr
import statsmodels.api as sm



##--##--##--##--##--##--   (a) Marine heatwave  coincidence   --##--##--##--##--##--##
ds1 = xr.open_dataset("5_analysis_gt015/fig1_degree_gt015/Link_number_lag0_hotspots_gt015.nc")
mhw_link_number_WP = (ds1.link_number_WP.data)
mhw_link_strength_WP = (ds1.link_strength_WP.data)
mhw_average_strength_WP = (ds1.link_strength_WP.data) / (ds1.link_number_WP.data)
mhw_link_number_WP = mhw_link_number_WP / mhw_link_number_WP[0]
mhw_link_strength_WP = mhw_link_strength_WP / mhw_link_strength_WP[0]
mhw_average_strength_WP = mhw_average_strength_WP / mhw_average_strength_WP[0]

mhw_link_number_TA = (ds1.link_number_TA.data)
mhw_link_strength_TA = (ds1.link_strength_TA.data)
mhw_average_strength_TA = (ds1.link_strength_TA.data) / (ds1.link_number_TA.data)
mhw_link_number_TA = mhw_link_number_TA / mhw_link_number_TA[0]
mhw_link_strength_TA = mhw_link_strength_TA / mhw_link_strength_TA[0]
mhw_average_strength_TA = mhw_average_strength_TA / mhw_average_strength_TA[0]

mhw_link_number_IO = (ds1.link_number_IO.data)
mhw_link_strength_IO = (ds1.link_strength_IO.data)
mhw_average_strength_IO = (ds1.link_strength_IO.data) / (ds1.link_number_IO.data)
mhw_link_number_IO = mhw_link_number_IO / mhw_link_number_IO[0]
mhw_link_strength_IO = mhw_link_strength_IO / mhw_link_strength_IO[0]
mhw_average_strength_IO = mhw_average_strength_IO / mhw_average_strength_IO[0]

print(mhw_link_strength_IO)
print(mhw_link_strength_WP)
print(mhw_link_strength_TA)




##--##--##--##--##--##--   (b) Marine heatwave  coincidence   --##--##--##--##--##--##
ds1 = xr.open_dataset("5_analysis_gt015/fig1_degree_gt015/Link_number_lag360_hotspots_gt015.nc")
mhw_link_number_WP2 = (ds1.link_number_WP.data)
mhw_link_strength_WP2 = (ds1.link_strength_WP.data)
mhw_average_strength_WP2 = (ds1.link_strength_WP.data) / (ds1.link_number_WP.data)
mhw_link_number_WP2 = mhw_link_number_WP2 / mhw_link_number_WP2[0]
mhw_link_strength_WP2 = mhw_link_strength_WP2 / mhw_link_strength_WP2[0]
mhw_average_strength_WP2 = mhw_average_strength_WP2 / mhw_average_strength_WP2[0]

mhw_link_number_TA2 = (ds1.link_number_TA.data)
mhw_link_strength_TA2 = (ds1.link_strength_TA.data)
mhw_average_strength_TA2 = (ds1.link_strength_TA.data) / (ds1.link_number_TA.data)
mhw_link_number_TA2 = mhw_link_number_TA2 / mhw_link_number_TA2[0]
mhw_link_strength_TA2 = mhw_link_strength_TA2 / mhw_link_strength_TA2[0]
mhw_average_strength_TA2 = mhw_average_strength_TA2 / mhw_average_strength_TA2[0]

mhw_link_number_IO2 = (ds1.link_number_IO.data)
mhw_link_strength_IO2 = (ds1.link_strength_IO.data)
mhw_average_strength_IO2 = (ds1.link_strength_IO.data) / (ds1.link_number_IO.data)
mhw_link_number_IO2 = mhw_link_number_IO2 / mhw_link_number_IO2[0]
mhw_link_strength_IO2 = mhw_link_strength_IO2 / mhw_link_strength_IO2[0]
mhw_average_strength_IO2 = mhw_average_strength_IO2 / mhw_average_strength_IO2[0]


print(mhw_link_strength_IO2)
print(mhw_link_strength_WP2)
print(mhw_link_strength_TA2)






x = np.linspace(1,23,23)
# %%
## Plotting Import
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.use('agg')

## Define a Map Function for plotting
def create_map(ax):
  # plt.axes( xscale="log" )
  plt.xlim(11.0,45.0-10)
  plt.ylim(0.0,55.0)
  # ax.spines['bottom'].set_linewidth(0.7)
  # ax.spines['top'].set_linewidth(0.7)
  ax.spines['top'].set_visible(False)
  ax.spines['right'].set_visible(False)
  ax.spines['left'].set_linewidth(1.5)
  ax.spines['bottom'].set_linewidth(1.5)
  ax.tick_params(axis='both', length=0.0, width=0.7, labelsize=7.5)
  ax.tick_params(axis='y', right=False, length=0.0, width=0.7, labelsize=7.5, color='black')
  ax.set_xticks([20,30]); ax.set_xticklabels(["",""])
  ax.set_yticks([20,30]); ax.set_yticklabels(["",""])
  plt.rcParams['text.usetex'] = False
  ax.set_xlabel('', size=9.0)
  ax.set_ylabel('', size=9.0)
  ax.set_xlabel('22-yr   window', size=15.4)

  ax.annotate('', xy=(1.02, 0), xytext=(0, 0),
             xycoords=('axes fraction'), textcoords='axes fraction',
             arrowprops=dict(arrowstyle='->', lw=1.5,mutation_scale=25))
  ax.annotate('', xy=(0, 1.02), xytext=(0, 0),
              xycoords=('axes fraction'), textcoords='axes fraction',
              arrowprops=dict(arrowstyle='->', lw=1.5,mutation_scale=25))
  return ax



##--##--##--  create figure  --##--##--##
width_in_inches = 210 / 25.4  ## A4 page
height_in_inches = 297 / 25.4
fig = plt.figure(dpi=600,figsize=(width_in_inches,height_in_inches))


ax1 = plt.axes([0.01,0.5, 0.27,0.26])
create_map(ax1)
plt.xlim(11.0,45.0-10)
plt.ylim(0.0,42.0)
# ax1.plot(x+10, mhw_link_number_IO, label='Number', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=1.4, linewidth=1.5,  markersize=8.5, linestyle='-')#, alpha=0.5)
ax1.plot(x+10, mhw_link_number_IO, label='Lag = 0', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=1.4, linewidth=1.5,  markersize=8.5, linestyle='-')#, alpha=0.5)
ax1.plot(x+10, mhw_link_strength_IO2, label=' Lag = 12 mon', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=1.4, linewidth=1.5,  markersize=11.0, linestyle='--')#, alpha=0.5)

# ax1.plot(x+10, mhw_average_strength_IO, label='Ave strength', color='#009E74', linewidth=2.5,  linestyle='--')#, alpha=0.5)
ax1.text(26, 31.3, s='32.3', fontsize=16.0, color='#B83945')
# ax1.legend(loc=(0.04, 0.60), fontsize=14.0, frameon=False)
plt.title("Indian  Ocean", size=17.0)



ax2 = plt.axes([0.36,0.5, 0.27,0.26])
create_map(ax2)
plt.xlim(11.0,45.0-10)
plt.ylim(0.0,70.5)
# ax2.plot(x+10, mhw_link_number_WP, label=' Link numer', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=1.4, linewidth=1.5,  markersize=8.5, linestyle='-')#, alpha=0.5)
ax2.plot(x+10, mhw_link_number_WP, label=' Lag = 0', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=1.4, linewidth=1.5,  markersize=8.5, linestyle='-')#, alpha=0.5)
ax2.plot(x+10, mhw_link_strength_WP2, label=' Lag = 12 mon', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=1.4, linewidth=1.5,  markersize=11.0, linestyle='--')#, alpha=0.5)
# ax2.plot(x+10, mhw_average_strength_WP, label=' Average strength', color='#009E74', linewidth=2.5,  linestyle='--')#, alpha=0.5)
ax2.text(26.0, 55.9, s='57.7', fontsize=16.0, color='#B83945')
# ax2.legend(loc=(0.07, 0.55), fontsize=8.5, frameon=False)
plt.title("Western  Pacific", size=17.0)



ax3 = plt.axes([0.71,0.5, 0.27,0.26])
create_map(ax3)
plt.xlim(11.0,45.0-10)
plt.ylim(0.0,100.0)
# ax3.plot(x+10, mhw_link_number_TA, label='Number', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=1.4, linewidth=1.5,  markersize=8.5, linestyle='-')#, alpha=0.5)
ax3.plot(x+10, mhw_link_number_TA, label=' Lag = 0', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=1.4, linewidth=1.5,  markersize=8.5, linestyle='-')#, alpha=0.5)
ax3.plot(x+10, mhw_link_strength_TA2, label=' Lag = 12 mon', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=1.4, linewidth=1.5,  markersize=11.0, linestyle='--')#, alpha=0.5)
# ax3.plot(x+10, mhw_average_strength_TA, label='Average strength', color='#009E74', linewidth=2.5,  linestyle='--')#, alpha=0.5)
ax3.text(26, 84.8, s='87.2', fontsize=16.0, color='#B83945')
ax3.legend(loc=(1.15, 0.35), fontsize=14.5, frameon=False)
plt.title("Tropical  Atlantic", size=17.0)





# ax1.text(8.5, 13.8, s='a', fontsize=13.0, color='black', fontweight='bold')
fig.savefig('5_analysis_gt015/Figure1c_hotspots_gt015.png', bbox_inches = 'tight')
plt.show()




