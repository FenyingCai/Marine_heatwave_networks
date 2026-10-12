import xarray as xr
import matplotlib.pyplot as plt

# 读取 nc 文件
ds = xr.open_dataset(
    "2_networks/"
    "mhw_mhw_coincidence_shuffled/network_sqrt_ratio_re95_re99.nc"
)

# 读取变量
re95 = ds["re95_across"]
re99 = ds["re99_across"]

# 绘图
fig, axes = plt.subplots(2, 1, figsize=(12, 8))

# 第一张图
p1 = re95.plot(
    ax=axes[0],
    cmap="RdBu_r",
    cbar_kwargs={"pad": 0.015},   # colorbar 离图更近
    vmin=0.085, vmax=0.205
)
axes[0].set_title(
    "The  95th  percentile  of  shuffled  networks",
    fontsize=16
)

# 第二张图
p2 = re99.plot(
    ax=axes[1],
    cmap="RdBu_r",
    cbar_kwargs={"pad": 0.015},
    vmin=0.085, vmax=0.205
)
axes[1].set_title(
    "The  99th  percentile  of  shuffled  networks",
    fontsize=16
)

# colorbar 设置
for p in [p1, p2]:
    cbar = p.colorbar

    # 去掉 re95_across / re99_across
    cbar.set_label("")

    # colorbar 刻度字体
    cbar.ax.tick_params(labelsize=12.0)

for ax, data in zip(axes, [re95, re99]):

    ax.set_xticks([0, 5, 10, 15, 20])
    ax.set_yticks(range(7))

    ax.set_xticklabels(
        ["1982–2003", "1987–2008", "1992–2013",
         "1997–2018", "2002–2023"],
        fontsize=12
    )

    ax.set_yticklabels(
        [0, 4, 8, 12, 16, 20, 24],
        fontsize=12
    )

    ax.set_xlabel("22-year window", fontsize=14.0)
    ax.set_ylabel("Lagged months", fontsize=14.0)

    # 每个方格中添加数值
    for i in range(data.shape[0]):
        for j in range(data.shape[1]):
            value = data.values[i, j]

            if value != -999:
                ax.text(
                    j, i,
                    f"{value:.2f}",
                    ha="center",
                    va="center",
                    fontsize=9.5
                )


axes[0].text(
    -1.5, 7.55,
    "a",
    ha="center",       # 水平居中
    va="center",       # 垂直居中
    fontsize=19.5,        # 字号
    fontweight="bold", # 加粗
    color="black"      # 字体颜色
)
axes[1].text(
    -1.5, 7.55,
    "b",
    ha="center",       # 水平居中
    va="center",       # 垂直居中
    fontsize=19.5,        # 字号
    fontweight="bold", # 加粗
    color="black"      # 字体颜色
)


# 调整整体布局
plt.tight_layout()

# 增大上下两张图之间的距离
plt.subplots_adjust(hspace=0.45)

# 保存 PNG
plt.savefig(
    "6_supplementary/"
    "FigureS4_network_sqrt_re95_re99.png",
    dpi=300,
    bbox_inches="tight"
)

plt.show()