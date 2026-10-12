load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin

  

opt = False
var_name = (/"thetao","uo","vo","hfds"/)
var_name = (/"votemper","vozocrtx","vomecrty","sohefldo"/)
var_name = (/"votemper","vozocrtx","vomecrty","sohefldo"/)
path = "ORAS5_monthly/"
   
mld = new((/44*12,90,180/), float)
votemper_mixed = new((/44*12,90,180/), float)
votemper_bot = new((/44*12,90,180/), float)
vozocrtx_mixed = new((/44*12,90,180/), float)
vozocrtx_bot = new((/44*12,90,180/), float)
vomecrty_mixed = new((/44*12,90,180/), float)
vomecrty_bot = new((/44*12,90,180/), float)
sohefldo_mixed = new((/44*12,90,180/), float)
do iyear = 0,44-1
    year_str = flt2string(iyear+1982)
    print(" iyear = " + year_str)

    ;;======================== read data ==========================;;
    fin = addfile(path + "mld03_2x2/oras5_somxl030_2x2_"+year_str+".nc", "r")
    mld(iyear*12:iyear*12+11,:,:) = fin->somxl030
    mld = where(mld.eq.0.0, mld@_FillValue, mld)
    
    fin = addfile("4_mixed_layer_budget_ORAS5/ave/votemper_mixed_"+year_str+".nc", "r")
    votemper_mixed(iyear*12:iyear*12+11,:,:) = fin->votemper_mixed_avg
    votemper_bot(iyear*12:iyear*12+11,:,:) = fin->votemper_mixed_bot
    fin = addfile("4_mixed_layer_budget_ORAS5/ave/vozocrtx_mixed_"+year_str+".nc", "r")
    vozocrtx_mixed(iyear*12:iyear*12+11,:,:) = fin->vozocrtx_mixed_avg
    vozocrtx_bot(iyear*12:iyear*12+11,:,:) = fin->vozocrtx_mixed_bot
    fin = addfile("4_mixed_layer_budget_ORAS5/ave/vomecrty_mixed_"+year_str+".nc", "r")
    vomecrty_mixed(iyear*12:iyear*12+11,:,:) = fin->vomecrty_mixed_avg
    vomecrty_bot(iyear*12:iyear*12+11,:,:) = fin->vomecrty_mixed_bot
    fin = addfile("4_mixed_layer_budget_ORAS5/ave/sohefldo_mixed_"+year_str+".nc", "r")
    sohefldo_mixed(iyear*12:iyear*12+11,:,:) = fin->sohefldo_mixed_avg
end do

value = 1.0e20
mld@_FillValue = 1.0e20
if (any(isnan_ieee(mld))) then
      replace_ieeenan (mld, value, 0)
      mld@_FillValue = value
end if
votemper_mixed@_FillValue = 1.0e20
if (any(isnan_ieee(votemper_mixed))) then
      replace_ieeenan (votemper_mixed, value, 0)
      votemper_mixed@_FillValue = value
end if
votemper_bot@_FillValue = 1.0e20
if (any(isnan_ieee(votemper_bot))) then
      replace_ieeenan (votemper_bot, value, 0)
      votemper_bot@_FillValue = value
end if
vozocrtx_mixed@_FillValue = 1.0e20
if (any(isnan_ieee(vozocrtx_mixed))) then
      replace_ieeenan (vozocrtx_mixed, value, 0)
      vozocrtx_mixed@_FillValue = value
end if
vozocrtx_bot@_FillValue = 1.0e20
if (any(isnan_ieee(vozocrtx_bot))) then
      replace_ieeenan (vozocrtx_bot, value, 0)
      vozocrtx_bot@_FillValue = value
end if
vomecrty_mixed@_FillValue = 1.0e20
if (any(isnan_ieee(vomecrty_mixed))) then
      replace_ieeenan (vomecrty_mixed, value, 0)
      vomecrty_mixed@_FillValue = value
end if
vomecrty_bot@_FillValue = 1.0e20
if (any(isnan_ieee(vomecrty_bot))) then
      replace_ieeenan (vomecrty_bot, value, 0)
      vomecrty_bot@_FillValue = value
end if
sohefldo_mixed@_FillValue = 1.0e20
if (any(isnan_ieee(sohefldo_mixed))) then
      replace_ieeenan (sohefldo_mixed, value, 0)
      sohefldo_mixed@_FillValue = value
