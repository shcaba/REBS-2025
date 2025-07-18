#C file created using an r4ss function
#C file write time: 2025-06-24  14:18:18
#
1 #_benchmarks
2 #_MSY
0.5 #_SPRtarget
0.4 #_Btarget
#_Bmark_years: beg_bio, end_bio, beg_selex, end_selex, beg_relF, end_relF,  beg_recr_dist, end_recr_dist, beg_SRparm, end_SRparm (enter actual year, or values of 0 or -integer to be rel. endyr)
0 0 0 0 0 0 0 0 0 0
2 #_Bmark_relF_Basis
1 #_Forecast
12 #_Nforecastyrs
1 #_F_scalar
-12345  # code to invoke new format for expanded fcast year controls
# biology and selectivity vectors are updated annually in the forecast according to timevary parameters, so check end year of blocks and dev vectors
# input in this section directs creation of averages over historical years to override any time_vary changes
#_Types implemented so far: 1=M, 4=recr_dist, 5=migration, 10=selectivity, 11=rel. F, recruitment
#_list: type, method (1, 2), start year, end year
#_Terminate with -9999 for type
#_ year input can be actual year, or values <=0 to be rel. styr or endyr
#_Method = 0 (or omitted) means continue using time_vary parms; 1 means to use average of derived factor
 #_MG_type method st_year end_year
        10      1       0        0
        11      1       0        0
        12      1       0        0
-9999 0 0 0
3 #_ControlRuleMethod
0.4 #_BforconstantF
0.1 #_BfornoF
-1 #_Flimitfraction
 #_year fraction
2025  1
2026  1
# 2027  0.874
# 2028  0.865
# 2029  0.857
# 2030  0.849
# 2031  0.841
# 2032  0.833
# 2033  0.826
# 2034  0.818
# 2035  0.81
# 2036  0.803

-9999 0
3 #_N_forecast_loops
3 #_First_forecast_loop_with_stochastic_recruitment
0 #_fcast_rec_option
1 #_fcast_rec_val
0 #_Fcast_loop_control_5
2027 #_FirstYear_for_caps_and_allocations
0 #_stddev_of_log_catch_ratio
0 #_Do_West_Coast_gfish_rebuilder_output
0 #_Ydecl
0 #_Yinit
1 #_fleet_relative_F
# Note that fleet allocation is used directly as average F if Do_Forecast=4 
2 #_basis_for_fcast_catch_tuning
# enter list of fleet number and max for fleets with max annual catch; terminate with fleet=-9999
-9999 -1
# enter list of area ID and max annual catch; terminate with area=-9999
-9999 -1
# enter list of fleet number and allocation group assignment, if any; terminate with fleet=-9999
-9999 -1
2 #_InputBasis
 #_year seas fleet catch_or_F
2025  1 1 33
2025  1 2 0.1
2025  1 3 51.8
2025  1 4 3.1
2025  1 5 24.2
2025  1 6 42.9
2026  1 1 33
2026  1 2 0.1
2026  1 3 51.8
2026  1 4 3.1
2026  1 5 24.2
2026  1 6 74.5
2027  1 1 187.5531915
2027  1 2 0.568343005
2027  1 3 294.4016763
2027  1 4 17.61863314
2027  1 5 137.5390071
2027  1 6 243.8191489
2028  1 1 184.2297872
2028  1 2 0.558272083
2028  1 3 289.1849387
2028  1 4 17.30643456
2028  1 5 135.101844
2028  1 6 239.4987234
2029  1 1 180.7553191
2029  1 2 0.547743391
2029  1 3 283.7310767
2029  1 4 16.98004513
2029  1 5 132.5539007
2029  1 6 234.9819149
2030  1 1 177.3468085
2030  1 2 0.537414571
2030  1 3 278.3807479
2030  1 4 16.65985171
2030  1 5 130.0543262
2030  1 6 230.5508511
2031  1 1 174.0085106
2031  1 2 0.527298517
2031  1 3 273.1406319
2031  1 4 16.34625403
2031  1 5 127.6062411
2031  1 6 226.2110638
2032  1 1 170.9170213
2032  1 2 0.517930368
2032  1 3 268.2879304
2032  1 4 16.05584139
2032  1 5 125.3391489
2032  1 6 222.1921277
2033  1 1 167.6574468
2033  1 2 0.508052869
2033  1 3 263.1713862
2033  1 4 15.74963894
2033  1 5 122.9487943
2033  1 6 217.9546809
2034  1 1 164.6021277
2034  1 2 0.498794326
2034  1 3 258.375461
2034  1 4 15.46262411
2034  1 5 120.708227
2034  1 6 213.982766
2035  1 1 161.3702128
2035  1 2 0.489000645
2035  1 3 253.302334
2035  1 4 15.15901999
2035  1 5 118.338156
2035  1 6 209.7812766
2036  1 1 158.3574468
2036  1 2 0.479871051
2036  1 3 248.5732044
2036  1 4 14.87600258
2036  1 5 116.1287943
2036  1 6 205.8646809
-9999 0 0 0
#
999 # verify end of input 
