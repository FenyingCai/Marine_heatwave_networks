# %%
import numpy as np
import xarray as xr


ds1 = xr.open_dataset("5_analysis_gt015/fig4_CMIP6degree_gt015/El_Nino_Flow_Historical_SSP370_gt015.nc")
H_NEP_MME = np.nanmean(ds1.H_NEP[:,:].data, axis=0) / 1.0e2
F_NEP_MME = np.nanmean(ds1.F_NEP[:,:].data, axis=0) / 1.0e2



## ------------------------------------------------------------------------------------------------------------------- ##
ds1 = xr.open_dataset("5_analysis_gt015/fig4_CMIP6degree_gt015/El_Nino_Flow_Historical_SSP370_gt015.nc")
H_NEP = ds1.H_NEP[:,0].data / 1.0e2
H_SWP = ds1.H_SWP[:,1].data / 1.0e2
H_IO = ds1.H_IO[:,3].data / 1.0e2
H_TNA = ds1.H_TNA[:,3].data / 1.0e2
H_TSA = ds1.H_TSA[:,3].data / 1.0e2
H_WNP = ds1.H_WNP[:,4].data / 1.0e2

F_NEP = ds1.F_NEP[:,0].data / 1.0e2
F_SWP = ds1.F_SWP[:,1].data / 1.0e2
F_IO = ds1.F_IO[:,3].data / 1.0e2
F_TNA = ds1.F_TNA[:,3].data / 1.0e2
F_TSA = ds1.F_TSA[:,3].data / 1.0e2
F_WNP = ds1.F_WNP[:,4].data / 1.0e2

D_NEP = F_NEP > H_NEP
D_SWP = F_SWP > H_SWP
D_IO = F_IO > H_IO
D_TNA = F_TNA > H_TNA
D_TSA = F_TSA > H_TSA
D_WNP = F_WNP > H_WNP


print(" NEP ",np.sum(D_NEP)/19.0)
print(" SWP ",np.sum(D_SWP)/19.0)
print(" IO ",np.sum(D_IO)/19.0)
print(" TNA ",np.sum(D_TNA)/19.0)
print(" TSA ",np.sum(D_TSA)/19.0)
print(" WNP ",np.sum(D_WNP)/19.0)
print(H_NEP)


# print(F_NEP>H_NEP)
print(np.shape(D_NEP))



# %%
## Plotting Import
import matplotlib as mpl
import matplotlib.pyplot as plt
mpl.use('agg')

## Define a Map Function for plotting
def create_map(ax):
  # plt.axes( xscale="log" )
  plt.xlim(-1.0,37.0)
  plt.ylim(2.0,5.5)
  ax.tick_params(axis='both', length=6.0, width=1.0, labelsize=9.0)
  ax.spines['bottom'].set_linewidth(0.7)
  ax.spines['top'].set_linewidth(0.7)
  ax.spines['left'].set_linewidth(0.7)
  ax.spines['right'].set_linewidth(0.7)
  ax.spines['left'].set_color('black')
  ax.tick_params(axis='both', right=False, length=6.0, width=0.9, labelsize=8.0, color='black')
  ax.tick_params(axis='both', which='minor', right=False, length=4.0, width=0.7, color='black')
  return ax


##--##--##--  create figure  --##--##--##
width_in_inches = 210 / 25.4  ## A4 page
height_in_inches = 297 / 25.4
fig = plt.figure(dpi=400,figsize=(width_in_inches,height_in_inches))









ax6 = plt.axes([0.00,0.285, 0.72,0.08])
create_map(ax6)
# ax3.set_xlabel('Lagged   month', size=11)
# ax6.set_ylabel('', size=11)
plt.rcParams['text.usetex'] = False
plt.xlim(1.0,19.0)
plt.ylim(-2,50)
ax6.set_xticks([2.5,5.5,8.5,11.5,14.5,17.5]); ax6.set_xticklabels(["NEP->TEP (12)", "SEP->TEP (6)", "TEP->TIO (6)", "TEP->TNA (6)", "TEP->TSA (6)", "TEP->WNP (12)"], color='black')
# ax6.set_yticks([-20000,-15000,-10000,-5000,0,5000]); ax6.set_yticklabels([-20,-15,-10,-5,0,5], color='black')
ax6.set_yticks([0,5,10,15,20,25,30,35,40,45,50], minor=True)