end if
lat=fspan(-89.0, 89.0, 90)     ;;2*2 resolution
lon=fspan(-179.0, 179.0, 180)
lat@units="degrees_north"
lon@units="degrees_east"
mld!1="lat"
mld!2="lon"
mld&lat = lat
mld&lon = lon
copy_VarCoords(mld, votemper_mixed)
copy_VarCoords(mld, votemper_bot)
copy_VarCoords(mld, vozocrtx_mixed)
copy_VarCoords(mld, vozocrtx_bot)
copy_VarCoords(mld, vomecrty_mixed)
copy_VarCoords(mld, vomecrty_bot)
copy_VarCoords(mld, sohefldo_mixed)
printMinMax(mld, 1)
printMinMax(votemper_mixed, 1)


votemper_mixed_CLM = clmMonTLL(votemper_mixed)
votemper_mixed_anom = calcMonAnomTLL(votemper_mixed, votemper_mixed_CLM)
votemper_bot_CLM = clmMonTLL(votemper_bot)
votemper_bot_anom = calcMonAnomTLL(votemper_bot, votemper_bot_CLM)
vozocrtx_mixed_CLM = clmMonTLL(vozocrtx_mixed)
vozocrtx_mixed_anom = calcMonAnomTLL(vozocrtx_mixed, vozocrtx_mixed_CLM)
vozocrtx_bot_CLM = clmMonTLL(vozocrtx_bot)
vozocrtx_bot_anom = calcMonAnomTLL(vozocrtx_bot, vozocrtx_bot_CLM)
vomecrty_mixed_CLM = clmMonTLL(vomecrty_mixed)
vomecrty_mixed_anom = calcMonAnomTLL(vomecrty_mixed, vomecrty_mixed_CLM)
vomecrty_bot_CLM = clmMonTLL(vomecrty_bot)
vomecrty_bot_anom = calcMonAnomTLL(vomecrty_bot, vomecrty_bot_CLM)
sohefldo_mixed_CLM = clmMonTLL(sohefldo_mixed)
sohefldo_mixed_anom = calcMonAnomTLL(sohefldo_mixed, sohefldo_mixed_CLM)
dim_anom = dimsizes(sohefldo_mixed_anom)







;==========================================================
    ;; wo_bot  = dh/dt + dhu/dx + dhv/dy
    dhdt = (/center_finite_diff_n(mld,1,False, 1, 0)/)/(86400*30)
    copy_VarCoords(mld, dhdt)
    hu = mld
    hv=hu
    hu= mld*vozocrtx_mixed
    hv = mld*vomecrty_mixed

    dhudxy =  grad_latlon_cfd(hu,hu&lat,hu&lon,True,False)
    dhudx   = dhudxy[1]

    dhvdxy =  grad_latlon_cfd(hv,hv&lat,hv&lon,True,False)
    dhvdy  = dhvdxy[0]
    
    wo_bot = dhdt + dhudx + dhvdy

    copy_VarCoords(vozocrtx_mixed, wo_bot)

    wo_bot = where(wo_bot.lt.0.0, 0.0 , wo_bot)
    wo_bot_CLM = clmMonTLL(wo_bot)
    wo_bot_anom = calcMonAnomTLL(wo_bot, wo_bot_CLM)
  



;==========================================================
    votemper_mixed_clm = votemper_mixed_anom
    do k = 0, 11
      do j = 0, dim_anom(0)/12-1
        votemper_mixed_clm(j*12+k,:,:) = (/votemper_mixed_CLM(k,:,:)/)
      end do
    end do
 

    votemper_bot_clm = votemper_bot_anom
    do k = 0, 11
      do j = 0, dim_anom(0)/12-1
        votemper_bot_clm(j*12+k,:,:) = (/votemper_bot_CLM(k,:,:)/)
      end do
    end do
 

    vozocrtx_mixed_clm = vozocrtx_mixed_anom
    do k = 0, 11
      do j = 0, dim_anom(0)/12-1
        vozocrtx_mixed_clm(j*12+k,:,:) = (/vozocrtx_mixed_CLM(k,:,:)/)
      end do
    end do


    vomecrty_mixed_clm = vomecrty_mixed_anom
    do k = 0, 11
      do j = 0, dim_anom(0)/12-1
        vomecrty_mixed_clm(j*12+k,:,:) = (/vomecrty_mixed_CLM(k,:,:)/)
      end do
    end do


    wo_bot_clm = wo_bot_anom
    do k = 0, 11
      do j = 0, dim_anom(0)/12-1
        wo_bot_clm(j*12+k,:,:) = (/wo_bot_CLM(k,:,:)/)
      end do
    end do
  




