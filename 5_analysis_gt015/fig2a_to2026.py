# %%
import numpy as np
import xarray as xr
import statsmodels.api as sm





##--##--##--##--##--##--   (a)   --##--##--##--##--##--##
ds5 = xr.open_dataset("5_analysis_gt015/fig2_cover/OISST_MHWs_cover_1982_2026.nc")
heatwave_area1D = (ds5.heatwave_area.data) * 100.0
heatwave_area1D[44*365+280:] = 0.0
print(heatwave_area1D[44*365:])

print(" MHW area ",np.nanmin(heatwave_area1D),"  ",np.nanmax(heatwave_area1D))
heatwave_area1D_moving180 = np.zeros([np.shape(heatwave_area1D)[0]])
for iday in range(90,np.shape(heatwave_area1D)[0]-90-85): heatwave_area1D_moving180[iday] = np.mean(heatwave_area1D[iday-90:iday+90])
heatwave_area1D_moving180[heatwave_area1D_moving180 == 0] = np.nan
tendency = np.zeros([np.shape(heatwave_area1D)[0]])
for iday in range(45,np.shape(heatwave_area1D)[0]-45-85): tendency[iday] = (heatwave_area1D_moving180[iday+1]-heatwave_area1D_moving180[iday-1])/2.0*100.0




## detrended ##
from scipy import signal
heatwave_area1D_detrended = signal.detrend(heatwave_area1D)
heatwave_area1D_moving180_detrended = np.zeros([np.shape(heatwave_area1D)[0]])
for iday in range(90,np.shape(heatwave_area1D)[0]-90-85): heatwave_area1D_moving180_detrended[iday] = np.mean(heatwave_area1D_detrended[iday-90:iday+90])
heatwave_area1D_moving180_detrended[heatwave_area1D_moving180_detrended == 0] = np.nan
tendency_detrended = np.zeros([np.shape(heatwave_area1D)[0]])
for iday in range(45,np.shape(heatwave_area1D)[0]-45-85): tendency_detrended[iday] = (heatwave_area1D_moving180_detrended[iday+1]-heatwave_area1D_moving180_detrended[iday-1])/2.0*100.0






##--##--##--##--##--##--   (b-c) Marine  heatwave  area   --##--##--##--##--##--##
ds5 = xr.open_dataset("5_analysis_gt015/fig1_pdf/OISST_MHWs_area_pdf_moving20yrs.nc")
heatwave_area_pdf = (ds5.heatwave_area_pdf.data)
heatwave_area_pdf2 = heatwave_area_pdf.copy()

ds6 = xr.open_dataset("5_analysis_gt015/fig1_pdf/OISST_top10extremes_pdf_moving20yrs.nc")
heat90_area_pdf = (ds6.heat_area_pdf.data)

for iyear_start in range(24):
  heatwave_area_pdf2[iyear_start,:] = heatwave_area_pdf[iyear_start,:]/np.nansum(heatwave_area_pdf[iyear_start,:])
  # heatwave360d_area_pdf2[iyear_start,:] = heatwave360d_area_pdf[iyear_start,:]/np.nansum(heatwave360d_area_pdf[iyear_start,:])
  heat90_area_pdf[iyear_start,:] = heat90_area_pdf[iyear_start,:]/np.nansum(heat90_area_pdf[iyear_start,:])
  # heat90_360d_area_pdf[iyear_start,:] = heat90_360d_area_pdf[iyear_start,:]/np.nansum(heat90_360d_area_pdf[iyear_start,:])
heat90_area_pdf[heat90_area_pdf == 0] = 0.0000000000001

print("  20% heatwave event cover  ",np.nansum(heatwave_area_pdf2[0,20:]),"  ",np.nansum(heatwave_area_pdf2[23,20:]))
print("  20% heat event cover  ",np.nansum(heat90_area_pdf[0,20:]),"  ",np.nansum(heat90_area_pdf[23,20:]),"  ",np.nansum(heat90_area_pdf[23,20:])/np.nansum(heat90_area_pdf[0,20:]))












x = np.linspace(1,24,24)
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
  ax.tick_params(axis='both', length=4.5, width=0.7, labelsize=8.0)
  ax.tick_params(axis='y', right=False, length=4.5, width=0.7, labelsize=8.0, color='black')
  ax.tick_params(axis="both", which="minor", length=3.1, width=0.6)
  return ax


