load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin


f0 = addfile("topography/topo_2x2.nc","r")
topo0 = f0->topo
dim_0 = dimsizes(topo0)
lat = topo0&lat
lon = topo0&lon
ocean = where(topo0.lt.0.0, 1.0, 0.0)
copy_VarCoords(topo0, ocean)


mld0 = new((/44,12,418,360/), float)
do iyear = 0,43
    year_str = flt2string(iyear+1982)
    fin = addfile("GODAS_monthly/dbss_obml/dbss_obml."+year_str+".nc", "r")
    mld0(iyear,:,:,:) = fin->dbss_obml
end do
; mld0 = dim_rmvmean_n_Wrap(mld0, 0)
mld = new((/44*12,418,360/), float)
do iyear = 0,43
mld(iyear*12:iyear*12+11,:,:) = mld0(iyear,:,:,:)
end do



;;-----------------------------------------------------------------------------------------------------------;;
f1 = addfile("4_mixed_layer_budget_ORAS5/Temp_tendency.nc","r")
dTdt = f1->dTdt

f1 = addfile("4_mixed_layer_budget_ORAS5/Flux_Q.nc","r")
Q = f1->Q
printMinMax(Q, 1)


f1 = addfile("4_mixed_layer_budget_ORAS5/Mixed_Layer_budget1.nc","r")
UATXB = f1->UATXB
VATYB = f1->VATYB
WATZB = f1->WATZB
f1 = addfile("4_mixed_layer_budget_ORAS5/Mixed_Layer_budget2.nc","r")
UBTXA = f1->UBTXA
VBTYA = f1->VBTYA
WBTZA = f1->WBTZA
f1 = addfile("4_mixed_layer_budget_ORAS5/Mixed_Layer_budget3.nc","r")
UATXA = f1->UATXA
VATYA = f1->VATYA
WATZA = f1->WATZA

UV = (UATXB+VATYB + UBTXA+VBTYA + UATXA+VATYA)
WW = (WATZB + WBTZA + WATZA)
copy_VarCoords(UATXB, UV)
copy_VarCoords(UATXB, WW)
value = 1.0e20
dTdt@_FillValue = 1.0e20
if (any(isnan_ieee(dTdt))) then
      replace_ieeenan (dTdt, value, 0)
      dTdt@_FillValue = value
end if
copy_VarCoords(Q, dTdt)
Q@_FillValue = 1.0e20
if (any(isnan_ieee(Q))) then
      replace_ieeenan (Q, value, 0)
      Q@_FillValue = value
end if
copy_VarCoords(dTdt, Q)
UV@_FillValue = 1.0e20
if (any(isnan_ieee(UV))) then
      replace_ieeenan (UV, value, 0)
      UV@_FillValue = value
end if
copy_VarCoords(dTdt, UV)
WW@_FillValue = 1.0e20
if (any(isnan_ieee(WW))) then
      replace_ieeenan (WW, value, 0)
      WW@_FillValue = value
end if
copy_VarCoords(dTdt, WW)



do imon = 0, 44*12-1,12
print(" -------------- min, max ------------- ")
printMinMax(dTdt(imon,:,:), 1)
printMinMax(Q(imon,:,:), 1)
printMinMax(UV(imon,:,:), 1)
printMinMax(WW(imon,:,:), 1)
print("---------------------------------------")
end do





; start1 = 181-1
; end1 = 192-1
; start1 = 327-1
; end1 = 338-1
; start1 = 396-1
; end1 = 408-1
; start1 = 496-1
; end1 = 501-1
ilagg0 = 0
ilagg = 0
idx1 = ispan(181-1+ilagg0, 192-1+ilagg, 1)
idx2 = ispan(327-1+ilagg0, 338-1+ilagg, 1)
idx3 = ispan(396-1+ilagg0, 408-1+ilagg, 1)
idx4 = ispan(493-1+ilagg0, 501-1+ilagg, 1)
all_idx = array_append_record(idx1, idx2, 0)
all_idx := array_append_record(all_idx, idx3, 0)
all_idx := array_append_record(all_idx, idx4, 0)
dTdt_ = dTdt(all_idx,:,:)
Q_ = Q(all_idx,:,:)
UV_ = UV(all_idx,:,:)
WW_ = WW(all_idx,:,:)
mld_ = mld(all_idx,:,:)

dTdt_P0 = dim_avg_n_Wrap(dTdt_, 0)
Q_P0 = dim_avg_n_Wrap(Q_, 0)
UV_P0 = dim_avg_n_Wrap(UV_, 0)
WW_P0 = dim_avg_n_Wrap(WW_, 0)
mld_P0 = dim_avg_n_Wrap(mld_, 0)
dTdt_P0 = dim_avg_n_Wrap(dTdt_, 0)
Rest_P0 = dTdt_P0 - Q_P0 - UV_P0 - WW_P0

