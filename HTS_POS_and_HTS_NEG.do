///////////////////////////////
/////////////////////////////// CODE FOR GENERATING HTS_POS and HTS_NEG SITE LEVEL TARGETS FOR FACILITY MODALITIES
///////////////////////////////
//***FIRST STEP*** make sure file paths are updated!***//


///open file containing TX_NEW site level targets 
clear
use "L:\Stata DataPack.dta", clear

//collapse tx_new by district 
collapse (sum) tx_new, by (unique_id)
rename tx_new tx_new_dist

//export district TX_NEW into new dataset file 
save "L:\tx_new collapsed district.dta", replace

//reopen site level dataset, reduce to tx_new only, and save as new dataset
clear
use "L:\Stata DataPack.dta", clear
keep  DATIMID SITE_ID MECH_ID PARTNERCOP18 PARTNERCOP19 MECH_NAME AgencyCOP19 PROVINCE DISTRICT DISTRICT_ID DATIMSITENAME DISTRICTTYPE AJUDA target_type age age_course sex tx_new unique_id

save "L:\Stata DataPack tx_new only.dta"

//merge in district tx_new and create weights for sites
merge m:1 unique_id using "L:\tx_new collapsed district.dta"
gen weight = tx_new / tx_new_dist

save "L:\Stata DataPack tx_new merged.dta"

//merge in htc district
rename _merge _mergetx
merge m:1 unique_id using "L:\HTS district level inputs.dta"

save "L:\Stata DataPack tx_new hts merged.dta"

//generate htc targets
gen hts_indexfac_posT = weight* HTS_INDEX_FACPos
gen hts_indexfac_negT = weight* HTS_INDEX_FACNeg
gen hts_emerg_posT = weight* HTS_TST_EmergPos
gen hts_emerg_negT = weight* HTS_TST_EmergNeg
gen hts_inpat_posT = weight* HTS_TST_InpatPos
gen hts_inpat_negT = weight* HTS_TST_InpatNeg
gen hts_ped_posT = weight* HTS_TST_PedPos
gen hts_ped_negT = weight* HTS_TST_PedNeg
gen hts_VCT_posT = weight* HTS_TST_VCTPos
gen hts_VCT_negT = weight* HTS_TST_VCTNeg
gen hts_otherpitc_posT = weight* HTS_TST_OtherPITCPos
gen hts_otherpitc_negT = weight* HTS_TST_OtherPITCNeg

save "L:\Stata DataPack tx_new hts targets.dta", replace 

replace hts_indexfac_posT =round(hts_indexfac_posT,1)
replace hts_indexfac_negT = round(hts_indexfac_negT,1)
replace hts_emerg_posT = round(hts_emerg_posT,1)
replace hts_emerg_negT = round(hts_emerg_negT,1)
replace hts_inpat_posT = round(hts_inpat_posT,1)
replace hts_inpat_negT = round(hts_inpat_negT,1)
replace hts_ped_posT = round(hts_ped_posT,1)
replace hts_ped_negT = round(hts_ped_negT,1)
replace hts_VCT_posT = round(hts_VCT_posT,1)
replace hts_VCT_negT = round(hts_VCT_negT,1)
replace hts_otherpitc_posT = round(hts_otherpitc_posT,1)
replace hts_otherpitc_negT = round(hts_otherpitc_negT,1)

replace hts_indexfac_posT =0 if hts_indexfac_posT ==. 
replace hts_indexfac_negT =0 if hts_indexfac_negT ==.
replace hts_emerg_posT =0 if hts_emerg_posT ==.
replace hts_emerg_negT =0 if hts_emerg_negT ==.
replace hts_inpat_posT =0 if hts_inpat_posT ==.
replace hts_inpat_negT =0 if hts_inpat_negT ==.
replace hts_ped_posT =0 if hts_ped_posT ==.
replace hts_ped_negT =0 if hts_ped_negT ==.
replace hts_VCT_posT =0 if hts_VCT_posT ==.
replace hts_VCT_negT =0 if hts_VCT_negT ==.
replace hts_otherpitc_posT =0 if hts_otherpitc_posT ==.
replace hts_otherpitc_negT =0 if hts_otherpitc_negT ==.

save "L:\Stata DataPack tx_new hts targets rounded.dta", replace 

//move all targets for MISAU sites (non-AJUDA sites) into OtherPICT Modality
gen totalposT = hts_indexfac_posT+ hts_emerg_posT+ hts_inpat_posT+ hts_ped_posT+ hts_VCT_posT+ hts_otherpitc_posT
gen totalnegT = hts_indexfac_negT+ hts_emerg_negT+ hts_inpat_negT+ hts_ped_negT+ hts_VCT_negT+ hts_otherpitc_negT

replace hts_indexfac_posT = 0 if AJUDA==0
replace hts_indexfac_negT =0 if AJUDA==0
replace hts_emerg_posT =0 if AJUDA==0
replace hts_emerg_negT =0 if AJUDA==0
replace hts_inpat_posT =0 if AJUDA==0
replace hts_inpat_negT =0 if AJUDA==0
replace hts_ped_posT =0 if AJUDA==0
replace hts_ped_negT =0 if AJUDA==0
replace hts_VCT_posT =0 if AJUDA==0
replace hts_VCT_negT =0 if AJUDA==0
replace hts_otherpitc_posT =0 if AJUDA==0
replace hts_otherpitc_negT =0 if AJUDA==0

replace hts_otherpitc_posT =totalposT if AJUDA==0
replace hts_otherpitc_negT =totalnegT if AJUDA==0

save "L:\Stata DataPack tx_new hts targets rounded MISAUpitc.dta", replace 

//SITE TOOL OUTPUT
//HTS TAB facility targets only
export excel SITE_ID MECH_ID target_type age sex hts_indexfac_posT hts_indexfac_negT hts_emerg_posT hts_emerg_negT hts_inpat_posT hts_inpat_negT hts_ped_posT hts_ped_negT hts_VCT_posT hts_VCT_negT hts_otherpitc_posT hts_otherpitc_negT using "L:\hts_output.xls", firstrow(variables)