;========================================================== dTdx/y/z anom
    dTdxdy = grad_latlon_cfd(votemper_mixed_anom,votemper_mixed_anom&lat,votemper_mixed_anom&lon,True,False)
   
    dTdx_anom  = dTdxdy[1]
    dTdy_anom  = dTdxdy[0]

    dTdz_anom = (votemper_mixed_anom - votemper_bot_anom)/mld
    copy_VarCoords(votemper_mixed_anom, dTdz_anom)


;========================================================== dTdx/y/z clm

    dTclmdxdy = grad_latlon_cfd(votemper_mixed_clm,votemper_mixed_clm&lat,votemper_mixed_clm&lon,True,False)
   
    dTdx_clm  = dTclmdxdy[1]
    dTdy_clm  = dTclmdxdy[0]
     
    dTdz_clm =  (votemper_mixed_clm - votemper_bot_clm)/mld
    copy_VarCoords(votemper_mixed_clm, dTdz_clm)


;========================================================== dTdt
    dTdt = votemper_mixed_anom
    dTdt = (/center_finite_diff_n(votemper_mixed_anom,1,False, 1, 0)/)

;================================================================================= dynamics U
    Uanom_Txbar = vozocrtx_mixed_anom
    Uanom_Txbar = tofloat(-vozocrtx_mixed_anom * dTdx_clm * 86400 * 30)
    copy_VarCoords(vozocrtx_mixed_anom, Uanom_Txbar)

    printMinMax(Uanom_Txbar, opt)

    Ubar_Txanom = vozocrtx_mixed_clm
    Ubar_Txanom = -vozocrtx_mixed_clm * dTdx_anom * 86400 * 30
    copy_VarCoords(vozocrtx_mixed_anom, Ubar_Txanom)

    printMinMax(Ubar_Txanom, opt)
    
    Uanom_Txanom = -vozocrtx_mixed_anom * dTdx_anom  * 86400 * 30
    copy_VarCoords(vozocrtx_mixed_anom, Uanom_Txanom)
    printMinMax(Uanom_Txanom, opt)

;================================================================================= dynamics V
    Vanom_Tybar = vomecrty_mixed_anom
    Vanom_Tybar = tofloat(-vomecrty_mixed_anom * dTdy_clm * 86400. * 30.)

    copy_VarCoords(vomecrty_mixed_anom, Vanom_Tybar)

    printMinMax(Vanom_Tybar, opt)

    Vbar_Tyanom = vomecrty_mixed_clm
    Vbar_Tyanom = tofloat(-vomecrty_mixed_clm * dTdy_anom * 86400 * 30)
    copy_VarCoords(vomecrty_mixed_anom, Vbar_Tyanom)

    printMinMax(Vbar_Tyanom, opt)

    Vanom_Tyanom =  tofloat(-vomecrty_mixed_anom * dTdy_anom  * 86400 * 30)
    copy_VarCoords(vomecrty_mixed_anom, Vanom_Tyanom)

    printMinMax(Vanom_Tyanom, opt)

;================================================================================= dynamics W
    Wanom_Tzbar = tofloat(wo_bot_anom)
    
    Wanom_Tzbar = tofloat(-wo_bot_anom * dTdz_clm * 86400 * 30)
    copy_VarCoords(wo_bot_anom, Wanom_Tzbar)

    printMinMax(Wanom_Tzbar, opt)
 
   
    Wbar_Tzanom = tofloat(wo_bot_clm)
    Wbar_Tzanom = tofloat(-wo_bot_clm * dTdz_anom * 86400 * 30)
    copy_VarCoords(wo_bot_anom, Wbar_Tzanom)

    printMinMax(Wbar_Tzanom, opt)

    Wanom_Tzanom = tofloat(-wo_bot_anom * dTdz_anom  * 86400 * 30)
    copy_VarCoords(wo_bot_anom, Wanom_Tzanom)

    printMinMax(Wanom_Tzanom, opt)


   
