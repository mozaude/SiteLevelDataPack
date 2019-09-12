# SiteLevelDataPack
STATA code for producing site level targets to input into the Site Target Tool

# Step 1: facility level TX targets
Inputs & Assumptions needed:
  1. Site level TX_CURR targets
  2. Finer age/sex ratios
  3. % of last year's TX_CURR eligible for VL (From datapack)
  4. Target Viral Suppression rates by age/sex (%)
  
Functions:
  1. Applies DSD/TA according to AJUDA/non-AJUDA sites 
  2. Applies finer age/sex ratios
  3. Generates site level age/sex disaggregated targets 
  
Exports:
  1. Site level age/sex disaggregated targets for TX_CURR, TX_NEW, TX_PVLS_D and TX_PVLS_N, in a format ready to paste into the Site Target Tool
  
*** Note: after this step, must run "Cookie" using district level TX_NEW, to generate district level HTS_POS and HTS_NEG targets for each facility modality, to be used in Step 2***

# Step 2: facility level HTS_POS and HTS_NEG targets for facility modalities 
Inputs & Assumptions:
  1. Site level TX_NEW targets
  2. District level HTS_POS and HTS_NEG targets for each facility modality 
  
Functions:
  1. Generates weights for TX_NEW by age/sex for each facility within a district
  2. Applies weights to HTS district level targets to distribute to site level 
  3. Moves all HTS targets for non-AJUDA (TA) sites into OtherPITC modality 
  
Exports: 
  1. Site level age/sex disaggregated HTS_POS and HTS_NEG targets for all facility modalities (Index, Emergency, Inpatient, Pediatrics, VCT, OtherPITC), in a format ready to paste into the Site Target Tool

# Step 3: facility level TX_NEW targets for KP
Inputs and Assumptions: 
  1. Site level TX_NEW targets
  2. TX_NEW KP district level targets (by KP type) from Site Target Tool, in a spreadsheet with 3 columns:
      column 1: district name
      column 2: KP type (FSW, MSM, PWID, People in prisons and other enclosed settings)
      column 3: target (district level)
  
Functions:
  1. Generate weights for TX_NEW for each facility within a district (age/sex collapsed)
  2. Applies weights to TX_NEW KP district level targets to generate facility level TX_NEW targets by KP type
  3. Reformat for input into Site Target Tool 
  
Exports:
  1. Community (district) level TX_NEW targets for each KP type (FSW, MSM, PWID, Prisoners), in a format ready to paste into the Site Target Tool 
