///Code for distributing KP TX_NEW from district level to AJUDA sites using TX_NEW weights for sites within a district///
//***FIRST STEP*** make sure file paths are updated!***//

//open site level tx_new target file
use "L:\Stata DataPack.dta", clear

//collapse tx_new by district and export into new dataset file
collapse (sum) tx_new, by (DISTRICT)
rename tx_new tx_new_dist_tot
save "L:\tx_new collapsed district no age bands.dta", replace
clear

//collapse tx_new by facility and export into new dataset file
use "L:\Stata DataPack.dta", clear
collapse (sum) tx_new, by (SITE_ID MECH_ID DISTRICT AJUDA target_type)
rename tx_new tx_new_fac
save "L:\tx_new collapsed facility.dta", replace

//create weights for facilities within a district
merge m:1 DISTRICT using "L:\tx_new collapsed district no age bands.dta"
gen weight = tx_new_fac/ tx_new_dist_tot
drop if AJUDA ==0
drop if AJUDA ==.
save  "L:\tx_new weight for KP.dta", replace

//reshape Site Tool KP data from long to wide format
clear
import excel "L:\Tx-new KP.xlsx", sheet("Sheet1") firstrow
gen KP = word( KeyPop,1)
drop KeyPop
reshape wide TX_NEWKeyPop, i(District) j(KP) string
save  "L:\TX_NEW KP wide format.dta", replace

//merge weights with KP tx_new data, then apply weights to generate KP_tx_new targets
use "L:\tx_new weight for KP.dta", clear
rename DISTRICT District
rename _merge _merge1
sort District
merge m:1 District using "L:\TX_NEW KP wide format.dta"
save "L:\TX_NEW KP wide format merge.dta", replace

replace TX_NEWKeyPopFSW = TX_NEWKeyPopFSW* weight
replace TX_NEWKeyPopMSM= TX_NEWKeyPopMSM*weight
replace TX_NEWKeyPopPWID= TX_NEWKeyPopPWID*weight
replace TX_NEWKeyPopPeople =TX_NEWKeyPopPeople*weight

//replace TX_NEWKeyPopFSW = round(TX_NEWKeyPopFSW* weight,1)
//replace TX_NEWKeyPopMSM= round(TX_NEWKeyPopMSM*weight,1)
//replace TX_NEWKeyPopPWID= round(TX_NEWKeyPopPWID*weight,1)
//replace TX_NEWKeyPopPeople =round(TX_NEWKeyPopPeople*weight,1)

//reshape results from wide to long format 
drop District AJUDA target_type tx_new_fac tx_new_dist_tot _merge1 weight _merge
reshape long TX_NEWKeyPop, i(SITE_ID) j(KeyPop) string
drop if TX_NEWKeyPop == .
replace KeyPop = "People in prisons and other enclosed settings" if KeyPop=="People"
gen target_type = "DSD"
save "L:\TX_NEW KP site targets.dta", replace

//check total KP_tx_new target
tabstat TX_NEWKeyPop, stat(sum)

//export KP_TX_NEW for Site Target Tool
export excel SITE_ID MECH_ID target_type KeyPop TX_NEWKeyPop using "L:\kp_tx_new_output.xls", firstrow(variables)