; Q_P0 = where(dTdt_P0.gt.0.0, Q_P0, 0.0)
; UV_P0 = where(dTdt_P0.gt.0.0, UV_P0, 0.0)
; WW_P0 = where(dTdt_P0.gt.0.0, WW_P0, 0.0)
; Rest_P0 = where(dTdt_P0.gt.0.0, Rest_P0, 0.0)
copy_VarCoords(dTdt_P0, Q_P0)
copy_VarCoords(dTdt_P0, UV_P0)
copy_VarCoords(dTdt_P0, WW_P0)
copy_VarCoords(dTdt_P0, Rest_P0)
UVW_P0 = UV_P0 + WW_P0
copy_VarCoords(dTdt_P0, UVW_P0)














IO_lat1=-20
IO_lat2=20
IO_lon1=50+5
IO_lon2=95+5
EP_lat1=-10
EP_lat2=10
EP_lon1=190-360
EP_lon2=280-360
TNA_lat1=5
TNA_lat2=30
TNA_lon1=290-360
TNA_lon2=350-360
TSA_lat1=-25
TSA_lat2=0
TSA_lon1=320-360
TSA_lon2=370-360

IO_budget = new(5, float)
EP_budget = new(5, float)
TNA_budget = new(5, float)
TSA_budget = new(5, float)
IO_budget(0) = dim_sum(dim_sum(dTdt_P0({IO_lat1:IO_lat2},{IO_lon1:IO_lon2}))) / dim_sum(dim_sum(ocean({IO_lat1:IO_lat2},{IO_lon1:IO_lon2})))
IO_budget(1) = dim_sum(dim_sum(Q_P0({IO_lat1:IO_lat2},{IO_lon1:IO_lon2}))) / dim_sum(dim_sum(ocean({IO_lat1:IO_lat2},{IO_lon1:IO_lon2})))
IO_budget(2) = dim_sum(dim_sum(UV_P0({IO_lat1:IO_lat2},{IO_lon1:IO_lon2}))) / dim_sum(dim_sum(ocean({IO_lat1:IO_lat2},{IO_lon1:IO_lon2})))
IO_budget(3) = dim_sum(dim_sum(WW_P0({IO_lat1:IO_lat2},{IO_lon1:IO_lon2}))) / dim_sum(dim_sum(ocean({IO_lat1:IO_lat2},{IO_lon1:IO_lon2})))
IO_budget(4) = dim_sum(dim_sum(Rest_P0({IO_lat1:IO_lat2},{IO_lon1:IO_lon2}))) / dim_sum(dim_sum(ocean({IO_lat1:IO_lat2},{IO_lon1:IO_lon2})))
EP_budget(0) = dim_sum(dim_sum(dTdt_P0({EP_lat1:EP_lat2},{EP_lon1:EP_lon2}))) / dim_sum(dim_sum(ocean({EP_lat1:EP_lat2},{EP_lon1+360:EP_lon2+360})))
EP_budget(1) = dim_sum(dim_sum(Q_P0({EP_lat1:EP_lat2},{EP_lon1:EP_lon2}))) / dim_sum(dim_sum(ocean({EP_lat1:EP_lat2},{EP_lon1+360:EP_lon2+360})))
EP_budget(2) = dim_sum(dim_sum(UV_P0({EP_lat1:EP_lat2},{EP_lon1:EP_lon2}))) / dim_sum(dim_sum(ocean({EP_lat1:EP_lat2},{EP_lon1+360:EP_lon2+360})))
EP_budget(3) = dim_sum(dim_sum(WW_P0({EP_lat1:EP_lat2},{EP_lon1:EP_lon2}))) / dim_sum(dim_sum(ocean({EP_lat1:EP_lat2},{EP_lon1+360:EP_lon2+360})))
EP_budget(4) = dim_sum(dim_sum(Rest_P0({EP_lat1:EP_lat2},{EP_lon1:EP_lon2}))) / dim_sum(dim_sum(ocean({EP_lat1:EP_lat2},{EP_lon1+360:EP_lon2+360})))
TNA_budget(0) = dim_sum(dim_sum(dTdt_P0({TNA_lat1:TNA_lat2},{TNA_lon1:TNA_lon2}))) / dim_sum(dim_sum(ocean({TNA_lat1:TNA_lat2},{TNA_lon1+360:TNA_lon2+360})))
TNA_budget(1) = dim_sum(dim_sum(Q_P0({TNA_lat1:TNA_lat2},{TNA_lon1:TNA_lon2}))) / dim_sum(dim_sum(ocean({TNA_lat1:TNA_lat2},{TNA_lon1+360:TNA_lon2+360})))
TNA_budget(2) = dim_sum(dim_sum(UV_P0({TNA_lat1:TNA_lat2},{TNA_lon1:TNA_lon2}))) / dim_sum(dim_sum(ocean({TNA_lat1:TNA_lat2},{TNA_lon1+360:TNA_lon2+360})))
TNA_budget(3) = dim_sum(dim_sum(WW_P0({TNA_lat1:TNA_lat2},{TNA_lon1:TNA_lon2}))) / dim_sum(dim_sum(ocean({TNA_lat1:TNA_lat2},{TNA_lon1+360:TNA_lon2+360})))
TNA_budget(4) = dim_sum(dim_sum(Rest_P0({TNA_lat1:TNA_lat2},{TNA_lon1:TNA_lon2}))) / dim_sum(dim_sum(ocean({TNA_lat1:TNA_lat2},{TNA_lon1+360:TNA_lon2+360})))
TSA_budget(0) = dim_sum(dim_sum(dTdt_P0({TSA_lat1:TSA_lat2},{TSA_lon1:TSA_lon2}))) / dim_sum(dim_sum(ocean({TSA_lat1:TSA_lat2},{TSA_lon1+360:TSA_lon2+360})))
TSA_budget(1) = dim_sum(dim_sum(Q_P0({TSA_lat1:TSA_lat2},{TSA_lon1:TSA_lon2}))) / dim_sum(dim_sum(ocean({TSA_lat1:TSA_lat2},{TSA_lon1+360:TSA_lon2+360})))
TSA_budget(2) = dim_sum(dim_sum(UV_P0({TSA_lat1:TSA_lat2},{TSA_lon1:TSA_lon2}))) / dim_sum(dim_sum(ocean({TSA_lat1:TSA_lat2},{TSA_lon1+360:TSA_lon2+360})))
TSA_budget(3) = dim_sum(dim_sum(WW_P0({TSA_lat1:TSA_lat2},{TSA_lon1:TSA_lon2}))) / dim_sum(dim_sum(ocean({TSA_lat1:TSA_lat2},{TSA_lon1+360:TSA_lon2+360})))
TSA_budget(4) = dim_sum(dim_sum(Rest_P0({TSA_lat1:TSA_lat2},{TSA_lon1:TSA_lon2}))) / dim_sum(dim_sum(ocean({TSA_lat1:TSA_lat2},{TSA_lon1+360:TSA_lon2+360})))
IO_budget = IO_budget * 10.0
EP_budget = EP_budget * 10.0
TNA_budget = TNA_budget * 10.0
TSA_budget = TSA_budget * 10.0
print(IO_budget)
print(EP_budget)
print(TNA_budget)
print(TSA_budget)










