import numpy as np
import xarray as xr
import matplotlib as mpl
import matplotlib.pyplot as plt

mpl.use('agg')

# ==============================================================================
# Helper Functions
# ==============================================================================
def create_map(ax):
    plt.rcParams['text.usetex'] = False
    ax.spines['bottom'].set_linewidth(0.7)
    ax.spines['top'].set_linewidth(0.7)
    ax.spines['left'].set_linewidth(0.7)
    ax.spines['right'].set_linewidth(0.7)
    ax.spines['left'].set_color('black')
    ax.tick_params(axis='both', length=4.5, width=0.7, labelsize=6.5)
    ax.tick_params(axis="both", which="minor", length=3.1, width=0.6)
    return ax

# ==============================================================================
# 1. 【上面部分：le2kkm】数据读取与计算 (<= 2000 km)
# ==============================================================================
data_dir_le = "5_analysis_gt015/fig1_degree_gt015/"
nc_le = data_dir_le + "Link_number_lag0to720_globe_gt015_le2kkm.nc"

ds_le = xr.open_dataset(nc_le)

# --- 1.1 用于 ax1 (Amplified ratio) 的计算 ---
link_number0_le = np.zeros([25, 23])
Alink_strength0_le = np.zeros([25, 23])
link_number0_le[:, :] = ds_le.link_number[:, 0:23].data
Alink_strength0_le[:, :] = ds_le.link_strength[:, 0:23].data

link_number_le1 = link_number0_le.copy()
Alink_strength_le = Alink_strength0_le.copy()
for i in range(25):
    link_number_le1[i, :] = link_number_le1[i, :] / link_number0_le[i, 0]
    Alink_strength_le[i, :] = Alink_strength_le[i, :] / Alink_strength0_le[i, 0]

# --- 1.2 用于 ax2 & ax3 的计算 ---
link_number0_le2 = np.zeros([25, 23])
link_strength0_le = np.zeros([25, 23])
link_number0_le2[:, :] = ds_le.link_number[:, 0:23].data
link_strength0_le[:, :] = ds_le.link_strength[:, 0:23].data

link_number_le2 = link_number0_le2.copy()
link_strength_le = link_strength0_le.copy()

for i in range(25):
    link_number_le2[i, :] = link_number0_le2[i, :] / link_number0_le2[0, :]
    link_strength_le[i, :] = link_strength0_le[i, :] / link_strength0_le[0, :]

for i in range(25):
    link_number0_le2[i, :] = link_number0_le2[i, :] / link_number0_le2[i, 0]
    link_strength0_le[i, :] = link_strength0_le[i, :] / link_strength0_le[i, 0]


# ==============================================================================
# 2. 【下面部分：gt2kkm】数据读取与计算 (> 2000 km)
# ==============================================================================
data_dir_gt = "5_analysis_gt015/fig1_degree_gt015/"
nc_gt = data_dir_gt + "Link_number_lag0to720_globe_gt015_gt2kkm.nc"

ds_gt = xr.open_dataset(nc_gt)

# --- 2.1 用于 ax4 (Amplified ratio) 的计算 ---
link_number0_gt = np.zeros([25, 23])
Alink_strength0_gt = np.zeros([25, 23])
link_number0_gt[:, :] = ds_gt.link_number[:, 0:23].data
Alink_strength0_gt[:, :] = ds_gt.link_strength[:, 0:23].data

link_number_gt1 = link_number0_gt.copy()
Alink_strength_gt = Alink_strength0_gt.copy()
for i in range(25):
    link_number_gt1[i, :] = link_number_gt1[i, :] / link_number0_gt[i, 0]
    Alink_strength_gt[i, :] = Alink_strength_gt[i, :] / Alink_strength0_gt[i, 0]

# --- 2.2 用于 ax5 & ax6 的计算 ---
link_number0_gt2 = np.zeros([25, 23])
link_strength0_gt = np.zeros([25, 23])
link_number0_gt2[:, :] = ds_gt.link_number[:, 0:23].data
link_strength0_gt[:, :] = ds_gt.link_strength[:, 0:23].data

link_number_gt2 = link_number0_gt2.copy()
link_strength_gt = link_strength0_gt.copy()

for i in range(25):
    link_number_gt2[i, :] = link_number0_gt2[i, :] / link_number0_gt2[0, :]
    link_strength_gt[i, :] = link_strength0_gt[i, :] / link_strength0_gt[0, :]

