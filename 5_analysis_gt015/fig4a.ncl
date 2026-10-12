load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin


f0 = addfile("topography/topo_2x2.nc","r")
topo0 = f0->topo
dim_0 = dimsizes(topo0)
lat = topo0&lat
lon = topo0&lon





f1 = addfile("5_analysis_gt015/fig4_CMIP6degree_gt015/SSP370_2004_2025_EPDegree_gt015.nc","r")
Hdegree_strength = (f1->degree_strength) / 1.0e1
Hdegree_strength!2="lat"
Hdegree_strength!3="lon"
Hdegree_strength&lat = lat
Hdegree_strength&lon = lon
printVarSummary(Hdegree_strength)
printMinMax(Hdegree_strength, 1)
Hdegree_strength_MME = dim_avg_n_Wrap(Hdegree_strength, 0)




f1 = addfile("5_analysis_gt015/fig4_CMIP6degree_gt015/SSP370_2078_2099_EPDegree_gt015.nc","r")
Fdegree_strength = (f1->degree_strength) / 1.0e1
Fdegree_strength!2="lat"
Fdegree_strength!3="lon"
Fdegree_strength&lat = lat
Fdegree_strength&lon = lon
printVarSummary(Fdegree_strength)
printMinMax(Fdegree_strength, 1)
Fdegree_strength_MME = dim_avg_n_Wrap(Fdegree_strength, 0)




Ddegree_strength_MME = Fdegree_strength_MME - Hdegree_strength_MME
copy_VarCoords(Hdegree_strength_MME, Ddegree_strength_MME)
Ddegree_strength = Fdegree_strength - Hdegree_strength
Ddegree_strengthP = where(Ddegree_strength.gt.0.0, 1.0, 0.0)
Ddegree_strengthPP = dim_sum_n_Wrap(Ddegree_strengthP, 0)/19.0
Ddegree_strengthN = where(Ddegree_strength.lt.0.0, 1.0, 0.0)
Ddegree_strengthNN = dim_sum_n_Wrap(Ddegree_strengthN, 0)/19.0
copy_VarCoords(Hdegree_strength_MME, Ddegree_strengthPP)
copy_VarCoords(Hdegree_strength_MME, Ddegree_strengthNN)





NEP_lat1=20
NEP_lat2=50
NEP_lon1=185
NEP_lon2=235

TNA_lat1=5
TNA_lat2=30
TNA_lon1=290
TNA_lon2=350

TSA_lat1=-25
TSA_lat2=0
TSA_lon1=320
TSA_lon2=370

EP_lat1=-10
EP_lat2=10
EP_lon1=215
EP_lon2=280

IO_lat1=-20
IO_lat2=20
IO_lon1=50+5
IO_lon2=95+5

SWP_lat1=-60
SWP_lat2=-35
SWP_lon1=155
SWP_lon2=200

WNP1_lat1=15
WNP1_lat2=35
WNP1_lon1=120
WNP1_lon2=145

WNP2_lat1=-5
WNP2_lat2=15
WNP2_lon1=140
WNP2_lon2=170


H_NEP = dim_sum_n_Wrap(dim_sum_n_Wrap(Hdegree_strength(:,:,{NEP_lat1:NEP_lat2},{NEP_lon1:NEP_lon2}), 3), 2)
H_SWP = dim_sum_n_Wrap(dim_sum_n_Wrap(Hdegree_strength(:,:,{SWP_lat1:SWP_lat2},{SWP_lon1:SWP_lon2}), 3), 2)
H_IO = dim_sum_n_Wrap(dim_sum_n_Wrap(Hdegree_strength(:,:,{IO_lat1:IO_lat2},{IO_lon1:IO_lon2}), 3), 2)
H_TNA = dim_sum_n_Wrap(dim_sum_n_Wrap(Hdegree_strength(:,:,{TNA_lat1:TNA_lat2},{TNA_lon1:TNA_lon2}), 3), 2)
H_TSA = dim_sum_n_Wrap(dim_sum_n_Wrap(Hdegree_strength(:,:,{TSA_lat1:TSA_lat2},{TSA_lon1:TSA_lon2}), 3), 2)
H_WNP1 = dim_sum_n_Wrap(dim_sum_n_Wrap(Hdegree_strength(:,:,{WNP1_lat1:WNP1_lat2},{WNP1_lon1:WNP1_lon2}), 3), 2)
H_WNP2 = dim_sum_n_Wrap(dim_sum_n_Wrap(Hdegree_strength(:,:,{WNP2_lat1:WNP2_lat2},{WNP2_lon1:WNP2_lon2}), 3), 2)
H_WNP = H_WNP1 + H_WNP2

