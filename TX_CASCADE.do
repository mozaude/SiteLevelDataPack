
////////////////////////////////////////////////////////////////////////////////
////////////////////////IMPORT EXCEL STARTING FILE//////////////////////////////
////////////////////////////////////////////////////////////////////////////////

import excel "L:\TX import.xlsx", sheet("stata_import") firstrow

////////////////////////////////////////////////////////////////////////////////
//////////////////////////CARE & TREATMENT - START//////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//GENERATE TARGET TYPE (DSD/TA)
generate target_type = "DSD"
replace target_type = "TA" if AJUDA == 0

//ROUND TX_CURR INPUTS
replace TX_CURRQ1FY19=round(TX_CURRQ1FY19, 1)
replace TX_CURRQ2FY19=round(TX_CURRQ2FY19, 1)
replace TX_CURRQ4FY19P=round(TX_CURRQ4FY19P, 1)
replace TX_CURRQ4FY19A=round(TX_CURRQ4FY19A, 1)
replace TX_CURRQ4FY19=round(TX_CURRQ4FY19, 1)
replace TX_CURRQ4FY20P=round(TX_CURRQ4FY20P, 1)
replace TX_CURRQ4FY20A=round(TX_CURRQ4FY20A, 1)
replace TX_CURRQ4FY20=round(TX_CURRQ4FY20, 1)

//DUPLICATE SITE ROWS 24 TIMES TO CREATE SEX/AGE COMBO ROWS
expand 24
sort DATIMID

//GENERATE VARIABLE TO COUNT EACH OF 24 SITE ROWS
quietly by DATIMID:  gen dup = cond(_N==1,0,_n)

//GENERATE AGE VARIABLE
gen age = "<01"
replace age = "<01" if dup ==  2
replace age = "01-04" if dup ==  3
replace age = "01-04" if dup ==  4
replace age = "05-09" if dup ==  5
replace age = "05-09" if dup ==  6
replace age = "10-14" if dup ==  7
replace age = "10-14" if dup ==  8
replace age = "15-19" if dup ==  9
replace age = "15-19" if dup ==  10
replace age = "20-24" if dup ==  11
replace age = "20-24" if dup ==  12
replace age = "25-29" if dup ==  13
replace age = "25-29" if dup ==  14
replace age = "30-34" if dup ==  15
replace age = "30-34" if dup ==  16
replace age = "35-39" if dup ==  17
replace age = "35-39" if dup ==  18
replace age = "40-44" if dup ==  19
replace age = "40-44" if dup ==  20
replace age = "45-49" if dup ==  21
replace age = "45-49" if dup ==  22
replace age = "50+" if dup ==  23
replace age = "50+" if dup ==  24

//GENERATE COURSE AGE BAND
gen age_course = "15+"
replace age_course = "0-14" if age == "<01" | age =="01-04" | age =="05-09" | age =="10-14"

//GENERATE SEX VARIABLE
gen sex = "Female"
replace sex = "Male" if dup==2
replace sex = "Male" if dup==4
replace sex = "Male" if dup==6
replace sex = "Male" if dup==8
replace sex = "Male" if dup==10
replace sex = "Male" if dup==12
replace sex = "Male" if dup==14
replace sex = "Male" if dup==16
replace sex = "Male" if dup==18
replace sex = "Male" if dup==20
replace sex = "Male" if dup==22
replace sex = "Male" if dup==24

//GENERATE AGE RATIO VARIABLE. THE AGE RATIO IS USED TO PARTITION TX_CURR <15 AND TX_CURR 15+ TO FINER AGE BANDS
generate tx_curr_ratio = 0.0364397446911559
replace tx_curr_ratio = 0.0372238910959023 if dup ==  2
replace tx_curr_ratio = 0.145833933935665 if dup ==  3
replace tx_curr_ratio = 0.148993582684202 if dup ==  4
replace tx_curr_ratio = 0.175717984051846 if dup ==  5
replace tx_curr_ratio = 0.178641235722481 if dup ==  6
replace tx_curr_ratio = 0.137398594302254 if dup ==  7
replace tx_curr_ratio = 0.139751033516493 if dup ==  8
replace tx_curr_ratio = 0.0337356275570323 if dup ==  9
replace tx_curr_ratio = 0.0127382599128078 if dup ==  10
replace tx_curr_ratio = 0.081428351862288 if dup ==  11
replace tx_curr_ratio = 0.0360747403628699 if dup ==  12
replace tx_curr_ratio = 0.105286424216697 if dup ==  13
replace tx_curr_ratio = 0.0634966174594229 if dup ==  14
replace tx_curr_ratio = 0.0986652809594559 if dup ==  15
replace tx_curr_ratio = 0.0688769672529086 if dup ==  16
replace tx_curr_ratio = 0.0898421318422343 if dup ==  17
replace tx_curr_ratio = 0.0687657203359852 if dup ==  18
replace tx_curr_ratio = 0.0757288990702588 if dup ==  19
replace tx_curr_ratio = 0.0577991163676906 if dup ==  20
replace tx_curr_ratio = 0.0530828326002259 if dup ==  21
replace tx_curr_ratio = 0.0364670321225473 if dup ==  22
replace tx_curr_ratio = 0.0705407917560179 if dup ==  23
replace tx_curr_ratio = 0.0474712063215573 if dup ==  24