for i in range(25):
    link_number0_gt2[i, :] = link_number0_gt2[i, :] / link_number0_gt2[i, 0]
    link_strength0_gt[i, :] = link_strength0_gt[i, :] / link_strength0_gt[i, 0]


# ==============================================================================
# 3. 画图 setup
# ==============================================================================
width_in_inches = 210 / 25.4  # A4 宽度
height_in_inches = 297 / 25.4 # A4 高度
fig = plt.figure(dpi=600, figsize=(width_in_inches, height_in_inches))

from matplotlib.colors import BoundaryNorm
levels = np.array([1.0, 1.3, 3.0, 5.0, 8.0, 12.0, 20])
norm = BoundaryNorm(levels, ncolors=plt.get_cmap("OrRd").N, clip=False)


# ==============================================================================
# 【上面三张图：le2kkm】(ax1, ax2, ax3) -> 标记 (a), (b), (c)
# ==============================================================================

# ----------------- ax1 (le2kkm) -----------------
ax1 = plt.axes([0.05, 0.55, 0.25, 0.12])
create_map(ax1)

y = np.arange(Alink_strength_le.shape[0])
x = np.arange(Alink_strength_le.shape[1])

cf1 = ax1.pcolormesh(
    x, y, Alink_strength_le,
    cmap="OrRd", norm=norm, shading="nearest", edgecolors="none"
)
cbar1 = fig.colorbar(cf1, ax=ax1, orientation="vertical", label="", extend="both", pad=0.035, fraction=0.07, shrink=1.0)
for t in cbar1.ax.get_yticklabels():
    t.set_fontsize(6.5)

ax1.set_xticks(np.linspace(0, 22, 12), minor=True)
ax1.set_xticks([0, 10, 20]); ax1.set_xticklabels(["1982-2003", "1992-2013", "2002-2023"])
ax1.set_yticks(np.linspace(0, 24, 9), minor=True)
ax1.set_yticks([0, 6, 12, 18, 24]); ax1.set_yticklabels(["0", "6", "12", "18", "24"])
ax1.set_ylabel("Lagged months", size=7.5)
ax1.set_xlabel("22-year window", size=7.5)
ax1.set_title("Amplified ratio (≤2000 km)", size=8.0)

# ----------------- ax2 (le2kkm) -----------------
x_win = np.linspace(0, 23, 24)
ax2 = plt.axes([0.38, 0.55, 0.25, 0.12])
create_map(ax2)
ax2.set_xlabel('22-year window', size=7.5)
ax2.set_ylabel('Ratio', size=7.5)
ax2.set_xticks(np.linspace(0, 22, 12), minor=True)
ax2.set_xticks([0, 10, 20]); ax2.set_xticklabels(["1982-2003", "1992-2013", "2002-2023"])
ax2.set_yticks(np.linspace(0, 17, 18), minor=True)
ax2.set_yticks(np.linspace(0, 15, 6)); ax2.set_yticklabels([0, 3, 6, 9, 12, 15], color='black')
ax2.set_ylim(0.0, 11.0)
ax2.set_xlim(-1.0, 23.0)
ax2.plot([-1.0, 35.0], [1.0, 1.0], color='black', linewidth=0.8, linestyle='-', alpha=0.35)
ax2.plot(x_win[0:23], link_strength0_le[0, :], label='lag = 0 day', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=0.72, linewidth=1.0, markersize=4.2, linestyle='--')
ax2.plot(x_win[0:23], link_strength0_le[12, :], label='lag = 12 months', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=0.62, linewidth=1.0, markersize=4.65, linestyle='--')
ax2.legend(loc=(0.07, 0.45), fontsize=7.0, frameon=False)
ax2.set_title("Amplified Synchrony (≤2000 km)", size=8.0)

