load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin

z =(/0.50576, 1.555855, 2.667682, 3.85628, 5.140361, 6.543034, 8.092519, \
    9.82275, 11.77368, 13.99104, 16.52532, 19.4298, 22.75762, 26.5583, \
    30.87456, 35.7402, 41.18002, 47.21189, 53.85064, 61.11284, 69.02168, \ 
    77.61116, 86.92943, 97.04131, 108.0303, 120, 133.0758, 147.4062, \
    163.1645, 180.5499, 199.79, 221.1412, 244.8906, 271.3564, 300.8875, \ 
    333.8628, 370.6885, 411.7939, 457.6256, 508.6399/)

var_name1 = (/"pt_2x2","u_2x2","v_2x2","ndhf_2x2"/)
var_name2 = (/"oras5_votemper_2x2_","oras5_vozocrtx_2x2_","oras5_vomecrty_2x2_","oras5_sohefldo_2x2_"/)
var_name = (/"votemper","vozocrtx","vomecrty","sohefldo"/)
var_name_out1 = (/"votemper","vozocrtx","vomecrty","sohefldo"/) +"_mixed_avg"
var_name_out2 = (/"votemper","vozocrtx","vomecrty","sohefldo"/) +"_mixed_bot"
path = "ORAS5_monthly/"
out_path = "4_mixed_layer_budget_ORAS5/ave/"

do iyear = 0,1
    year_str = flt2string(iyear+1982)
    print(" iyear = " + year_str)

    ;;========================== 混合层深度 ==========================;;
    fin := addfile(path + "mld03_2x2/oras5_somxl030_2x2_"+year_str+".nc", "r")
    mld := fin->somxl030
    dz_4d = dpres_plevel(z, mld, 0, 0)   ;; time, level, lat, lon 
    copy_VarCoords(mld, dz_4d(:,1,:,:))
    mld_clm_4d = conform_dims(dimsizes(dz_4d), mld, (/0,2,3/))

    do i = 0, dimsizes(var_name)-1
        print("*********** var name = " + var_name(i)+"*********")
        filein = addfile(path + var_name1(i)+"/"+var_name2(i)+year_str+".nc", "r")
        var := filein->$var_name(i)$
        var = where(var.eq."nan", var@_FillValue, var)
        
        ; --- 分流处理：3D 物理量 vs 2D 表面强迫通量 ---
        if var_name(i).ne."sohefldo" then 
            
            ; 1. 提取深度坐标 (推荐使用维度坐标直接提取)
            depth = z ;var&$var&dims(1)$  ; 自动获取第1维(depth/level)的坐标值

            ; 2. 构造 4D 的深度矩阵 (Time, Depth, Lat, Lon)
            depth_4d = conform_dims(dimsizes(var), depth, 1)

            ; 3. 计算每个网格点的垂直层厚度 dz (单位: 米)
            ;    使用 1D 深度计算各层边界 delta_z
            nz = dimsizes(depth)
            dz_1d = new(nz, typeof(depth))
            dz_1d(0) = depth(0) + (depth(1)-depth(0))/2.0
            do zk = 1, nz-2
                dz_1d(zk) = (depth(zk+1) - depth(zk-1)) / 2.0
            end do
            dz_1d(nz-1) = depth(nz-1) - depth(nz-2)
            
            dz_4d = conform_dims(dimsizes(var), dz_1d, 1)

            ; 4. 核心逻辑：创建混合层掩码 (只有在 MLD 之内 且 海水温度有效的点 才保留)
            ;    如果 depth <= MLD 且 var 不是缺测，则保留权重；否则设为 0
            weight = where(.not.ismissing(var) .and. depth_4d .le. mld_clm_4d, dz_4d, 0.0)

            ; 5. 计算分子 (var * weight) 和分母 (dz 累加)
            var_weighted = var * weight
            
            dz_sum = dim_sum_n_Wrap(weight, 1)
            dz_sum = where(dz_sum.gt.0.0, dz_sum, 1.0e20)
            dz_sum@_FillValue = 1.0e20
            var_sum = dim_sum_n_Wrap(var_weighted, 1)

            ;; 6. 计算混合层垂直加权平均 (避免除以 0)
            var_mixed = where(dz_sum .gt. 0.0, var_sum / dz_sum, var@_FillValue)
            copy_VarCoords(mld, var_mixed)

            ;; 7. 计算混合层底部插值 (使用线性插值)
            ;  注意：确保 mld_clm_4d 维度和 var 匹配
            if var_name(i).eq."votemper" then 
                target_mld = mld_clm_4d + 5.0
            else
                target_mld = mld_clm_4d
            end if 
            
            ; int2p_n 要求插值坐标，这里进行垂直插值
            var_bot_chazhi = int2p_n_Wrap(depth, var, target_mld, 1, 1)
            
            var_bot = var_bot_chazhi(:,0,:,:)
            delete(var_bot_chazhi)
            copy_VarCoords(var(:,0,:,:), var_bot) ; 继承 spatial 属性
            delete(var_bot&time)
            var_bot!0="time"
            var_bot&time=fspan(1, 12, 12)
        else 
            ;; 如果是 thflx 表面通量，直接等于原数据即可
            var_mixed := var
            var_mixed = where(var_mixed.ge.10000.0.or.var_mixed.le.-10000.0, var_mixed@_FillValue, var_mixed)
        end if
        delete(var_mixed&time)
        var_mixed!0="time"
        var_mixed&time=fspan(1, 12, 12)


        ;;============ 写出到 NC 文件（注意：按年份区分文件名，防止相互覆盖） =============;;
        nc_filename = out_path + var_name(i) + "_mixed_" + year_str + ".nc"
        system("rm -f " + nc_filename)
        fout_var = addfile(nc_filename, "c")
        
        if var_name(i).ne."thflx" then 
            fout_var->$var_name_out1(i)$ = var_mixed
            fout_var->$var_name_out2(i)$ = var_bot
        else
            fout_var->$var_name_out1(i)$ = var_mixed
        end if 
    end do
end do 

end

