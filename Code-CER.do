* Use six waves of CHNS data collected in 2000, 2004, 2006 , 2009, 2011 and 2015 to do the work
* 2022-09-30

* Preparation
clear all
set mem 1g  
set more off
cap log close
set matsize 5000
gl path1 = "C:XXX\Data\covert-data"
gl path2 = "C:XXX\Data\workdata"
gl path3 = "C:XXX\Data\IV_data"


***** Results *****
use "$path2\working_data.dta", clear
**** Table3:Schooling outcomes
global xlist0 "Male Age Cook_food Log_HHinc  Mother_livhom Father_livhom Mother_edu Father_edu Mother_farmer Father_farmer Has_sib  i.idprovince i.wave" 

probit Schooling Use_biomass  $xlist0, cluster (idprovince )
est store m1
reg School_Years Use_biomass  $xlist0, cluster (idprovince )
est store m2
reg Grade_progression Use_biomass  $xlist0, cluster (idprovince )
est store m3
esttab m1 m2 m3 

**** Descriptive results ****
**** Table1:Variable Definition and Summary Statistics
keep if Age>=6 & Age<=18 & Urban_Rural==2 & Schooling==1 & Child_livhom==1
sum Part_EIAs Use_biomass Cook_food cooktime1 CookTime_Others Male Edu Age HHinc  Mother_livhom Father_livhom /*
*/Mother_edu Father_edu Mother_farmer /*
*/ Father_farmer  Has_sib  perdryAgriPro1

**** Table2:Percentage of Schoolchildren Participating in EIAs by Various Characteristics


**** Basic results ****
global xlist "Male Age Edu  Log_HHinc  Mother_livhom Father_livhom Mother_edu Father_edu Mother_farmer Father_farmer Has_sib  i.idprovince i.wave" 

**** Table4:Probit regressions of schoolchildren's EIA participation
probit Part_EIAs Use_biomass Cook_food $xlist, cluster (idprovince )
est store m1
margins, dydx(*)  post
est store probit_1
probit Part_EIAs Use_biomass LogCookTime $xlist, cluster (idprovince)
est store m2
margins, dydx(*)  post
est store probit_2
esttab  m1 probit_1 m2 probit_2

**** Table5: Biomass vs. coal
probit Part_EIAs solid_fuel Cook_food $xlist, cluster (idprovince)
est store m1
margins, dydx(*)  post
est store probit_1

preserve
drop if  L8_1==6 |L8_1==3 |L8_1==7 |L8_1==8 
tab L8_1
gen coal=(L8_1==1)
probit Part_EIAs coal Cook_food  $xlist, cluster (idprovince)
est store m2
margins, dydx(*)  post
est store probit_2
restore
esttab  m1 probit_1 m2 probit_2


**** Table 6: IV results
**** Table 6:Extended Probit Regressions of Schoolchildren's EIA Participation
eprobit Part_EIAs Cook_food $xlist , endogenous( Use_biomass = lnperdryAgriPro1 Cook_food  $xlist , probit)
est store m1
eprobit Part_EIAs LogCookTime $xlist , endogenous( Use_biomass = lnperdryAgriPro1 LogCookTime  $xlist , probit)
est store m2
esttab m1 m2 


**** Table7: Heterogeneity analysis
global xlist1 " Male Age  Log_HHinc  Mother_livhom Father_livhom Mother_edu Father_edu Mother_farmer Father_farmer Has_sib  i.idprovince i.wave" 

** Model 2a **
probit Part_EIAs  NBio_Coo  Bio_Coo Bio_NCoo Edu $xlist1 , cluster (idprovince)
est store m1a
margins, dydx(*)  post
est store probit_1a
** Model 3a **
probit Part_EIAs  NBio_Male Bio_Female Bio_Male Cook_food Edu $xlist1 , cluster (idprovince)
est store m2a
margins, dydx(*)  post
est store probit_2a
** Model 4a **
probit Part_EIAs Bio_Prim NBio_Juni Bio_Juni NBio_Seni Bio_Seni Cook_food Male $xlist1, cluster (idprovince)
est store m3a
margins, dydx(*)  post
est store probit_3a
esttab m1a probit_1a m2a probit_2a m3a probit_3a