F_NEP = dim_sum_n_Wrap(dim_sum_n_Wrap(Fdegree_strength(:,:,{NEP_lat1:NEP_lat2},{NEP_lon1:NEP_lon2}), 3), 2)
F_SWP = dim_sum_n_Wrap(dim_sum_n_Wrap(Fdegree_strength(:,:,{SWP_lat1:SWP_lat2},{SWP_lon1:SWP_lon2}), 3), 2)
F_IO = dim_sum_n_Wrap(dim_sum_n_Wrap(Fdegree_strength(:,:,{IO_lat1:IO_lat2},{IO_lon1:IO_lon2}), 3), 2)
F_TNA = dim_sum_n_Wrap(dim_sum_n_Wrap(Fdegree_strength(:,:,{TNA_lat1:TNA_lat2},{TNA_lon1:TNA_lon2}), 3), 2)
F_TSA = dim_sum_n_Wrap(dim_sum_n_Wrap(Fdegree_strength(:,:,{TSA_lat1:TSA_lat2},{TSA_lon1:TSA_lon2}), 3), 2)
F_WNP1 = dim_sum_n_Wrap(dim_sum_n_Wrap(Fdegree_strength(:,:,{WNP1_lat1:WNP1_lat2},{WNP1_lon1:WNP1_lon2}), 3), 2)
F_WNP2 = dim_sum_n_Wrap(dim_sum_n_Wrap(Fdegree_strength(:,:,{WNP2_lat1:WNP2_lat2},{WNP2_lon1:WNP2_lon2}), 3), 2)
F_WNP = F_WNP1 + F_WNP2





;;---------------------- to nc file -----------------------;;
output="5_analysis_gt015/fig4_CMIP6degree_gt015/"
name1="El_Nino_Flow_Historical_SSP370_gt015"
system("/bin/rm -f "+output+name1+".nc")
ncdf1=addfile(output+name1+".nc","c")

ncdf1->H_NEP=H_NEP
ncdf1->H_SWP=H_SWP
ncdf1->H_IO=H_IO
ncdf1->H_TNA=H_TNA
ncdf1->H_TSA=H_TSA
ncdf1->H_WNP=H_WNP

ncdf1->F_NEP=F_NEP
ncdf1->F_SWP=F_SWP
ncdf1->F_IO=F_IO
ncdf1->F_TNA=F_TNA
ncdf1->F_TSA=F_TSA
ncdf1->F_WNP=F_WNP








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
; res@tmXBValues = (/-135,-90,-45,0,45,90,135,180,225,270,315,360/)
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
res@lbOrientation        = "Horizontal"
res@pmLabelBarWidthF     = 0.50
res@pmLabelBarHeightF    = 0.07
; res@pmLabelBarOrthogonalPosF = 0.012
res@lbLabelFontHeightF  = 0.015
;res@cnMissingValFillColor = "white"
;res@gsnYRefLine = 0.0
;res@gsnYRefLineColor = "black"
;res@gsnYRefLineThicknessF = 5.0
res@cnMissingValFillColor = -1
res@cnLevelSelectionMode = "ExplicitLevels"              
; res@cnLevels             = (/140.0,155.0,170.0,185.0,200.0,215.0,230.0,245.0/)
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
; sres@cnLevels         = (/2700.0/)
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




cnres@tmBorderThicknessF = 2.2
cnres@gsnDraw        = False
cnres@gsnFrame       = False
cnres@lgPerimOn = False
cnres@lgLabelFontHeightF = 0.018
cnres@vpWidthF  = 0.42
cnres@vpHeightF = 0.42
cnres@vpXF      = 0.06
cnres@vpYF      = 0.5

cnres@trXMinF = -0.5
cnres@trXMaxF = 18.5
cnres@trYMinF = 0.0
cnres@trYMaxF = 90.0


cnres@tmXTOn        = False
cnres@tmYROn        = False
cnres@tmXBOn        = True
cnres@tmYLOn        = True
cnres@tmXBLabelFontHeightF = 0.014
cnres@tmYLLabelFontHeightF = 0.014
cnres@tmYRLabelFontHeightF = 0.014
cnres@gsnLeftStringFontHeightF   = 0.022
cnres@gsnRightStringFontHeightF  = 0.022
cnres@gsnCenterStringFontHeightF  = 0.022
cnres@tmYRLabelsOn   = False
; cnres@tmYROn         = True