;;---------------------------------------------------  plots  ---------------------------------------------------
res = True
res@tmBorderThicknessF = 1.1
res@gsnDraw      =  False
res@gsnFrame     =  False
res@gsnAddCyclic =  True
res@gsnRightString       = ""
res@gsnLeftString        = ""
res@gsnLeftStringFontHeightF   = 0.04
res@gsnRightStringFontHeightF  = 0.04
res@gsnCenterStringFontHeightF  = 0.04
res@tmXTLabelsOn  = False
res@tmYRLabelsOn  = False
vcres = res
cnres = res
cnres@gsnAddCyclic =  False
res@tmXTOn        = False
res@tmYROn        = False
res@tmXBOn        = True
res@tmYLOn        = True
; res@tmXBLabelFontHeightF = 0.038
; res@tmYLLabelFontHeightF = 0.038
res@tmXBTickSpacingF = 45.0
res@tmYLTickSpacingF = 20.0


res@gsFontName = "Helvetica"
res@tiMainFont = "Helvetica"
res@tiXAxisFont = "Helvetica"
res@tiYAxisFont = "Helvetica"
res@tmXBLabelFont = "Helvetica"
res@tmYLLabelFont = "Helvetica"





; res@mpMinLatF = -60
; res@mpMaxLatF = 60
; res@mpMinLonF = 0
; res@mpMaxLonF = 360
; res@mpCenterLonF = 180+30
; res@tmXBMode = "Explicit"
; res@tmXBValues = (/-135,-90,-45,0,45,90,135,180,225,360,315,360/)
; res@tmXBLabels = (/"135W","90W","45W","0","45E","90E","135E","180","135W","90W","45W","0"/)
; res@tmYLMode = "Explicit"
; res@tmYLValues = (/-90,-60,-30,0,30,60,90/)
; res@tmYLLabels = (/"90S","60S","30S","0","30N","60N","90N"/)
; res@tmXBMinorOn = True
; res@tmXBMinorValues = fspan(-360, 360+15, 49+1)
; res@tmYLMinorOn = True
; res@tmYLMinorValues = fspan(-60, 60, 9)
; res@tmXBLabelsOn = True
; res@tmXBLabelFontHeightF = 0.017
; res@tmYLLabelsOn = True
; res@tmYLLabelFontHeightF = 0.017