##--##--##--  create figure  --##--##--##
width_in_inches = 210 / 25.4  ## A4 page
height_in_inches = 297 / 25.4
fig = plt.figure(dpi=600,figsize=(width_in_inches,height_in_inches))






ax0 = plt.axes([0.01,0.52, 0.91,0.15])
create_map(ax0)
ax0.set_xlabel('', size=9.0)
ax0.set_ylabel('Areal   proportion', size=9.0)
ax0.set_xticks(np.linspace(182+365*3,182+365*3+365*5*8,9)); ax0.set_xticklabels([1985,1990,1995,2000,2005,2010,2015,2020,2025])
ax0.set_xticks(np.linspace(182,182+365*44,45), minor=True)
ax0.set_yticks(np.linspace(0,30,4)); ax0.set_yticklabels(["0","10%","20%","30%",], color='black')
ax0.set_yticks(np.linspace(0,35,8), minor=True)
plt.xlim(1.0,np.shape(heatwave_area1D)[0]-85)
plt.ylim(0.0,35.0)
ax0.plot(np.linspace(1.0,np.shape(heatwave_area1D)[0],np.shape(heatwave_area1D)[0]), heatwave_area1D, color='#1B78B2', linewidth=0.4,  markersize=6.0, linestyle='-', alpha=0.6)
ax0.plot(np.linspace(1.0,np.shape(heatwave_area1D)[0],np.shape(heatwave_area1D)[0]), heatwave_area1D_moving180, color='#B83945', linewidth=1.0,  markersize=6.0, linestyle='-')#, alpha=0.5)
plt.title("Global   spatial   extent   of   marine   heatwaves", size=10.0)

x1 = 5470; x2 = 5850; ax0.fill_between([x1,x2], -20.0, 40, color='#DB9BA1', alpha=0.3)
x1 = 5850; x2 = 6350; ax0.fill_between([x1,x2], -20.0, 40, color='#1B78B2', alpha=0.3)
x1 = 9910; x2 = 10270; ax0.fill_between([x1,x2], -20.0, 40, color='#DB9BA1', alpha=0.3)
x1 = 10270; x2 = 10890; ax0.fill_between([x1,x2], -20.0, 40, color='#1B78B2', alpha=0.3)

x1 = 12010; x2 = 12400; ax0.fill_between([x1,x2], -20.0, 40, color='#DB9BA1', alpha=0.3)
x1 = 12400; x2 = 12950; ax0.fill_between([x1,x2], -20.0, 40, color='#1B78B2', alpha=0.3)
x1 = 14980; x2 = 15280; ax0.fill_between([x1,x2], -20.0, 40, color='#DB9BA1', alpha=0.3)
x1 = 15280; x2 = 15850; ax0.fill_between([x1,x2], -20.0, 40, color='#1B78B2', alpha=0.3)


x1 = 5850; x2 = 6350
x1 = 9910; x2 = 10270
x1 = 10270; x2 = 10890
x1 = 12010; x2 = 12400
x1 = 12400; x2 = 12950
x1 = 15060; x2 = 15280 ## old
x1 = 15280; x2 = 44*365 ## old
x1 = 14980; x2 = 15280
x1 = 15280; x2 = 15850



print(" tendecy (detrended) ",np.nanmin(tendency[100:np.shape(heatwave_area1D)[0]-100]),"  ",np.nanmax(tendency_detrended[100:np.shape(heatwave_area1D)[0]-100]))
print(" tendecy ",np.nanmin(tendency[100:np.shape(heatwave_area1D)[0]-100]),"  ",np.nanmax(tendency[100:np.shape(heatwave_area1D)[0]-100]))
counts0, bin_edges0 = np.histogram(tendency, bins=100, range=(-10, 10), density=True)
bin_centers0 = (bin_edges0[:-1] + bin_edges0[1:]) / 2
counts0_detrended, bin_edges0_detrended = np.histogram(tendency_detrended, bins=100, range=(-10, 10), density=True)
bin_centers0_detrended = (bin_edges0_detrended[:-1] + bin_edges0_detrended[1:]) / 2
Pacc = np.zeros_like(bin_centers0)
Pacc_detrended = np.zeros_like(bin_centers0_detrended)
for i in range (100): 
  Pacc[i] = np.nansum(counts0[i:]) * 0.2
  Pacc_detrended[i] = np.nansum(counts0_detrended[i:]) * 0.2