//CALCULATE FINER AGE FY19 TX_CURR APPLYING ABOVE RATIOS TO COURSE TX_CURR
generate tx_curr_p19 = 0
replace tx_curr_p19 = TX_CURRQ4FY19P*tx_curr_ratio if age_course == "0-14"
replace tx_curr_p19 = round(tx_curr_p19, 1)

generate tx_curr_a19 = 0
replace tx_curr_a19 = TX_CURRQ4FY19A*tx_curr_ratio if age_course == "15+"
replace tx_curr_a19 = round(tx_curr_a19, 1)

generate tx_curr_f19 = tx_curr_p19 + tx_curr_a19
drop tx_curr_p19
drop tx_curr_a19

//CALCULATE FINER AGE FY20 TX_CURR APPLYING ABOVE RATIOS TO COURSE TX_CURR
generate tx_curr_p = 0
replace tx_curr_p = TX_CURRQ4FY20P*tx_curr_ratio if age_course == "0-14"
replace tx_curr_p=round(tx_curr_p, 1)

generate tx_curr_a = 0
replace tx_curr_a = TX_CURRQ4FY20A*tx_curr_ratio if age_course == "15+"
replace tx_curr_a=round(tx_curr_a, 1)

generate tx_curr_f = tx_curr_p + tx_curr_a
drop tx_curr_p
drop tx_curr_a

//GENERATE AGE/SEX SPECIFIC NET_NET & TX_NEW
generate net_new = tx_curr_f - tx_curr_f19
generate tx_new = net_new

//GENERATE TX_PVLS(D)
generate tx_plvs_d = (tx_curr_f19*.7)+(tx_new*.5*.7)
replace tx_plvs_d=round(tx_plvs_d, 1)

//GENERATE TX_PLVS(N)
//FIRST TWO LINES OF CODE GENERATE VARIABLE FOR APPLICATION OF DIFFERENTIAL VIRAL SUPRESSION RATES BY AGE
generate tx_plvs_vs_age = .85
replace tx_plvs_vs_age = .75 if (age=="<01") | (age=="01-04") | (age=="05-09") | (age=="10-14") 
generate tx_plvs_n = tx_plvs_d*tx_plvs_vs_age
replace tx_plvs_n=round(tx_plvs_n, 1)

save "L:\Stata DataPack.dta", replace

//DANGEROUS CODE STARTING HERE!!! THIS MANUALLY ADDS PMTCT TX_NEW <1 TO TX_CURR
generate tx_weight_u1 = tx_curr_f / 10319
replace tx_weight_u1 =. if (age!="<01")
tabstat tx_weight_u1, stat(sum)

generate tx_curr_u1_t = tx_weight_u1 * 7696
replace tx_curr_f = tx_curr_u1_t if (age=="<01")
replace tx_curr_f =round(tx_curr_f, 1)

//DANGEROUS CODE STARTING HERE!!! THIS MANUALLY MAKES TX_NEW <1 = TO TX_CURR <1
replace tx_new = tx_curr_f if (age=="<01")

save "L:\Stata DataPack.dta", replace

////////////////////////////////////////////////////////////////////////////////
///////////////////////////CARE & TREATMENT - END///////////////////////////////
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//////////////////////////OUTPUT CHECKS AND FILES///////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//OUTPUT CHECKS
tabstat tx_curr_f19 tx_curr_f tx_new tx_plvs_d tx_plvs_n, by(age_course) stat(sum)
tabstat tx_curr_f, by (age_course) stat(sum)
tabstat tx_curr_f, by(AJUDA) stat(sum)
tabstat net_new, by(AJUDA) stat(sum)
tabstat tx_plvs_d tx_plvs_n, stat(sum)
tabstat TX_CURRQ4FY19, by(AJUDA) stat(sum)
tabstat tx_plvs_n tx_plvs_d, by(AJUDA) stat(sum)
tabstat tx_plvs_d, stat(sum)
tabstat tx_curr_f, stat(sum) by(age)
tabstat tx_new, stat(sum) by(age)
tabstat tx_curr_f tx_new, stat(sum) by(age)
tabstat tx_new tx_curr_f, stat(sum) by(AJUDA)
tabstat AJUDA, stat(count)
tabstat hts_indexfac_posT hts_indexfac_negT hts_emerg_posT hts_emerg_negT hts_inpat_posT hts_inpat_negT hts_ped_posT hts_ped_negT hts_VCT_posT hts_VCT_negT hts_otherpitc_posT hts_otherpitc_negT, stat(sum) by (AJUDA)
export excel AJUDA hts_indexfac_posT hts_indexfac_negT hts_emerg_posT hts_emerg_negT hts_inpat_posT hts_inpat_negT hts_ped_posT hts_ped_negT hts_VCT_posT hts_VCT_negT hts_otherpitc_posT hts_otherpitc_negT using "C:\Users\josep\Desktop\TX Targets Site Level post DP\site tool output\hts_target_output.xls", firstrow(variables)

//SITE TOOL OUTPUT
//TX TAB, THIS OUTPUT CODE MUST BE RUN BEFORE HAVING RUN THE CODE FOR CALCULATING HTS SITE-LEVEL TARGETS
export excel SITE_ID MECH_ID target_type age sex tx_curr_f tx_new tx_plvs_d tx_plvs_n using "L:\Stata DataPack.dta", firstrow(variables)