cnres@tmYLMode := "Explicit"
cnres@tmYLValues := fspan(0.0, 80.0, 5)
cnres@tmYLLabels := (/"0","20N","40N","60N","80N"/)
cnres@tmYLMinorOn := True
cnres@tmYLMinorValues := fspan(0.0, 80.0, 9)

cnres@tmXBMode := "Explicit"
cnres@tmXBValues := fspan(0, 18.0, 19)
cnres@tmXBLabels := (/"M","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18"/)
cnres@tmXBMinorOn := False

cnres@cnFillOn       = True
cnres@cnLinesOn      = False
cnres@cnLineLabelsOn = False
cnres@lbLabelBarOn   = False
cnres@cnInfoLabelOn  = False
cnres@cnLevelSelectionMode = "ExplicitLevels"

cnres@tmYLMajorThicknessF = 2.5
cnres@tmXBMajorThicknessF = 2.5
cnres@tmYLMinorThicknessF = 1.5
cnres@tmXBMinorThicknessF = 1.5
cnres@tmYLMajorLengthF = 0.012
cnres@tmXBMajorLengthF = 0.012
cnres@tmYLMinorLengthF = 0.009
cnres@tmXBMinorLengthF = 0.009
cnres@tmXBLabelDeltaF = -0.4
cnres@tmYLLabelDeltaF = -0.4
cnres@tmXBMajorOutwardLengthF = 0.012
cnres@tmYLMajorOutwardLengthF = 0.012
cnres@tmXBMinorOutwardLengthF = 0.009
cnres@tmYLMinorOutwardLengthF = 0.009







lires = True
lires@tmBorderThicknessF = 1.1
lires@gsnDraw        = False
lires@gsnFrame       = False
lires@tiXAxisOn      = False
lires@tiYAxisOn      = False
lires@tmXTLabelsOn   = False
lires@tmXTOn         = False

lires@trYMinF        = 0.0
lires@trYMaxF        = 0.5
lires@trXMinF        = 0.5
lires@trXMaxF        = 12.5

lires@tmXBLabelFontHeightF = 0.072
lires@tmYLLabelFontHeightF = 0.072
lires@tmYRLabelFontHeightF = 0.072
lires@gsnLeftStringFontHeightF   = 0.025
lires@gsnRightStringFontHeightF  = 0.025
lires@tmYRLabelsOn   = False
lires@tmYROn         = False

lires@tmYLOn         = True
lires@tmYLLabelsOn   = True
lires@tmYLMode = "Explicit"
lires@tmXBMode = "Explicit"
; lires@tmYLValues = fspan(0, 80, 5)
; lires@tmYLLabels = (/"0","20N","40N","60N","80N"/)
; lires@tmYLMinorOn = True
; lires@tmYLMinorValues = fspan(0, 90, 10)

; lires@tmYLValues = fspan(0, 80, 5)
; lires@tmYLLabels = (/"0","20N","40N","60N","80N"/)
; lires@tmYLMinorOn = True
; lires@tmYLMinorValues = fspan(0, 90, 10)
;lires@tmYLMode = "Explicit"
;lires@tmYLValues = fspan(1, 71, 8)
;lires@tmYLLabels = (/"1-April","11-April","21-April","1-May","11-May","21-May","31-May","10-June"/)

lires@xyMarkLineModes = (/"Lines","Lines","Lines"/)
;lires@xyMarkers = (/4,1,1/)
;lires@xyMarkerSizes = (/0.015,0.001,0.001/)
;lires@xyMarkerColors= (/"black","black","black"/)
;lires@xyMarkerThicknesses = (/4.0,2.0,1.0/)

lires@lgPerimOn = False
lires@lgLabelFontHeightF = 0.018
lires@vpWidthF  = 0.99
lires@vpHeightF = 0.75
lires@vpXF      = 0.06
lires@vpYF      = 0.75

lires@gsnLeftString  = ""
lires@gsnRightString = ""
lires@xyMarkLineModes = (/"Lines","Lines","Lines"/)
; lires@xyMarkers = (/1,1,1/)
; lires@xyMarkerSizes = (/0.015,0.001,0.001/)
; lires@xyMarkerColors= (/"black","black","black"/)
; lires@xyMarkerThicknesses = (/4.0,2.0,1.0/)
lires@xyLineThicknesses  = (/3.5,8.0,8.0/)
lires@xyLineColors       = (/"red","blue","orange"/)
lires@xyDashPatterns     = (/0,4,2/)

