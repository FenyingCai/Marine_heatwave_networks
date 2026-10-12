

import plotly.graph_objects as go
from plotly.subplots import make_subplots
import xarray as xr
import numpy as np



labels = [" TEP ", " TNA ", " TSA ", " TIO ", " NEP ", " SEP ", "WNP", 
          " TEP ", " TNA ", " TSA ", " TIO ", " NEP ", " SEP ", "WNP"]

source = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 
          3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5]
target = [7, 8, 9, 10, 11, 12, 13, 7, 8, 9, 10, 11, 12, 13, 7, 8, 9, 10, 11, 12, 13, 
          7, 8, 9, 10, 11, 12, 13, 7, 8, 9, 10, 11, 12, 13, 7, 8, 9, 10, 11, 12, 13]


ds1 = xr.open_dataset("5_analysis_gt015/fig3_degree_gt015/Flow_6regions_lag0to24mons_2004_2025_gt015.nc")

flow6 = ds1.flow[6,:,:].data
flow_6mon = np.zeros(49)
for i in range(7): flow6[i,i] = 0
flow_6mon[0:7] = flow6[0,:] - flow6[:,0]
flow_6mon[7:14] = flow6[1,:] - flow6[:,1]
flow_6mon[14:21] = flow6[2,:] - flow6[:,2]
flow_6mon[21:28] = flow6[3,:] - flow6[:,3]
flow_6mon[28:35] = flow6[4,:] - flow6[:,4]
flow_6mon[35:42] = flow6[5,:] - flow6[:,5]
flow_6mon[42:49] = flow6[6,:] - flow6[:,6]

flow12 = ds1.flow[12,:,:].data
flow_12mon = np.zeros(49)
for i in range(7): flow12[i,i] = 0
flow_12mon[0:7] = flow12[0,:] - flow12[:,0]
flow_12mon[7:14] = flow12[1,:] - flow12[:,1]
flow_12mon[14:21] = flow12[2,:] - flow12[:,2]
flow_12mon[21:28] = flow12[3,:] - flow12[:,3]
flow_12mon[28:35] = flow12[4,:] - flow12[:,4]
flow_12mon[35:42] = flow12[5,:] - flow12[:,5]
flow_12mon[42:49] = flow12[6,:] - flow12[:,6]










##--------------------------------------------- Plot  --------------------------------------------##
fig = make_subplots(rows=1, cols=1, specs=[[{'type':'sankey'}]])


colors = ["#2b2a76","#73aa43","#f3c80d","#a21d2f","#2b2a76","#73aa43","#f3c80d","#a21d2f"]  ## 深色
# colors = ["#E59F05","#1B78B2","#CDD9EC","#009E74","#B83945","#DB9BA1","#A577AD",\
#           "#E59F05","#1B78B2","#CDD9EC","#009E74","#B83945","#DB9BA1","#A577AD"]
colors = ["#f6bf5c","#1E4E9E","#7BCBF1","#009E74","#B83945","#F599A1","#A577AD",\
          "#f6bf5c","#1E4E9E","#7BCBF1","#009E74","#B83945","#F599A1","#A577AD"]

Sankey2 = go.Sankey(
node=dict(pad=15, thickness=20, color=colors,
          line=dict(color="black", width=0.5),label=labels),
link=dict(source=source, target=target, value=flow_6mon, color='rgba(128,128,128,0.2)'))

fig.add_trace(Sankey2, row=1, col=1)






fig.update_layout(
    font=dict(color='black', size=20),
    width = 330,
    height = 250,
    
    title=dict(
    text='',#'Flow    among    three    oceans',
    x=0.5,
    y=0.995,
    xanchor='center',
    font=dict(color='black', size=20)),
    margin=dict(l=10,r=10,t=10,b=10)
)




fig.write_image('5_analysis_gt015/Figure3b_flow_gt015.png', scale=4)