;================================================================================= thermodynamics Q
    Hm = mld
    Hm = where(Hm.le.1.0, Hm@_FillValue, Hm)  ; 避免混合层过浅导致分母爆炸（比如某些陆地边缘或报错点）
    Cp = 3940;1996
    rho0 = 1022.4;1026
    ; ; --- 核心修正：计算穿透辐射 Q_pen ---
    ; R_mld1 = 0.58 * exp(-Hm / 0.35) + (1-0.58) * exp(-Hm / 23.0) 
    ; R_mld2 = 0.62 * exp(-Hm / 0.60) + (1-0.62) * exp(-Hm / 20.0) 
    ; R_mld3 = 0.67 * exp(-Hm / 1.00) + (1-0.67) * exp(-Hm / 17.0) 
    ; R_mld4 = 0.77 * exp(-Hm / 1.50) + (1-0.77) * exp(-Hm / 14.0) 
    ; R_mld5 = 0.78 * exp(-Hm / 1.40) + (1-0.78) * exp(-Hm / 7.9) 
    ; Q_pen_anom1 = (dswrf_mixed_anom * R_mld1) * 86400  * 30/(Cp*rho0*Hm)  ; 穿透到混合层底部的短波辐射距平
    ; Q_pen_anom2 = (dswrf_mixed_anom * R_mld2) * 86400  * 30/(Cp*rho0*Hm)
    ; Q_pen_anom3 = (dswrf_mixed_anom * R_mld3) * 86400  * 30/(Cp*rho0*Hm)
    ; Q_pen_anom4 = (dswrf_mixed_anom * R_mld4) * 86400  * 30/(Cp*rho0*Hm)
    ; Q_pen_anom5 = (dswrf_mixed_anom * R_mld5) * 86400  * 30/(Cp*rho0*Hm)

    Hm = mld
    Hm = where(Hm.le.1.0,Hm@_FillValue,Hm)

    Q = tofloat(sohefldo_mixed_anom* 86400 * 30/(Cp*rho0*Hm))
    ; Q = Q - Q_pen_anom2  ;; 暂时不减
    copy_VarCoords(sohefldo_mixed_anom, Q)
    Q = where(Q.ge.100..or.Q.le.-100., Q@_FillValue,Q)
    printMinMax(Q, 1)



;================================================================================= output
    UATXB = Uanom_Txbar
    VATYB = Vanom_Tybar
    WATZB = Wanom_Tzbar

    UBTXA = Ubar_Txanom
    VBTYA = Vbar_Tyanom
    WBTZA = Wbar_Tzanom

    UATXA = Uanom_Txanom
    VATYA = Vanom_Tyanom
    WATZA = Wanom_Tzanom

    Q = Q



;=================================================================================
out_path = "4_mixed_layer_budget_ORAS5/"
    system("rm "+ out_path+"Temp_tendency.nc")
    out = addfile(out_path+"Temp_tendency.nc", "c")
    out->dTdt = dTdt

out_path = "4_mixed_layer_budget_ORAS5/"
    system("rm "+ out_path+"Flux_Q.nc")
    out = addfile(out_path+"Flux_Q.nc", "c")
    out->Q = Q


out_path = "4_mixed_layer_budget_ORAS5/"
    system("rm "+ out_path+"Mixed_Layer_budget1.nc")
    out = addfile(out_path+"Mixed_Layer_budget1.nc", "c")
    out->UATXB  = UATXB
    out->VATYB  = VATYB
    out->WATZB  = WATZB

out_path = "4_mixed_layer_budget_ORAS5/"
    system("rm "+ out_path+"Mixed_Layer_budget2.nc")
    out = addfile(out_path+"Mixed_Layer_budget2.nc", "c")
    out->UBTXA  = UBTXA
    out->VBTYA  = VBTYA
    out->WBTZA  = WBTZA

    out_path = "4_mixed_layer_budget_ORAS5/"
    system("rm "+ out_path+"Mixed_Layer_budget3.nc")
    out = addfile(out_path+"Mixed_Layer_budget3.nc", "c")
    out->UATXA  = UATXA
    out->VATYA  = VATYA
    out->WATZA  = WATZA

end