lires@tmYLMajorThicknessF = 1.5
lires@tmYRMajorThicknessF = 1.5
lires@tmXBMajorThicknessF = 1.5
lires@tmYLMinorThicknessF = 1.0
lires@tmYRMinorThicknessF = 1.0
lires@tmXBMinorThicknessF = 1.0
lires@tmYLMajorLengthF = 0.06
lires@tmYRMajorLengthF = 0.06
lires@tmXBMajorLengthF = 0.06
lires@tmYLMinorLengthF = 0.04
lires@tmYRMinorLengthF = 0.04
lires@tmXBMinorLengthF = 0.04
lires@tmXBLabelDeltaF = -0.25
lires@tmYLLabelDeltaF = -0.25
lires@tmXBMajorOutwardLengthF = 0.06
lires@tmYLMajorOutwardLengthF = 0.06
lires@tmYRMajorOutwardLengthF = 0.06
lires@tmXBMinorOutwardLengthF = 0.04
lires@tmYLMinorOutwardLengthF = 0.04
lires@tmYRMinorOutwardLengthF = 0.04






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

ores@cnLevels        = (/0.70/)
; ores@cnLevels        = (/-0.312,0.312/)   ;;95%
ores@cnMonoFillPattern    = False            ; want multiple patterns                                                               
ores@cnFillPatterns       = (/-1,3/)     ; the patterns                                                                         
ores@cnMonoFillScale      = False            ; want different densities                                                             
ores@cnFillScales         = (/0.3,0.3/)    ; change densities   

ores2 = ores
ores2@cnLevels        = (/-1.0/)                                                            
ores2@cnFillPatterns       = (/3,-1/)



;**********************plot**************************
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






;;-------------------------------------------------------------------------------------------
pltType = "eps"
pltName = "5_analysis_gt015/Figure4a_gt015"
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



res@cnFillPalette = "WhiteYellowOrangeRed"
res@cnLevels      := (/15,30,60,100/)
res@cnLevels      := (/2,4,7,10/)
res@cnFillColors  := (/-1,70,105,135,170/)
res@gsnCenterString = ""
res@gsnCenterStringFontHeightF = 0.040
plot(0) = gsn_csm_contour_map(wks,Hdegree_strength_MME(0,:,:), res)
plot(1) = gsn_csm_contour_map(wks,Hdegree_strength_MME(1,:,:), res)
plot(2) = gsn_csm_contour_map(wks,Hdegree_strength_MME(2,:,:), res)
plot(3) = gsn_csm_contour_map(wks,Hdegree_strength_MME(3,:,:), res)
plot(4) = gsn_csm_contour_map(wks,Hdegree_strength_MME(4,:,:), res)



; plot(5) = gsn_csm_contour_map(wks,Fdegree_strength_MME(1,:,:), res)
; plot(6) = gsn_csm_contour_map(wks,Fdegree_strength_MME(1,:,:), res)
; plot(7) = gsn_csm_contour_map(wks,Fdegree_strength_MME(2,:,:), res)
; plot(8) = gsn_csm_contour_map(wks,Fdegree_strength_MME(2,:,:), res)
; plot(9) = gsn_csm_contour_map(wks,Fdegree_strength_MME(2,:,:), res)


res@cnFillPalette = "cmp_b2r"
; res@cnLevels      := (/-20,-10,-5,5,10,20/)
; res@cnFillColors  := (/12,17,24,-1,38,44,50/)
res@cnLevels      := (/-1.5,-0.5,0.5,1.5/)
res@cnFillColors  := (/16,24,-1,38,46/)
plot(5) = gsn_csm_contour_map(wks,Ddegree_strength_MME(0,:,:), res)
plot(6) = gsn_csm_contour_map(wks,Ddegree_strength_MME(1,:,:), res)
plot(7) = gsn_csm_contour_map(wks,Ddegree_strength_MME(2,:,:), res)
plot(8) = gsn_csm_contour_map(wks,Ddegree_strength_MME(3,:,:), res)
plot(9) = gsn_csm_contour_map(wks,Ddegree_strength_MME(4,:,:), res)


