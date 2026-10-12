load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin

;;------------------  read lat, lon  -------------------;;
f1 = addfile("topography/topo_2x2.nc", "r")
topo = (f1->topo({-90:90},:))
lat = topo&lat
lon = topo&lon
dim_0 = dimsizes(topo)




;;------------------------------------------  marine heatwaves (0 or 1)  ----------------------------------------------;;
f1 = addfile("1_threshold/OISST_marine_heatwave_1982_2025.nc","r")
heatwave_day = doubletofloat(f1->heatwave_day(:,:,{-90:90},:))



heatwave_frequency = new((/23,dim_0(0), dim_0(1)/), float)
do iyear = 0,22,22
print("iyear = "+(1982+iyear+21))
heatwave_frequency(iyear,:,:) = dim_sum_n_Wrap(dim_sum_n_Wrap(heatwave_day(iyear:iyear+21,:,:,:), 1), 0)

printMinMax(heatwave_frequency(iyear,:,:), 1)
end do
printVarSummary(heatwave_frequency)
printMinMax(heatwave_frequency, 1)


heatwave_frequency0 = heatwave_frequency(0,:,:)
heatwave_frequency0 = where(heatwave_frequency0.eq.0.0, 1.e20, heatwave_frequency0)
heatwave_frequency0@_FillValue = 1.0e20
heatwave_frequency_ratio = heatwave_frequency(22,:,:) / heatwave_frequency0
heatwave_frequency_ratio = where(heatwave_frequency0.eq.0.0, 10000.0, heatwave_frequency_ratio)
heatwave_frequency_ratio = where(topo.ge.-10.0, 1.0e20, heatwave_frequency_ratio)
heatwave_frequency_ratio@_FillValue = 1.0e20
copy_VarCoords(topo, heatwave_frequency_ratio)
printMinMax(heatwave_frequency_ratio, 1)









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
res@tmXBOn        = False
res@tmYLOn        = False
; res@tmXBLabelFontHeightF = 0.038
; res@tmYLLabelFontHeightF = 0.038
res@tmXBTickSpacingF = 45.0
res@tmYLTickSpacingF = 20.0





res@mpMinLatF = -60
res@mpMaxLatF = 60
res@mpMinLonF = 0
res@mpMaxLonF = 360
res@tmXBMode = "Explicit"
res@tmXBValues = (/-135,-90,-45,0,45,90,135,180,225,270,315,360/)
res@tmXBLabels = (/"135W","90W","45W","0","45E","90E","135E","180","135W","90W","45W","0"/)
res@tmYLMode = "Explicit"
res@tmYLValues = (/-90,-60,-30,0,30,60,90/)
res@tmYLLabels = (/"90S","60S","30S","0","30N","60N","90N"/)
res@tmXBMinorOn = True
res@tmXBMinorValues = fspan(-360, 360+15, 49+1)
res@tmYLMinorOn = True
res@tmYLMinorValues = fspan(-90, 90, 19)
res@tmXBLabelsOn = True
res@tmXBLabelFontHeightF = 0.017
res@tmYLLabelsOn = True
res@tmYLLabelFontHeightF = 0.017

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
res@mpGeophysicalLineThicknessF = 0.9
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
sres@cnLevels         = (/0.5/)
; sres@cnFillColors     = (/"red","gray20"/)
sres@cnMissingValFillColor= -1
sres@cnLineThicknessF = 1.5
sres@cnLineDashPattern = 0

sres2 = sres
sres2@cnLevels = (/2700/)
sres2@cnLineColor = "red"
sres2@cnLineDashPattern = 2



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
ores@cnFillColor = "gray30"

ores@cnLevels        = (/0.05/)   ;;90%
; ores@cnLevels        = (/-0.312,0.312/)   ;;95%
ores@cnMonoFillPattern    = False            ; want multiple patterns                                                               
ores@cnFillPatterns       = (/5,-1/)     ; the patterns                                                                         
ores@cnMonoFillScale      = False            ; want different densities                                                             
ores@cnFillScales         = (/0.8,0.8/)    ; change densities   




;**********************plot**************************
plot = new(24, "graphic")
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
pltName = "FigureS1_frequency_change"
wks = gsn_open_wks(pltType, pltName)





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
res@cnFillColors  := (/-1,30,60,90,120,160/)
res@cnLevels      := (/2.0,4,7.0,10.0,20.0/)
plot(0) = gsn_csm_contour_map(wks, heatwave_frequency_ratio, res)