Nacc = np.zeros_like(bin_centers0)
Nacc_detrended = np.zeros_like(bin_centers0_detrended)
for i in range (100): 
  Nacc[i] = np.nansum(counts0[:i]) * 0.2
  Nacc_detrended[i] = np.nansum(counts0_detrended[:i]) * 0.2

ax01 = plt.axes([0.10,0.57, 0.16,0.09])
create_map(ax01)
ax01.tick_params(axis='both', length=4.5, width=0.7, labelsize=7.5)
ax01.tick_params(axis='y', right=False, length=4.5, width=0.7, labelsize=7.5, color='black')
ax01.set_xticks([0,1,2,3,4]); ax01.set_xticklabels([">0",">1",">2",">3",">4"])
ax01.set_xticks(np.linspace(0,4,5), minor=True)
ax01.plot(bin_centers0_detrended, Pacc_detrended, label='Increase', color='#DB9BA1', marker='o', markerfacecolor='none', linestyle='-', markersize=5.0, markeredgewidth=1.0, linewidth=0.2)#, alpha=0.5)
ax01.plot(bin_centers0_detrended, Nacc_detrended[::-1], label='Decrease', color='#1B78B2', marker='^', markerfacecolor='none', linestyle='-', markersize=4.5, markeredgewidth=1.0, linewidth=0.2)#, alpha=0.5)
ax01.plot(bin_centers0_detrended, Pacc_detrended, color='#B83945', linestyle='--', linewidth=1.0)
ax01.plot(bin_centers0_detrended, Nacc_detrended[::-1], color='#1B78B2', linestyle='--', linewidth=1.0)
ax01.plot([0,0], [0.0,1.2], linestyle='--', linewidth=0.3)
ax01.legend(loc=(0.01, 0.03), fontsize=7.7, frameon=False)
plt.xlim(0.0,4)
plt.ylim(0.003,0.7)
plt.yscale('log')
ax01.set_yticks([0.01,0.1]); ax01.set_yticklabels(["0.01","0.1"])
ax01.text(2.0, 0.28, "Tendency", ha='center', fontsize=8.6, color='black')
ax01.set_ylabel('Probability', size=8.2)

bin_width = bin_edges0[1] - bin_edges0[0]
percentage_gt_0 = np.sum(counts0[bin_centers0 > 0] * bin_width) * 100
print(">0 = ",percentage_gt_0)











ax1 = plt.axes([0.01,0.33, 0.40,0.11])
create_map(ax1)
ax1.set_xlabel('Global   spatial   extent', size=9.0)
ax1.set_ylabel('Probability', size=9.0)
plt.xlim(0.0,30.0)
# plt.ylim(0.0,70.0)

plt.ylim(0.007,1.0)
ax1.set_yscale('log')
ax1.set_xticks(np.linspace(0,35,8)); ax1.set_xticklabels([0,"5%","10%","15%","20%","25%","30%","35%"])
ax1.set_xticks(np.linspace(0,35,15), minor=True)
# ax1.set_yticks(np.linspace(0,60,4)); ax1.set_yticklabels([0,20,40,60], color='black')
# ax1.set_yticks(np.linspace(0,70,8), minor=True)
ax1.set_yticks([0.01,0.03,0.1,0.3,1]); ax1.set_yticklabels(["1%","3%","10%","30%","100%"], color='black')
ax1.set_yticks([0.005,0.006,0.007,0.008,0.009,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9], minor=True)
ax1.plot(np.linspace(0.5,99.5,100), heatwave_area_pdf2[0,:], label=' (1982-2001)', color='#1B78B2', markerfacecolor='#CDD9EC', markeredgecolor='#1B78B2', marker='o', markeredgewidth=0.75, linewidth=1.0,  markersize=6.0, linestyle='-')#, alpha=0.5)
ax1.plot(np.linspace(0.5,99.5,100), heatwave_area_pdf2[23,:], label=' (2005-2024)', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=0.75, linewidth=1.0,  markersize=6.0, linestyle='--')#, alpha=0.5)
ax1.plot([20.0,20.0], [0.0,0.109], color='#009E74', linestyle='-', linewidth=2.0)
ax1.fill_between(np.linspace(0.5,99.5,100), 0.0, heatwave_area_pdf2[23,:], color='#DB9BA1', alpha=0.25)
ax1.fill_between(np.linspace(0.5,99.5,100), 0.0, heatwave_area_pdf2[0,:], color='#CDD9EC', alpha=0.6)
ax1.legend(loc=(0.57, 0.63), fontsize=8.5, frameon=False)
plt.title("Marine   heatwaves   (daily)", size=10.0)
ax1.text(22.2, 0.063, s='0%', fontsize=9.5, color='#1B78B2')
ax1.text(25.2, 0.063, s='-->', fontsize=9.5, color='black')
ax1.text(28.2, 0.063, s='20.7%', fontsize=9.5, color='#B83945')










