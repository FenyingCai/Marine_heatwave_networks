load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin

f1 = addfile("topography/topo_2x2.nc", "r")
topo1 = (f1->topo({-90:90},:))
dim1 = dimsizes(topo1)


network_20yrs = new((/dim1(0),dim1(1),dim1(0),dim1(1)/), float)
network_20yrs = 0.0


do ilag=0,90,30
print(" ilag = " + (ilag))
do iyear_start=0,22
print(" iyear_start = " + (iyear_start))


network_20yrs = 0.0
do iyear=0,19
; print(" iyear = " + (iyear_start+iyear+1982))
;;------------  read concurrence matrix  ------------;;
f1 = addfile("2_networks/mhw_mhw_coincidence/lag"+ilag+"/network_mhw_mhw_lag"+ilag+"_"+(iyear_start+iyear+1982)+".nc","r")
networks0 = (f1->networks0)

networks0@_FillValue = 1.0e20
value = 1.0e20
if (any(isnan_ieee(networks0))) then
      replace_ieeenan (networks0, value, 0)
      networks0@_FillValue = value
end if
network_20yrs = network_20yrs + networks0
delete(networks0)
end do




f2 = addfile("/public/home/fcai/extreme5_degree/42_marine_heatwaves/2_networks/mhw_mhw_frequency_sqrt/lag"+ilag+"/network_mhw_mhw_frequency_sqrt_lag"+ilag+"_"+(iyear_start+1982)+"_"+(iyear_start+1982+19)+".nc","r")
frequency = (f2->networks0)
frequency@_FillValue = 1.0e20
value = 1.0e20
if (any(isnan_ieee(frequency))) then
      replace_ieeenan (frequency, value, 0)
      frequency@_FillValue = value
end if
frequency = where(frequency.gt.0.0, frequency, 1.0e20)
frequency@_FillValue = 1.0e20
printMinMax(frequency, 1)

network_20yrs = network_20yrs / frequency
network_20yrs@_FillValue = 1.0e20
; network_20yrs = where(network_20yrs.gt.2.0, network_20yrs, 0.0)
network_20yrs@_FillValue = 1.0e20
; printMinMax(network_20yrs, 1)
delete(frequency)



network_20yrs!0="lat"
network_20yrs!1="lon"
network_20yrs!2="lat2"
network_20yrs!3="lon2"
network_20yrs&lat = topo1&lat
network_20yrs&lon = topo1&lon
network_20yrs&lat2 = topo1&lat
network_20yrs&lon2 = topo1&lon
printVarSummary(network_20yrs)
printMinMax(network_20yrs, 0)



;;-------------------- to nc file ---------------------;;
output="2_networks/mhw_mhw_coincidence/lag"+ilag+"/moving20yrs_sqrt/"
name1="network_mhw_mhw_lag"+ilag+"_ratiosqrt_"+(iyear_start+1982)+"_"+(iyear_start+1982+19)+""
system("/bin/rm -f "+output+name1+".nc")
ncdf1=addfile(output+name1+".nc","c")
ncdf1->networks0=network_20yrs

end do
end do
end