res@tmYLMajorThicknessF = 1.3
res@tmXBMajorThicknessF = 1.3
res@tmYLMinorThicknessF = 0.9
res@tmXBMinorThicknessF = 0.9
res@tmYLMajorLengthF = 0.014
res@tmXBMajorLengthF = 0.014
res@tmYLMinorLengthF = 0.01
res@tmXBMinorLengthF = 0.01
res@tmXBLabelDeltaF = -0.35
res@tmYLLabelDeltaF = -0.35
res@tmXBMajorOutwardLengthF = 0.014
res@tmYLMajorOutwardLengthF = 0.014
res@tmXBMinorOutwardLengthF = 0.01
res@tmYLMinorOutwardLengthF = 0.01





res@mpFillOn                    = False
res@mpOutlineOn                 = True
res@mpGeophysicalLineThicknessF = 0.4
res@mpGeophysicalLineColor      = "black";"gray20"
;res@mpGridAndLimbOn = True
;res@mpGridLatSpacingF = 90
;res@mpGridLonSpacingF = 360
;res@gsnMaximize = True
res@cnFillOn             = True
res@cnLinesOn            = False
;res@cnLineThicknessF     = 6.0
;res@cnLineColor          = "red"
res@cnLineLabelsOn       = False
res@lbLabelBarOn         = False
res@lbOrientation        = "Vertical"
res@pmLabelBarWidthF     = 0.045
res@pmLabelBarHeightF    = 0.14
res@pmLabelBarOrthogonalPosF = 0.012
res@lbLabelFontHeightF  = 0.015
;res@cnMissingValFillColor = "white"
;res@gsnYRefLine = 0.0
;res@gsnYRefLineColor = "black"
;res@gsnYRefLineThicknessF = 5.0
res@cnMissingValFillColor = -1
res@cnLevelSelectionMode = "ExplicitLevels"              
; res@cnLevels             = (/140.0,155.0,170.0,185.0,200.0,215.0,220.0,245.0/)
; res@cnFillColors         = (/16,15,13,12,8,6,5,3,-1/)
res@cnFillPalette        = "precip2_17lev" 



;vcres@mpFillDrawOrder         = "PostDraw"
vcres@vcRefAnnoOrthogonalPosF = -0.255
;vcres@vcRefAnnoSide           = "TopRight"
vcres@vcGlyphStyle            = "LineArrow"
vcres@vcRefAnnoArrowLineColor   = "black"         ; change ref vector color
vcres@vcRefAnnoArrowUseVecColor = False           ; don't use vec color for ref
vcres@vcMinDistanceF          = 0.03             ; thin out vectors
vcres@vcLineArrowColor        = "black"           ; change vector color
vcres@vcRefAnnoOn             = True
vcres@vcRefLengthF            = 0.022            ; ref vec length
vcres@vcRefAnnoFontHeightF    = 0.014   ;参考箭头字体大小
vcres@vcRefAnnoString1On      = True
vcres@vcRefAnnoString2On      = False
vcres@vcLineArrowThicknessF   = 3.0            ; make vectors larger
vcres@vcVectorDrawOrder = "PostDraw"
vcres@vcRefAnnoOrthogonalPosF = -0.26 ;;正向下
vcres@vcRefAnnoParallelPosF   = 1.0  ;;正向右
vcres@vcRefAnnoString1        = "1"
vcres@vcRefMagnitudeF         = 1



sres = True
sres@cnLineLabelsOn   = False
sres@cnConstFLabelOn  = False
sres@cnInfoLabelOn    = False 
sres@gsnDraw          = False                   
sres@gsnFrame         = False
sres@gsnLeftString    = ""
sres@gsnRightString   = ""
sres@lbLabelBarOn = False
sres@cnFillOn  = False
sres@cnLinesOn = True
sres2 = sres
sres3 = sres
sres@cnLineColor = "red"
sres@cnLevelSelectionMode = "ExplicitLevels"
; sres@cnLevels         = (/3600.0/)
; sres@cnFillColors     = (/"red","gray20"/)
sres@cnMissingValFillColor= -1
sres@cnLineThicknessF = 6.0
sres@cnLineDashPattern = 14