ax2 = plt.axes([0.52,0.33, 0.40,0.11])
create_map(ax2)
ax2.set_xlabel('Global   spatial   extent', size=9.0)
ax2.set_ylabel('Probability', size=9.0)
plt.xlim(0.0,35.0)
plt.ylim(0.005,0.50)
ax2.set_yscale('log')
ax2.set_xticks(np.linspace(0,35,8)); ax2.set_xticklabels([0,"5%","10%","15%","20%","25%","30%","35%"])
ax2.set_xticks(np.linspace(0,35,15), minor=True)
ax2.set_yticks([0.01,0.03,0.1,0.3]); ax2.set_yticklabels(["1%","3%","10%","30%"], color='black')
ax2.set_yticks([0.005,0.006,0.007,0.008,0.009,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,0.4,0.5,0.6], minor=True)
# ax2.set_xticks(np.linspace(0,25,11)); ax2.set_xticklabels([0,"","5%","","10%","","15%","","20%","","25%"])
# ax2.set_yticks([0.003,0.003,0.005,0.006,0.007,0.008,0.009,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,0.4,0.5,0.6]); ax2.set_yticklabels(["0.3%","","","","","","","1%","","3%","","","","","","","10%","","30%","","",""], color='black')
ax2.plot(np.linspace(0.5,99.5,100), heat90_area_pdf[0,:], label=' (1982-2001)', color='#1B78B2', markerfacecolor='#CDD9EC', markeredgecolor='#1B78B2', marker='o', markeredgewidth=0.75, linewidth=1.0,  markersize=6.0, linestyle='-')#, alpha=0.5)
ax2.plot(np.linspace(0.5,99.5,100), heat90_area_pdf[23,:], label=' (2005-2024)', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=0.75, linewidth=1.0,  markersize=6.0, linestyle='--')#, alpha=0.5)
ax2.plot([20.0,20.0], [0.005,0.075], color='#009E74', linestyle='-', linewidth=2.0)
ax2.fill_between(np.linspace(0.5,99.5,100), 0.003, heat90_area_pdf[23,:], color='#DB9BA1', alpha=0.25)
ax2.fill_between(np.linspace(0.5,99.5,100), 0.003, heat90_area_pdf[0,:], color='#CDD9EC', alpha=0.6)
ax2.legend(loc=(0.57, 0.63), fontsize=8.5, frameon=False)
plt.title("SST   warming   events   (daily)", size=10.0)
ax2.text(21.9, 0.045, s='2.6%', fontsize=9.5, color='#1B78B2')
ax2.text(26.2, 0.045, s='-->', fontsize=9.5, color='black')
ax2.text(28.9, 0.045, s='13.8%', fontsize=9.5, color='#B83945')






ax0.text(-900, 39.0, s='a', fontsize=13.0, color='black', fontweight='bold')
ax0.text(-900, -13.0, s='b', fontsize=13.0, color='black', fontweight='bold')
ax0.text(22*365+200, -13.0, s='c', fontsize=13.0, color='black', fontweight='bold')
fig.savefig('5_analysis_gt015/Figure2a_to2026.png', bbox_inches = 'tight')
plt.show()