# ----------------- ax3 (le2kkm) -----------------
x_lag = np.linspace(0, 24, 25)
ax3 = plt.axes([0.71, 0.55, 0.25, 0.12])
create_map(ax3)
ax3.set_xlabel('Lagged months', size=7.5)
ax3.set_ylabel('Ratio', size=7.5)
ax3.set_yscale('log')
ax3.set_xticks(np.linspace(0, 24, 13), minor=True)
ax3.set_xticks([0, 4, 8, 12, 16, 20, 24]); ax3.set_xticklabels(["0", "4", "8", "12", "16", "20", "24"])
ax3.set_yticks(np.linspace(0.3, 1.1, 9), minor=True); ax3.set_yticklabels([""]*9, minor=True)
ax3.set_yticks([0.1, 0.4, 0.7, 1.0]); ax3.set_yticklabels(["10%", "40%", "70%", "100%"])
ax3.set_ylim(0.05, 1.10)
ax3.set_xlim(0.0, 24.0)
ax3.plot(x_lag, np.linspace(1.0, 1.0, 25), color='black', linewidth=0.8, linestyle='-', alpha=0.35)

line1_le, = ax3.plot(x_lag, link_strength_le[:, 22], label='2004-2025', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='o', markeredgewidth=0.5, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.9)
line2_le, = ax3.plot(x_lag, link_strength_le[:, 18], label='2000-2021', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='^', markeredgewidth=0.6, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.9)
line3_le, = ax3.plot(x_lag, link_strength_le[:, 12], label='1994-2005', color='#009E74', markerfacecolor='#C0E7DA', markeredgecolor='#009E74', marker='o', markeredgewidth=0.5, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.8)
line4_le, = ax3.plot(x_lag, link_strength_le[:, 6], label='1988-2009', color='#57B4E9', markerfacecolor='#D2ECFA', markeredgecolor='#57B4E9', marker='^', markeredgewidth=0.6, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.8)
line5_le, = ax3.plot(x_lag, link_strength_le[:, 0], label='1982-2003', color='#333a8c', markerfacecolor='#989CC8', markeredgecolor='#333a8c', marker='o', markeredgewidth=0.5, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.8)

leg1 = ax3.legend(handles=[line1_le, line2_le, line3_le, line4_le], loc=(0.55, 0.52), fontsize=6.6, frameon=False)
leg2 = ax3.legend(handles=[line5_le], loc=(0.55, 0.24), fontsize=6.6, frameon=False)
ax3.add_artist(leg1)
ax3.set_title("Lagged difference (≤2000 km)", size=8.0)

# 上排子图字母标注
ax1.text(-0.18, 1.13, 'a', transform=ax1.transAxes, fontweight='bold', fontsize=11)
ax2.text(-0.18, 1.13, 'b', transform=ax2.transAxes, fontweight='bold', fontsize=11)
ax3.text(-0.18, 1.13, 'c', transform=ax3.transAxes, fontweight='bold', fontsize=11)





# ==============================================================================
# 【下面三张图：gt2kkm】(ax4, ax5, ax6) -> 标记 (d), (e), (f)
# ==============================================================================

# ----------------- ax4 (gt2kkm) -----------------
ax4 = plt.axes([0.05, 0.35, 0.25, 0.12])
create_map(ax4)

y = np.arange(Alink_strength_gt.shape[0])
x = np.arange(Alink_strength_gt.shape[1])

cf2 = ax4.pcolormesh(
    x, y, Alink_strength_gt,
    cmap="OrRd", norm=norm, shading="nearest", edgecolors="none"
)
cbar2 = fig.colorbar(cf2, ax=ax4, orientation="vertical", label="", extend="both", pad=0.035, fraction=0.07, shrink=1.0)
for t in cbar2.ax.get_yticklabels():
    t.set_fontsize(6.5)

ax4.set_xticks(np.linspace(0, 22, 12), minor=True)
ax4.set_xticks([0, 10, 20]); ax4.set_xticklabels(["1982-2003", "1992-2013", "2002-2023"])
ax4.set_yticks(np.linspace(0, 24, 9), minor=True)
ax4.set_yticks([0, 6, 12, 18, 24]); ax4.set_yticklabels(["0", "6", "12", "18", "24"])
ax4.set_ylabel("Lagged months", size=7.5)
ax4.set_xlabel("22-year window", size=7.5)
ax4.set_title("Amplified ratio (>2000 km)", size=8.0)