sres2@cnLevelSelectionMode = "ExplicitLevels"
sres2@cnLevels         = (/2/)
sres2@cnLineColor = "blue"
sres2@cnLineDashPattern = 14
sres2@cnLineThicknessF = 4
; sres2@cnLineColors     = (/"red","red","red","red"/)
; sres2@cnLineDashPatterns = (/16,16,16,0,0,0,0/)
; sres2@cnLineThicknesses = (/4,4,4,4,4,4,4/)











lires = True
lires@tmBorderThicknessF = 1.1
lires@gsnDraw        = False
lires@gsnFrame       = False
lires@tiXAxisOn      = False
lires@tiYAxisOn      = False
lires@tmXTLabelsOn   = False
lires@tmXTOn         = False

; --- 坐标轴范围设置 ---
lires@trYMaxF        = 2.5
lires@trYMinF        = -1.0
lires@trXMaxF        = 5.65
lires@trXMinF        = 0.35

; --- 字体大小与刻度标签设置 ---
lires@tmXBLabelFontHeightF     = 0.042
lires@tmYLLabelFontHeightF     = 0.042
lires@tmYRLabelFontHeightF     = 0.042
lires@gsnLeftStringFontHeightF  = 0.025
lires@gsnRightStringFontHeightF = 0.025

lires@tmYRLabelsOn   = False
lires@tmYROn         = False
lires@tmYLOn         = True
lires@tmYLLabelsOn   = True
lires@tmYLMode       = "Explicit"
lires@tmXBMode       = "Explicit"
lires@gsnYRefLine = 0.0
lires@tmXBValues = (/1,2,3,4,5/)
lires@tmXBLabels = (/"TD","Qnet"," Hadv","Vert","Res"/)
lires@tmYLValues = (/-1,0,1,2/)
lires@tmYLLabels = (/-1,0,1,2/)
lires@tmYLMinorValues = (/-1,-0.5,0,0.5,1.0,1.5,2.0,2.5/)

; --- 视口与图例设置 ---
lires@lgPerimOn          = False
lires@lgLabelFontHeightF = 0.018
lires@vpWidthF           = 0.99
lires@vpHeightF          = 0.50
lires@vpXF               = 0.06
lires@vpYF               = 0.75

lires@gsnLeftString      = ""
lires@gsnRightString     = ""

; =========================================================
; 重点修改：开启并配置柱状图 (Bar Chart)
; =========================================================
lires@gsnXYBarChart         = True           ; 开启柱状图模式
lires@gsnXYBarChartBarWidth = 0.55            ; 设置柱子宽度 (取值 0~1，默认约 0.8)

; --- 场景 1：如果只有 1 组数据（单颜色或多颜色）---
; lires@gsnXYBarChartColors   = "DeepSkyBlue"  ; 单色填充（支持颜色名或 RGB）
; lires@gsnXYBarChartColors  = (/"red","blue","orange", .../) ; 12个柱子各用一个颜色

; --- 场景 2：如果有 3 组对比数据（替代原代码中的 3 条折线）---
; 如果你的 Y 数据是 2D 矩阵 (3, N)，可以使用数组为每组柱子指定颜色：
; lires@gsnXYBarChartColors = (/"red", "blue", "orange"/)

; --- 柱子边框与轮廓控制 ---
lires@gsnXYBarChartOutlineOnly = False      ; True 表示只画柱子轮廓不填充，False 表示填充颜色
lires@gsnXYBarChartOutlineThicknessF = 0.5  ; 柱子边框线的粗细


lires@tmYLMajorThicknessF = 1.2
lires@tmYRMajorThicknessF = 1.2
lires@tmXBMajorThicknessF = 1.2
lires@tmYLMinorThicknessF = 1.0
lires@tmYRMinorThicknessF = 1.0
lires@tmXBMinorThicknessF = 1.0
lires@tmYLMajorLengthF = 0.035
lires@tmYRMajorLengthF = 0.035
lires@tmXBMajorLengthF = 0.035
lires@tmYLMinorLengthF = 0.022
lires@tmYRMinorLengthF = 0.022
lires@tmXBMinorLengthF = 0.022
lires@tmXBLabelDeltaF = -0.25
lires@tmYLLabelDeltaF = -0.25
lires@tmXBMajorOutwardLengthF = 0.035
lires@tmYLMajorOutwardLengthF = 0.035
lires@tmYRMajorOutwardLengthF = 0.035
lires@tmXBMinorOutwardLengthF = 0.022
lires@tmYLMinorOutwardLengthF = 0.022
lires@tmYRMinorOutwardLengthF = 0.022