contour1(5) = gsn_csm_contour(wks,Ddegree_strengthPP(0,:,:), ores)
contour1(6) = gsn_csm_contour(wks,Ddegree_strengthPP(1,:,:), ores)
contour1(7) = gsn_csm_contour(wks,Ddegree_strengthPP(2,:,:), ores)
contour1(8) = gsn_csm_contour(wks,Ddegree_strengthPP(3,:,:), ores)
contour1(9) = gsn_csm_contour(wks,Ddegree_strengthPP(4,:,:), ores)
contour2(5) = gsn_csm_contour(wks,Ddegree_strengthNN(0,:,:), ores)
contour2(6) = gsn_csm_contour(wks,Ddegree_strengthNN(1,:,:), ores)
contour2(7) = gsn_csm_contour(wks,Ddegree_strengthNN(2,:,:), ores)
contour2(8) = gsn_csm_contour(wks,Ddegree_strengthNN(3,:,:), ores)
contour2(9) = gsn_csm_contour(wks,Ddegree_strengthNN(4,:,:), ores)
do i=5,9
overlay(plot(i), contour1(i))
overlay(plot(i), contour2(i))
end do



lnres   =    True
lnres@gsLineThicknessF=1.0
lnres@gsLineDashPattern=0
pl1 = gsn_add_polyline(wks,plot(0),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl2 = gsn_add_polyline(wks,plot(1),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl3 = gsn_add_polyline(wks,plot(2),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl4 = gsn_add_polyline(wks,plot(3),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl5 = gsn_add_polyline(wks,plot(4),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl6 = gsn_add_polyline(wks,plot(5),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl7 = gsn_add_polyline(wks,plot(6),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl8 = gsn_add_polyline(wks,plot(7),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl9 = gsn_add_polyline(wks,plot(8),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pl10 = gsn_add_polyline(wks,plot(9),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pm1 = gsn_add_polyline(wks,plot(0),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm2 = gsn_add_polyline(wks,plot(1),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm3 = gsn_add_polyline(wks,plot(2),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm4 = gsn_add_polyline(wks,plot(3),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm5 = gsn_add_polyline(wks,plot(4),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm6 = gsn_add_polyline(wks,plot(5),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm7 = gsn_add_polyline(wks,plot(6),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm8 = gsn_add_polyline(wks,plot(7),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm9 = gsn_add_polyline(wks,plot(8),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
pm10 = gsn_add_polyline(wks,plot(9),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
lnres@gsLineThicknessF=0.5
pl11 = gsn_add_polyline(wks,plot(0),(/0+31,0+31/), (/-90,90/),lnres)
pl12 = gsn_add_polyline(wks,plot(1),(/0+31,0+31/), (/-90,90/),lnres)
pl13 = gsn_add_polyline(wks,plot(2),(/0+31,0+31/), (/-90,90/),lnres)
pl14 = gsn_add_polyline(wks,plot(3),(/0+31,0+31/), (/-90,90/),lnres)
pl15 = gsn_add_polyline(wks,plot(4),(/0+31,0+31/), (/-90,90/),lnres)
pl16 = gsn_add_polyline(wks,plot(5),(/0+31,0+31/), (/-90,90/),lnres)
pl17 = gsn_add_polyline(wks,plot(6),(/0+31,0+31/), (/-90,90/),lnres)
pl18 = gsn_add_polyline(wks,plot(7),(/0+31,0+31/), (/-90,90/),lnres)
pl19 = gsn_add_polyline(wks,plot(8),(/0+31,0+31/), (/-90,90/),lnres)
pl20 = gsn_add_polyline(wks,plot(9),(/0+31,0+31/), (/-90,90/),lnres)
pm11 = gsn_add_polyline(wks,plot(0),(/360+30,360+30/), (/-90,90/),lnres)
pm12 = gsn_add_polyline(wks,plot(1),(/360+30,360+30/), (/-90,90/),lnres)
pm13 = gsn_add_polyline(wks,plot(2),(/360+30,360+30/), (/-90,90/),lnres)
pm14 = gsn_add_polyline(wks,plot(3),(/360+30,360+30/), (/-90,90/),lnres)
pm15 = gsn_add_polyline(wks,plot(4),(/360+30,360+30/), (/-90,90/),lnres)
pm16 = gsn_add_polyline(wks,plot(5),(/360+30,360+30/), (/-90,90/),lnres)
pm17 = gsn_add_polyline(wks,plot(6),(/360+30,360+30/), (/-90,90/),lnres)
pm18 = gsn_add_polyline(wks,plot(7),(/360+30,360+30/), (/-90,90/),lnres)
pm19 = gsn_add_polyline(wks,plot(8),(/360+30,360+30/), (/-90,90/),lnres)
pm20 = gsn_add_polyline(wks,plot(9),(/360+30,360+30/), (/-90,90/),lnres)





; TNA_lat1=5
; TNA_lat2=30
; TNA_lon1=290
; TNA_lon2=350
y1=TNA_lat1
y2=TNA_lat2
x1=TNA_lon1
x2=TNA_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres   =    True
lnres@gsLineDashPattern=0
lnres@gsLineColor="green4"
lnres@gsLineThicknessF=0.8
  ; dum3 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  ; dum4 = gsn_add_polyline(wks,plot(1),x,y,lnres)
  dum5 = gsn_add_polyline(wks,plot(2),x,y,lnres)
  dum6 = gsn_add_polyline(wks,plot(3),x,y,lnres)
  dum7 = gsn_add_polyline(wks,plot(4),x,y,lnres)


; TSA_lat1=-25
; TSA_lat2=0
; TSA_lon1=320
; TSA_lon2=370
y1=TSA_lat1
y2=TSA_lat2
x1=TSA_lon1
x2=TSA_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="green4"
lnres@gsLineThicknessF=0.8
  ; duo3 = gsn_add_polyline(wks,plot(0),x,y,lnres) 
  ; duo4 = gsn_add_polyline(wks,plot(1),x,y,lnres) 
  duo5 = gsn_add_polyline(wks,plot(2),x,y,lnres) 
  duo6 = gsn_add_polyline(wks,plot(3),x,y,lnres)  
  duo7 = gsn_add_polyline(wks,plot(7),x,y,lnres) 
  duo8 = gsn_add_polyline(wks,plot(8),x,y,lnres) 


  
; EP_lat1=-10
; EP_lat2=10
; EP_lon1=215
; EP_lon2=280
y1=EP_lat1
y2=EP_lat2
x1=EP_lon1
x2=EP_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="green4"
lnres@gsLineThicknessF=0.8
  ; dun3 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  dun4 = gsn_add_polyline(wks,plot(1),x,y,lnres)
  dun5 = gsn_add_polyline(wks,plot(2),x,y,lnres)
  dun6 = gsn_add_polyline(wks,plot(3),x,y,lnres)
  ; dun7 = gsn_add_polyline(wks,plot(4),x,y,lnres)


; IO_lat1=-20
; IO_lat2=20
; IO_lon1=50+5
; IO_lon2=95+5
y1=IO_lat1
y2=IO_lat2
x1=IO_lon1
x2=IO_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="green4"
lnres@gsLineThicknessF=0.8 
  ; dul3 = gsn_add_polyline(wks,plot(0),x,y,lnres)  
  ; dul4 = gsn_add_polyline(wks,plot(1),x,y,lnres)  
  dul5 = gsn_add_polyline(wks,plot(2),x,y,lnres)  
  dul6 = gsn_add_polyline(wks,plot(3),x,y,lnres)  
  dul7 = gsn_add_polyline(wks,plot(4),x,y,lnres)  



; SWP_lat1=-60
; SWP_lat2=-35
; SWP_lon1=155
; SWP_lon2=200
y1=SWP_lat1
y2=SWP_lat2
x1=SWP_lon1
x2=SWP_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="green4"
lnres@gsLineThicknessF=0.8
  dup3 = gsn_add_polyline(wks,plot(0),x,y,lnres) 
  dup4 = gsn_add_polyline(wks,plot(1),x,y,lnres) 
  dup5 = gsn_add_polyline(wks,plot(5),x,y,lnres) 
  dup6 = gsn_add_polyline(wks,plot(6),x,y,lnres) 
  ; dup7 = gsn_add_polyline(wks,plot(4),x,y,lnres)   


; NEP_lat1=20
; NEP_lat2=50
; NEP_lon1=185
; NEP_lon2=235
y1=NEP_lat1
y2=NEP_lat2
x1=NEP_lon1
x2=NEP_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="green4"
lnres@gsLineThicknessF=0.8
  duq3 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  duq4 = gsn_add_polyline(wks,plot(1),x,y,lnres)
  duq5 = gsn_add_polyline(wks,plot(5),x,y,lnres)
  duq6 = gsn_add_polyline(wks,plot(6),x,y,lnres)
  ; duq7 = gsn_add_polyline(wks,plot(4),x,y,lnres) 

; WNP1_lat1=15
; WNP1_lat2=35
; WNP1_lon1=120
; WNP1_lon2=145
y1=WNP1_lat1
y2=WNP1_lat2
x1=WNP1_lon1
x2=WNP1_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="green4"
lnres@gsLineThicknessF=0.8
  dur3 = gsn_add_polyline(wks,plot(4),x,y,lnres)
  ; dur4 = gsn_add_polyline(wks,plot(5),x,y,lnres)
; WNP2_lat1=-5
; WNP2_lat2=15
; WNP2_lon1=140
; WNP2_lon2=170
y1=WNP2_lat1
y2=WNP2_lat2
x1=WNP2_lon1
x2=WNP2_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="green4"
lnres@gsLineThicknessF=0.8
  dus3 = gsn_add_polyline(wks,plot(4),x,y,lnres)


  

  pres = True
  pres@gsnFrame = False
  pres@gsnPanelLabelBar = True
  pres@lbOrientation        = "Vertical"
  pres@pmLabelBarWidthF     = 0.040
  pres@pmLabelBarHeightF    = 0.135
  pres@pmLabelBarOrthogonalPosF = 0.002
  pres@lbLabelFontHeightF  = 0.0095


  pres@lbOrientation        = "Vertical"
  pres@pmLabelBarWidthF     = 0.04
  pres@pmLabelBarHeightF    = 0.10
  pres@pmLabelBarOrthogonalPosF = 0.002
  pres@pmLabelBarParallelPosF = -0.001
  pres@lbLabelFontHeightF  = 0.0095

  pres@gsnPanelTop  = 0.75
  pres@gsnPanelBottom = 0.45
  pres@gsnPanelLeft  = 0.01
  pres@gsnPanelRight = 0.99
  gsn_panel(wks,plot(0:4),(/1,5/),pres)

  pres@gsnPanelTop  = 0.55
  pres@gsnPanelBottom = 0.25
  pres@gsnPanelLeft  = 0.01
  pres@gsnPanelRight = 0.99
  gsn_panel(wks,plot(5:9),(/1,5/),pres)


txres = True
txres@txFont = "helvetica-bold"
txres@txFontHeightF = 0.016
gsn_text_ndc(wks, "a",  0.02, 0.70, txres)
gsn_text_ndc(wks, "b",  0.02, 0.50, txres)
gsn_text_ndc(wks, "c",  0.02, 0.30, txres)
gsn_text_ndc(wks, "d",  0.775, 0.30, txres)

txres@txFont = "helvetica"
txres@txFontHeightF = 0.0125
gsn_text_ndc(wks, "Historical + SSP3-7.0  (2005-2024)",  0.480, 0.69, txres)
gsn_text_ndc(wks, "2078-2099  (SSP3-7.0)   minus   2005-2024",  0.480, 0.49, txres)
txres@txFontHeightF = 0.0125
gsn_text_ndc(wks, "Projected   changes   in   pathway   strength",  0.355, 0.29, txres)
txres@txFontHeightF = 0.0115
gsn_text_ndc(wks, "NEP->TEP",  0.89, 0.29, txres)



txres@txFont = "helvetica"
txres@txFontHeightF = 0.011
gsn_text_ndc(wks, "-12 months",  0.102, 0.66, txres)
gsn_text_ndc(wks, "-6 months",  0.29, 0.66, txres)
gsn_text_ndc(wks, "0 month",  0.479, 0.66, txres)
gsn_text_ndc(wks, "+6 months",  0.668, 0.66, txres)
gsn_text_ndc(wks, "+12 months",  0.855, 0.66, txres)

gsn_text_ndc(wks, "-12 months",  0.102, 0.46, txres)
gsn_text_ndc(wks, "-6 months",  0.29, 0.46, txres)
gsn_text_ndc(wks, "0 month",  0.479, 0.46, txres)
gsn_text_ndc(wks, "+6 months",  0.668, 0.46, txres)
gsn_text_ndc(wks, "+12 months",  0.855, 0.46, txres)




frame(wks)
   delete(wks)  
   system("convert -geometry 1800x1800 -density 1400x1400 -trim " + pltName + "."+pltType + " " + pltName + ".png")     
  system("rm " + pltName + "." + pltType + " -f")










  

end