# ----------------- ax5 (gt2kkm) -----------------
ax5 = plt.axes([0.38, 0.35, 0.25, 0.12])
create_map(ax5)
ax5.set_xlabel('22-year window', size=7.5)
ax5.set_ylabel('Ratio', size=7.5)
ax5.set_xticks(np.linspace(0, 22, 12), minor=True)
ax5.set_xticks([0, 10, 20]); ax5.set_xticklabels(["1982-2003", "1992-2013", "2002-2023"])
ax5.set_yticks(np.linspace(0, 17, 18), minor=True)
ax5.set_yticks(np.linspace(0, 15, 6)); ax5.set_yticklabels([0, 3, 6, 9, 12, 15], color='black')
ax5.set_ylim(0.0, 17.0)
ax5.set_xlim(-1.0, 23.0)
ax5.plot([-1.0, 35.0], [1.0, 1.0], color='black', linewidth=0.8, linestyle='-', alpha=0.35)
ax5.plot(x_win[0:23], link_strength0_gt[0, :], label='lag = 0 day', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='o', markeredgewidth=0.72, linewidth=1.0, markersize=4.2, linestyle='--')
ax5.plot(x_win[0:23], link_strength0_gt[12, :], label='lag = 12 months', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='^', markeredgewidth=0.62, linewidth=1.0, markersize=4.65, linestyle='--')
ax5.legend(loc=(0.07, 0.45), fontsize=7.0, frameon=False)
ax5.set_title("Amplified Synchrony (>2000 km)", size=8.0)

# ----------------- ax6 (gt2kkm) -----------------
ax6 = plt.axes([0.71, 0.35, 0.25, 0.12])
create_map(ax6)
ax6.set_xlabel('Lagged months', size=7.5)
ax6.set_ylabel('Ratio', size=7.5)
ax6.set_yscale('log')
ax6.set_xticks(np.linspace(0, 24, 13), minor=True)
ax6.set_xticks([0, 4, 8, 12, 16, 20, 24]); ax6.set_xticklabels(["0", "4", "8", "12", "16", "20", "24"])
ax6.set_yticks(np.linspace(0.3, 1.1, 9), minor=True); ax6.set_yticklabels([""]*9, minor=True)
ax6.set_yticks([0.4, 0.6, 0.8, 1.0]); ax6.set_yticklabels(["40%", "60%", "80%", "100%"])
ax6.set_ylim(0.40, 1.10)
ax6.set_xlim(0.0, 24.0)
ax6.plot(x_lag, np.linspace(1.0, 1.0, 25), color='black', linewidth=0.8, linestyle='-', alpha=0.35)

line1_gt, = ax6.plot(x_lag, link_strength_gt[:, 22], label='2004-2025', color='#B83945', markerfacecolor='#DB9BA1', markeredgecolor='#B83945', marker='o', markeredgewidth=0.5, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.9)
line2_gt, = ax6.plot(x_lag, link_strength_gt[:, 18], label='2000-2021', color='#E59F05', markerfacecolor='#F6E3BA', markeredgecolor='#E59F05', marker='^', markeredgewidth=0.6, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.9)
line3_gt, = ax6.plot(x_lag, link_strength_gt[:, 12], label='1994-2005', color='#009E74', markerfacecolor='#C0E7DA', markeredgecolor='#009E74', marker='o', markeredgewidth=0.5, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.8)
line4_gt, = ax6.plot(x_lag, link_strength_gt[:, 6], label='1988-2009', color='#57B4E9', markerfacecolor='#D2ECFA', markeredgecolor='#57B4E9', marker='^', markeredgewidth=0.6, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.8)
line5_gt, = ax6.plot(x_lag, link_strength_gt[:, 0], label='1982-2003', color='#333a8c', markerfacecolor='#989CC8', markeredgecolor='#333a8c', marker='o', markeredgewidth=0.5, linewidth=0.9, markersize=3.8, linestyle='-', alpha=0.8)

leg3 = ax6.legend(handles=[line1_gt, line2_gt], loc=(0.56, 0.615), fontsize=6.6, frameon=False)
leg4 = ax6.legend(handles=[line3_gt, line4_gt, line5_gt], loc=(0.04, 0.04), fontsize=6.6, frameon=False)
ax6.add_artist(leg3)
ax6.set_title("Lagged difference (>2000 km)", size=8.0)

# 下排子图字母标注
ax4.text(-0.18, 1.13, 'd', transform=ax4.transAxes, fontweight='bold', fontsize=11)
ax5.text(-0.18, 1.13, 'e', transform=ax5.transAxes, fontweight='bold', fontsize=11)
ax6.text(-0.18, 1.13, 'f', transform=ax6.transAxes, fontweight='bold', fontsize=11)





fig.savefig('6_supplementary/FigureS3_teleconnection.png', bbox_inches = 'tight')
plt.show()