;;*************************打点***************************;;
ores                 = True   
ores@gsnAddCyclic    =  True         
ores@gsnDraw         = False               
ores@gsnFrame        = False                 
ores@cnLineLabelsOn  = False               
ores@cnLinesOn       = False                 
ores@cnInfoLabelOn   = False                                                                                                        
ores@cnFillOn        = True                               
ores@lbLabelBarOn    = False                                                                                                            
ores@cnLevelSelectionMode = "ExplicitLevels"                                                                                                                                                                                
; ores@cnLevels        = (/14.007/)   ;;90%
; ores@cnLevels        = (/-0.312,0.312/)   ;;95%
ores@cnMonoFillPattern    = False            ; want multiple patterns                                                               
; ores@cnFillPatterns       = (/-1,11/)     ; the patterns                                                                         
ores@cnMonoFillScale      = False            ; want different densities                                                             
; ores@cnFillScales         = (/0.6,0.6/)    ; change densities                                                                         
ores@cnMonoFillColor      =True                                                                                                     
ores@cnFillDotSizeF       = 0.003    
ores@cnFillDrawOrder ="postDraw"
ores@cnFillColor = "black"

ores@cnLevels        = (/0.75/)
; ores@cnLevels        = (/-0.312,0.312/)   ;;95%
ores@cnMonoFillPattern    = False            ; want multiple patterns                                                               
ores@cnFillPatterns       = (/-1,3/)     ; the patterns                                                                         
ores@cnMonoFillScale      = False            ; want different densities                                                             
ores@cnFillScales         = (/0.8,0.8/)    ; change densities   

ores2 = ores
ores2@cnLevels        = (/-1.0/)                                                            
ores2@cnFillPatterns       = (/3,-1/)



;**********************plot**************************;
plot = new(14, "graphic")
plot2 = new(20, "graphic")
plot3 = new(20, "graphic")
plot4 = new(20, "graphic")
vector = new(14, "graphic")
contour1 = new(14, "graphic")
contour2 = new(24, "graphic")
contour3 = new(14, "graphic")
contour4 = new(14, "graphic")
contour5 = new(14, "graphic")
contour6 = new(14, "graphic")
contour7 = new(14, "graphic")
contour8 = new(14, "graphic")
topooo = new(14, "graphic") 








;;------------------------------------------------------------------------------------------------;;
pltType = "eps"
pltName = "5_analysis_gt015/Figure2b_increase_budget"
wks = gsn_open_wks(pltType, pltName)



res@tmXBLabelsOn = True
res@cnMissingValFillColor = -1
; res@cnFillMode = "CellFill"
res@gsnLeftString = ""
res@mpProjection = "Robinson"
res@mpLimitMode = "LatLon"
res@mpPerimOn = False


res@tmYLMajorLengthF = 0.015
res@tmXBMajorLengthF = 0.015
res@tmYLMinorLengthF = 0.0115
res@tmXBMinorLengthF = 0.0115
res@tmXBMajorOutwardLengthF = 0.015
res@tmYLMajorOutwardLengthF = 0.015
res@tmXBMinorOutwardLengthF = 0.0115
res@tmYLMinorOutwardLengthF = 0.0115
res@tmYLLabelsOn = True
res@tmXBLabelFontHeightF = 0.0165
res@tmYLLabelFontHeightF = 0.0165



res@mpMinLatF = -90
res@mpMaxLatF = 90
res@mpMinLonF = 0
res@mpMaxLonF = 360
res@mpCenterLonF = 180+30
res@tmXBMode = "Explicit"
res@cnFillPalette = "cmp_b2r"
res@cnLevels      := (/-0.2,-0.10,-0.03,0.03,0.1,0.2/)
res@cnFillColors  := (/10,17,24,-1,38,48,55/)
res@cnFillColors  := (/12,20,28,-1,36,45,53/)
plot(0) = gsn_csm_contour_map(wks,dTdt_P0, res)

Q_P0 = smth9_Wrap(Q_P0, 0.5, 0.25, True)
; UV_P0 = smth9_Wrap(UV_P0, 0.5, 0.25, True)
; WW_P0 = smth9_Wrap(WW_P0, 0.5, 0.25, True)
UVW_P0 = smth9_Wrap(UVW_P0, 0.5, 0.25, True)
; res@cnFillMode = "CellFill"
plot(1) = gsn_csm_contour_map(wks,Q_P0, res)
plot(2) = gsn_csm_contour_map(wks,UVW_P0, res)
; plot(3) = gsn_csm_contour_map(wks,WW_P0, res)
; plot(4) = gsn_csm_contour_map(wks,Rest_P0, res)