lnres   =    True
lnres@gsLineThicknessF=2.0
lnres@gsLineDashPattern=0
pl1 = gsn_add_polyline(wks,plot(0),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
; pl2 = gsn_add_polyline(wks,plot(1),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
; pl3 = gsn_add_polyline(wks,plot(2),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
; pl4 = gsn_add_polyline(wks,plot(3),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
; pl5 = gsn_add_polyline(wks,plot(4),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
; pl6 = gsn_add_polyline(wks,plot(5),(/30,180+30,0,360+30/), (/-90,-90,-90,-90/),lnres)
pm1 = gsn_add_polyline(wks,plot(0),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
; pm2 = gsn_add_polyline(wks,plot(1),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
; pm3 = gsn_add_polyline(wks,plot(2),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
; pm4 = gsn_add_polyline(wks,plot(3),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
; pm5 = gsn_add_polyline(wks,plot(4),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
; pm6 = gsn_add_polyline(wks,plot(5),(/30,180+30,0,360+30/), (/90,90,90,90/),lnres)
lnres@gsLineThicknessF=1.0
pl11 = gsn_add_polyline(wks,plot(0),(/0+31,0+31/), (/-90,90/),lnres)
; pl12 = gsn_add_polyline(wks,plot(1),(/0+31,0+31/), (/-90,90/),lnres)
; pl13 = gsn_add_polyline(wks,plot(2),(/0+31,0+31/), (/-90,90/),lnres)
; pl14 = gsn_add_polyline(wks,plot(3),(/0+31,0+31/), (/-90,90/),lnres)
; pl15 = gsn_add_polyline(wks,plot(4),(/0+31,0+31/), (/-90,90/),lnres)
; pl16 = gsn_add_polyline(wks,plot(5),(/0+31,0+31/), (/-90,90/),lnres)
pm11 = gsn_add_polyline(wks,plot(0),(/360+30,360+30/), (/-90,90/),lnres)
; pm12 = gsn_add_polyline(wks,plot(1),(/360+30,360+30/), (/-90,90/),lnres)
; pm13 = gsn_add_polyline(wks,plot(2),(/360+30,360+30/), (/-90,90/),lnres)
; pm14 = gsn_add_polyline(wks,plot(3),(/360+30,360+30/), (/-90,90/),lnres)
; pm15 = gsn_add_polyline(wks,plot(4),(/360+30,360+30/), (/-90,90/),lnres)
; pm16 = gsn_add_polyline(wks,plot(5),(/360+30,360+30/), (/-90,90/),lnres)





txres               = True
txres@txPerimOn = False
txres@txFontHeightF = 0.020
; txres@txFont = "helvetica"
txres@txFontColor = "black"

IO_lat1=-20
IO_lat2=20
IO_lon1=50+5
IO_lon2=95+5

WP_lat1=-20
WP_lat2=20
WP_lon1=140
WP_lon2=190

TA_lat1=-15
TA_lat2=30
TA_lon1=290
TA_lon2=350

y1=IO_lat1
y2=IO_lat2
x1=IO_lon1
x2=IO_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres   =    True
lnres@gsLineThicknessF=2.5
lnres@gsLineDashPattern=0
lnres@gsLineColor="gray40"
  dum1 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  ; dum2 = gsn_add_polyline(wks,plot(1),x,y,lnres)
y1=WP_lat1
y2=WP_lat2
x1=WP_lon1
x2=WP_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="blue4"
  dum3 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  ; dum4 = gsn_add_polyline(wks,plot(1),x,y,lnres)
y1=TA_lat1
y2=TA_lat2
x1=TA_lon1
x2=TA_lon2
x=(/x1,x2,x2,x1,x1/)
y=(/y2,y2,y1,y1,y2/)
lnres@gsLineColor="green4"
  dum5 = gsn_add_polyline(wks,plot(0),x,y,lnres)
  ; dum6 = gsn_add_polyline(wks,plot(1),x,y,lnres)










  pres = True
  pres@gsnFrame = False
  pres@gsnPanelLabelBar = True
  pres@lbOrientation        = "Vertical"
  pres@pmLabelBarWidthF     = 0.045
  pres@pmLabelBarHeightF    = 0.30
;   pres@pmLabelBarOrthogonalPosF = -0.005
  ; pres@pmLabelBarParallelPosF = 0.01
  pres@lbLabelFontHeightF  = 0.0120


  pres@gsnPanelTop  = 0.99
  pres@gsnPanelBottom = 0.01
  pres@gsnPanelLeft  = 0.01
  pres@gsnPanelRight = 0.99
  pres@pmLabelBarOrthogonalPosF = 0.005
  gsn_panel(wks,plot(0),(/1,1/),pres)




txres               = True
txres@txPerimOn = False
txres@txFontHeightF = 0.0125
; txres@txFont = "helvetica"
txres@txFontColor = "black"



txres@txFontHeightF = 0.0155
txres@txFont = "helvetica-bold"
; gsn_text_ndc(wks, "a",  0.06, 0.797, txres)
; gsn_text_ndc(wks, "b",  0.522, 0.797, txres)
; gsn_text_ndc(wks, "c",  0.06, 0.62, txres)
; gsn_text_ndc(wks, "d",  0.522, 0.62, txres)
; gsn_text_ndc(wks, "e",  0.06, 0.37, txres)
; gsn_text_ndc(wks, "f",  0.522, 0.37, txres)

; txres@txFontHeightF = 0.0130
; txres@txFont = "helvetica"
; gsn_text_ndc(wks, "lag = 0 day",  0.265, 0.755, txres)
; gsn_text_ndc(wks, "lag = 2 day",  0.765, 0.755, txres)
; gsn_text_ndc(wks, "lag = 4 day",  0.265, 0.475, txres)
; gsn_text_ndc(wks, "(lag = 4 day)  minus  (lag = 0 day)",  0.765, 0.475, txres)

txres@txFontHeightF = 0.017
txres@txFont = "helvetica"
gsn_text_ndc(wks, "Change   in   marine   heatwave   frequency",  0.415, 0.74, txres)
; gsn_text_ndc(wks, "High    z500    events    concurrent    with    TP    wet    events",  0.48, 0.40, txres)



frame(wks)
   delete(wks)  
   system("convert -geometry 2400x2400 -density 1800x1800 -trim " + pltName + "."+pltType + " " + pltName + ".png")     
  system("rm " + pltName + "." + pltType + " -f")



end