def plot_violin(data, pos, vcolor, mcolor):
    v = ax6.violinplot(
        data,
        positions=[pos],
        widths=0.7,
        showmeans=False,
        showmedians=True,
        showextrema=False
    )

    # median 横线：颜色、粗细、长度
    v['cmedians'].set_color(mcolor)
    v['cmedians'].set_linewidth(2.5)

    segments = v['cmedians'].get_segments()
    for seg in segments:
        seg[0, 0] = pos - 0.25
        seg[1, 0] = pos + 0.25
    v['cmedians'].set_segments(segments)

    for body in v['bodies']:
        body.set_facecolor(vcolor)
        body.set_edgecolor(vcolor)
        body.set_alpha(0.45)

    x = np.random.normal(pos, 0.07, size=len(data))
    ax6.scatter(x, data, s=10, alpha=1.0, color=vcolor)


plot_violin(H_NEP.data, 2+0.1,  'skyblue', 'blue')
plot_violin(F_NEP.data, 3-0.1,  'salmon',  'red')

plot_violin(H_SWP.data, 5+0.1,  'skyblue', 'blue')
plot_violin(F_SWP.data, 6-0.1,  'salmon',  'red')

plot_violin(H_IO.data,  8+0.1,  'skyblue', 'blue')
plot_violin(F_IO.data,  9-0.1,  'salmon',  'red')

plot_violin(H_TNA.data, 11+0.1, 'skyblue', 'blue')
plot_violin(F_TNA.data, 12-0.1, 'salmon',  'red')

plot_violin(H_TSA.data, 14+0.1, 'skyblue', 'blue')
plot_violin(F_TSA.data, 15-0.1, 'salmon',  'red')

plot_violin(H_WNP.data, 17+0.1, 'skyblue', 'blue')
plot_violin(F_WNP.data, 18-0.1, 'salmon',  'red')



# ax6.text(2.5, 27.5, s="↑ 84.2%", ha='center', fontsize=8.5, color='red')

ax6.text(2.5, 37, s="↑ 84.2%", ha='center', fontsize=8.5, color='red')
ax6.text(2.85, 29.0, s="of models", ha='center', fontsize=8.5, color='red')
ax6.text(5.5, 22.5, s="↑ 73.7%", ha='center', fontsize=8.5, color='red')
ax6.text(9.0, 3.5, s="↑ 63.2%", ha='center', fontsize=8.5, color='black')
ax6.text(11.5, 41.0, s="↑ 57.9%", ha='center', fontsize=8.5, color='black')
ax6.text(14.5, 28.5, s="↑ 62.2%", ha='center', fontsize=8.5, color='black')
ax6.text(17.5, 22.3, s="↑ 52.6%", ha='center', fontsize=8.5, color='black')








ax7 = plt.axes([0.80,0.285, 0.20,0.08])
create_map(ax7)
plt.rcParams['text.usetex'] = False
ax7.tick_params(axis='x')
# ax7.tick_params(axis='both', right=False, length=4.0, width=0.9, labelsize=5.0, color='black')
plt.xlim(-15.0,15.0)
plt.ylim(3,13)
ax7.set_xticks([-12,-6,0,6,12]); ax7.set_xticklabels(["-12", "-6", "0", "+6", "+12"], color='black')
ax7.set_yticks([4,8,12]); ax7.set_yticklabels([4,8,12], color='black')
ax7.set_yticks([2,4,6,8,10,12], minor=True)

ax7.plot(np.linspace(-12,12,5), H_NEP_MME, color='skyblue',marker='o')
ax7.plot(np.linspace(-12,12,5), F_NEP_MME, color='salmon',marker='o')



fig.savefig('5_analysis_gt015/Figure4b_violin.png', bbox_inches = 'tight')
plt.show()




