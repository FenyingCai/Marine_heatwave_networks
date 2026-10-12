# %%
import numpy as np
import xarray as xr
import statsmodels.api as sm



##--##--##--##--##--##--   (a) Marine heatwave  coincidence   --##--##--##--##--##--##
ds1 = xr.open_dataset("5_analysis_gt015/fig1_degree_pdf_gt015/OISST_mhw_mhw_gt015_degree_PDF_moving20yrs.nc")
mhw_pdf = (ds1.pdf.data)
mhw_pdf[mhw_pdf==0] = 0.0000000000001


ds2 = xr.open_dataset("5_analysis_gt015/fig1_degree_pdf_gt015/OISST_heat90_heat90_gt015_degree_PDF_moving20yrs.nc")
heat90_pdf = (ds2.pdf.data)
heat90_pdf[heat90_pdf==0] = 0.0000000000001




x = np.linspace(1,24,24)
# %%
## Plotting Import
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.use('agg')

## Define a Map Function for plotting
def create_map(ax):
  # plt.axes( xscale="log" )
  # ax.spines['bottom'].set_linewidth(0.7)
  # ax.spines['top'].set_linewidth(0.7)
  ax.spines['top'].set_visible(False)
  ax.spines['right'].set_visible(False)
  ax.spines['left'].set_linewidth(1.5)
  ax.spines['bottom'].set_linewidth(1.5)
  ax.tick_params(axis='both', right=False, length=10.0, width=1.5, labelsize=20.5, color='black')
  ax.tick_params(axis="both", which="minor", length=7.0, width=1.2)
  ax.set_xticks([20,30]); ax.set_xticklabels(["",""])
  ax.set_yticks([20,30]); ax.set_yticklabels(["",""])
  plt.rcParams['text.usetex'] = False
  ax.set_xlabel('', size=9.0)
  ax.set_ylabel('', size=9.0)
  # ax.set_xlabel('20-yr   window', size=18.0)

  ax.annotate('', xy=(1.02, 0), xytext=(0, 0),
             xycoords=('axes fraction'), textcoords='axes fraction',
             arrowprops=dict(arrowstyle='->', lw=1.5,mutation_scale=25))
  ax.annotate('', xy=(0, 1.15), xytext=(0, 0),
              xycoords=('axes fraction'), textcoords='axes fraction',
              arrowprops=dict(arrowstyle='->', lw=1.5,mutation_scale=25))
  return ax


##--##--##--  create figure  --##--##--##
width_in_inches = 210 / 25.4  ## A4 page
height_in_inches = 297 / 25.4
fig = plt.figure(dpi=600,figsize=(width_in_inches,height_in_inches))




ax1 = plt.axes([0.05,0.5, 0.90,0.15])
create_map(ax1)
ax1.set_xlabel('Degree   centrality    (Marine   heatwaves)', size=22)
ax1.set_ylabel('Probability', size=22)
ax1.set_yscale('log')
plt.xlim(0.0,14.0)
plt.ylim(0.01,1.0)
ax1.set_xticks(np.linspace(0,13,14)); ax1.set_xticklabels([0,"",2,"",4,"",6,"",8,"",10,"",12,""])
ax1.set_yticks([0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]); ax1.set_yticklabels([0.01,"","","","","","","","",0.1,"","","","","","","","",1], color='black')
ax1.plot(np.linspace(0.0,14.0,29), mhw_pdf[0,:], label=' (1982-2003)', color='#1B78B2', markerfacecolor='#CDD9EC', markeredgecolor='#1B78B2', marker='o', markeredgewidth=1.6, linewidth=1.5,  markersize=13.0, linestyle='-')#, alpha=0.5)
ax1.plot(np.linspace(0.0,14.0,29), mhw_pdf[22,:], label=' (2004-2025)', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=1.6, linewidth=1.5,  markersize=14.0, linestyle='--')#, alpha=0.5)
# ax1.plot([20.0,20.0], [0.0,35.0], color='#009E74', linestyle='-', linewidth=2.0)
ax1.fill_between(np.linspace(0.0,14.0,29), 0.01, mhw_pdf[22,:], color='#DB9BA1', alpha=0.25)
ax1.fill_between(np.linspace(0.0,14.0,29), 0.01, mhw_pdf[0,:], color='#CDD9EC', alpha=0.6)
ax1.legend(loc=(0.62, 0.48), fontsize=22.0, frameon=False)
# plt.title("Marine   heatwave", size=10.0)




ax2 = plt.axes([0.05,0.25, 0.90,0.15])
create_map(ax2)
ax2.set_xlabel('Degree   centrality    (SST   warming   events)', size=22)
ax2.set_ylabel('Probability', size=22)
ax2.set_yscale('log')
plt.xlim(0.0,14.0)
plt.ylim(0.01,1.0)
ax2.set_xticks(np.linspace(0,12,7)); ax2.set_xticklabels([0,2,4,6,8,10,12])
ax2.set_xticks(np.linspace(0,13,14), minor=True)
ax2.set_yticks([0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]); ax2.set_xticklabels([0,2,4,6,8,10,12])
ax2.set_yticks([0.01,0.1,1.0]); ax2.set_yticklabels([0.01,0.1,1], color='black')
ax2.plot(np.linspace(0.0,14.0,29), heat90_pdf[0,:], label=' (1982-2003)', color='#1B78B2', markerfacecolor='#CDD9EC', markeredgecolor='#1B78B2', marker='o', markeredgewidth=1.6, linewidth=1.5,  markersize=13.0, linestyle='-')#, alpha=0.5)
ax2.plot(np.linspace(0.0,14.0,29), heat90_pdf[22,:], label=' (2004-2025)', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=1.6, linewidth=1.5,  markersize=14.0, linestyle='--')#, alpha=0.5)
# ax2.plot([20.0,20.0], [0.0,35.0], color='#009E74', linestyle='-', linewidth=2.0)
ax2.fill_between(np.linspace(0.0,14.0,29), 0.01, heat90_pdf[22,:], color='#DB9BA1', alpha=0.25)
ax2.fill_between(np.linspace(0.0,14.0,29), 0.01, heat90_pdf[0,:], color='#CDD9EC', alpha=0.6)
# ax2.legend(loc=(0.65, 0.55), fontsize=17.5, frameon=False)
# plt.title("Warm   SST   events", size=10.0)



# ax1.text(8.5, 13.8, s='a', fontsize=13.0, color='black', fontweight='bold')
fig.savefig('5_analysis_gt015/Figure1d_degree_pdf_gt015.png', bbox_inches = 'tight')
plt.show()