**Table A.6  Heterogeneity analysis with cooking intensity
probit Part_EIAs Use_biomass Non_biomass  Biomass $xlist, cluster (idprovince)
est store m1b
margins, dydx(*)  post
est store probit_1b
** Model 3b **
probit Part_EIAs  NBio_Male Bio_Female Bio_Male  LogCookTime Edu $xlist1, cluster (idprovince)
est store m2b
margins, dydx(*)  post
est store probit_2b
** Model 4b **
probit Part_EIAs Bio_Prim NBio_Juni Bio_Juni NBio_Seni Bio_Seni LogCookTime Male  $xlist1, cluster (idprovince)
est store m3b
margins, dydx(*)  post
est store probit_3b
esttab m1b probit_1b m2b probit_2b m3b probit_3b


***********Supplementary Materials***********
global xlist "Male Edu Age Log_HHinc  Mother_livhom Father_livhom Mother_edu Father_edu Mother_farmer Father_farmer Has_sib  i.idprovince i.wave" 

**Table A.1 Results from Various Specifications with different Controls

*model 1a
probit Part_EIAs Use_biomass Cook_food $xlist, cluster (idprovince)
est store m1a
*model 1as1
probit Part_EIAs Use_biomass Cook_food Male Edu Age Log_HHinc i.idprovince i.wave,cluster (idprovince)
est store m1as1
*model 1as2
probit Part_EIAs Use_biomass  i.idprovince i.wave, cluster (idprovince)
est store m1as2
 
probit Part_EIAs Use_biomass LogCookTime $xlist, cluster (idprovince)
est store m1b
*model 1bs1
probit Part_EIAs Use_biomass LogCookTime Male Edu Age  Log_HHinc i.idprovince i.wave,cluster (idprovince)
est store m1bs1
*model 1as2
probit Part_EIAs Use_biomass i.idprovince i.wave, cluster (idprovince)
est store m1bs2
esttab m1a m1as1 m1as2 m1b m1bs1 m1bs2 


**Table A.2 Biomass vs. coal with Log (CookTime)
probit Part_EIAs solid_fuel LogCookTime $xlist, cluster (idprovince)
est store m1
margins, dydx(*)  post
est store probit_1

preserve
drop if  L8_1==6 |L8_1==3 |L8_1==7 |L8_1==8 
tab L8_1
gen coal=(L8_1==1)
probit Part_EIAs coal LogCookTime  $xlist, cluster (idprovince)
est store m2
margins, dydx(*)  post
est store probit_2
restore
esttab  m1 probit_1 m2 probit_2




**Table A.3 RBP Regressions of Schoolchildren's EIA Participation

biprobit (Part_EIAs= Use_biomass Cook_food  $xlist) (Cook_food= Use_biomass LogCookTime_Others $xlist), cluster (idprovince)
est store mrbp


**Table A.4 Results from Two-Stage Control Function Approach
reg LogCookTime LogCookTime_Others Use_biomass $xlist , cluster (idprovince)
predict e, residual
ivprobit Part_EIAs Use_biomass e $xlist (LogCookTime =LogCookTime_Others),  nolog
asdoc ivprobit Part_EIAs Use_biomass e $xlist (LogCookTime =LogCookTime_Others), first twostep
est store m1a


**Table A.5  Extended Probit Regressions of Schoolchildren's EIA Participation

eprobit Part_EIAs Cook_food $xlist , endogenous( Use_biomass = lnperdryAgriPro1 Cook_food  $xlist , probit)
est store m1
margins, dydx(*)  post
est store ep_1

eprobit Part_EIAs LogCookTime $xlist , endogenous( Use_biomass = lnperdryAgriPro1 LogCookTime  $xlist , probit)
est store m2
margins, dydx(*)  post
est store ep_2
esttab ep_1 ep_2