; res@cnLevels      := (/-10,-5,-1,1,5,10/)
; res@cnLevels      := (/20,30,40,50,60,70/)
; plot(5) = gsn_csm_contour_map(wks,mld_P0, res)
; printMinMax(mld_P0, 1)

; colors = (/"#4FA101","#E282A7"/)
; gsn_define_colormap(wks, colors)
lires@gsnAboveYRefLineColor = "Violetred2"
lires@gsnBelowYRefLineColor = "dodgerblue2"
plot(4) = gsn_csm_xy(wks, fspan(1.0, 5.0, 5), EP_budget, lires)
lires@tmYLLabelsOn   = False
plot(5) = gsn_csm_xy(wks, fspan(1.0, 5.0, 5), IO_budget, lires)
plot(6) = gsn_csm_xy(wks, fspan(1.0, 5.0, 5), TNA_budget, lires)
plot(7) = gsn_csm_xy(wks, fspan(1.0, 5.0, 5), TSA_budget, lires)
; gsn_define_colormap(wks, "default")




lnres   =    True
lnres@gsLineThicknessF=1.5
lnres@gsLineDashPattern=0
pl1 = gsn_add_polyline(wks,plot(0),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl2 = gsn_add_polyline(wks,plot(1),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl3 = gsn_add_polyline(wks,plot(2),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl4 = gsn_add_polyline(wks,plot(3),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl5 = gsn_add_polyline(wks,plot(0),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pl6 = gsn_add_polyline(wks,plot(1),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pl7 = gsn_add_polyline(wks,plot(2),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pl8 = gsn_add_polyline(wks,plot(3),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
lnres@gsLineThicknessF=0.75
pl11 = gsn_add_polyline(wks,plot(0),(/0+31,0+31/), (/-90,90/),lnres)
pl12 = gsn_add_polyline(wks,plot(1),(/0+31,0+31/), (/-90,90/),lnres)
pl13 = gsn_add_polyline(wks,plot(2),(/0+31,0+31/), (/-90,90/),lnres)
pl14 = gsn_add_polyline(wks,plot(3),(/0+31,0+31/), (/-90,90/),lnres)
pl15 = gsn_add_polyline(wks,plot(0),(/360+30,360+30/), (/-90,90/),lnres)
pl16 = gsn_add_polyline(wks,plot(1),(/360+30,360+30/), (/-90,90/),lnres)
pl17 = gsn_add_polyline(wks,plot(2),(/360+30,360+30/), (/-90,90/),lnres)
pl18 = gsn_add_polyline(wks,plot(3),(/360+30,360+30/), (/-90,90/),lnres)









y1=IO_lat1
y2=IO_lat2
x1=IO_lon1
x2=IO_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres   =    True
lnres@gsLineThicknessF=1.5
lnres@gsLineDashPattern=0
lnres@gsLineColor="green4"
  dum1 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  dum2 = gsn_add_polyline(wks,plot(1),x,y,lnres)
  ; dum3 = gsn_add_polyline(wks,plot(2),x,y,lnres)
  ; dum4 = gsn_add_polyline(wks,plot(3),x,y,lnres)
  ; dum5 = gsn_add_polyline(wks,plot(4),x,y,lnres)

y1=EP_lat1
y2=EP_lat2
x1=EP_lon1
x2=EP_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
; lnres@gsLineColor="blue4"
  dum11 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  ; dum12 = gsn_add_polyline(wks,plot(1),x,y,lnres)
  dum13 = gsn_add_polyline(wks,plot(2),x,y,lnres)
  ; dum14 = gsn_add_polyline(wks,plot(3),x,y,lnres)
  ; dum15 = gsn_add_polyline(wks,plot(4),x,y,lnres)


y1=TNA_lat1
y2=TNA_lat2
x1=TNA_lon1
x2=TNA_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
; lnres@gsLineColor="green4"
  dum21 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  dum22 = gsn_add_polyline(wks,plot(1),x,y,lnres)
  ; dum23 = gsn_add_polyline(wks,plot(2),x,y,lnres)
  ; dum24 = gsn_add_polyline(wks,plot(3),x,y,lnres)

y1=TSA_lat1
y2=TSA_lat2
x1=TSA_lon1
x2=TSA_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
; lnres@gsLineColor="green4"
  dum31 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  dum32 = gsn_add_polyline(wks,plot(1),x,y,lnres)
  ; dum33 = gsn_add_polyline(wks,plot(2),x,y,lnres)
  ; dum34 = gsn_add_polyline(wks,plot(3),x,y,lnres)



  pres = True
  pres@gsnFrame = False
  pres@gsnPanelLabelBar = True
  pres@lbOrientation        = "Vertical"
  pres@pmLabelBarWidthF     = 0.035
  pres@pmLabelBarHeightF    = 0.14
  pres@pmLabelBarOrthogonalPosF = 0.012
  pres@lbLabelFontHeightF  = 0.009

  pres@gsnPanelTop  = 0.75
  pres@gsnPanelBottom = 0.5
  pres@gsnPanelLeft  = 0.01
  pres@gsnPanelRight = 0.29
  pres@gsnPanelLabelBar = False
  gsn_panel(wks,plot(0),(/1,1/),pres)
  pres@gsnPanelLeft  = 0.31
  pres@gsnPanelRight = 0.59
  gsn_panel(wks,plot(1),(/1,1/),pres)
  pres@gsnPanelLeft  = 0.61
  pres@gsnPanelRight = 0.965
  pres@gsnPanelLabelBar = True
  gsn_panel(wks,plot(2),(/1,1/),pres)
  ; pres@gsnPanelLeft  = 0.72
  ; pres@gsnPanelRight = 1.0
  ; pres@gsnPanelLabelBar = True
  ; gsn_panel(wks,plot(3),(/1,1/),pres)

  pres@gsnPanelTop  = 0.51
  pres@gsnPanelBottom = 0.31
  pres@gsnPanelLeft  = 0.008
  pres@gsnPanelRight = 0.25
  pres@gsnPanelLabelBar = False
  gsn_panel(wks,plot(4),(/1,1/),pres)
  pres@gsnPanelLeft  = 0.260
  pres@gsnPanelRight = 0.485
  gsn_panel(wks,plot(5),(/1,1/),pres)
  pres@gsnPanelLeft  = 0.495
  pres@gsnPanelRight = 0.720
  gsn_panel(wks,plot(6),(/1,1/),pres)
  pres@gsnPanelLeft  = 0.730
  pres@gsnPanelRight = 0.955
  gsn_panel(wks,plot(7),(/1,1/),pres)




txres               = True
txres@txPerimOn = False
txres@txFont = "helvetica"
txres@txFontColor = "black"
txres@txFontHeightF = 0.011
gsn_text_ndc(wks, "Temperature  tendency",  0.15, 0.711, txres)
gsn_text_ndc(wks, "Air-sea  heat  flux",  0.448, 0.711, txres)
gsn_text_ndc(wks, "Ocean  dynamics",  0.755, 0.711, txres)

gsn_text_ndc(wks, "Tropical  central-eastern  Pacific",  0.138, 0.49, txres)
gsn_text_ndc(wks, "Tropical  Indian  Ocean",  0.373, 0.49, txres)
gsn_text_ndc(wks, "Tropical  North  Atlantic",  0.611, 0.49, txres)
gsn_text_ndc(wks, "Tropical  South  Atlantic",  0.844, 0.49, txres)

txres@txFontColor = "black"
txres@txFontHeightF = 0.012
gsn_text_ndc(wks, "Mixed-layer   heat   budget    (Warming   periods)",  0.474, 0.75, txres)



txres@txFontColor = "black"
txres@txFontHeightF = 0.0090
gsn_text_ndc(wks, "Qnet",  0.55, 0.542, txres)
gsn_text_ndc(wks, "Hadv + Vert",  0.87, 0.542, txres)




; start1 = 180
; end1 = 191
; txres@txFontHeightF = 0.0088
; txres@txFont = "helvetica-bold"
; txres@txFontColor = "#1B78B2"
; gsn_text_ndc(wks, "32.5%",  0.255, 0.610, txres)
; txres@txFontColor = "#B83945"
; gsn_text_ndc(wks, "67.5%",  0.585, 0.610, txres)





txres@txFont = "helvetica-bold"
txres@txFontColor = "black"
txres@txFontHeightF = 0.016
gsn_text_ndc(wks, "d",  0.02, 0.765, txres)
gsn_text_ndc(wks, "e",  0.02, 0.510, txres)
; gsn_text_ndc(wks, "f",  0.03, 0.51, txres)
; gsn_text_ndc(wks, "g",  0.52, 0.51, txres)


frame(wks)
   delete(wks)  
  ;  system("convert -geometry 2200x2200 -density 1600x1600 -trim " + pltName + "."+pltType + " " + pltName + ".png")     
   system("convert -geometry 1600x1600 -density 1200x1200 -trim " + pltName + "."+pltType + " " + pltName + ".png")     
  system("rm " + pltName + "." + pltType + " -f")


end



