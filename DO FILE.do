clear all

capture log close

cd "C:\Users\Saad\Documents\Economics uni\Second year\QM2\Empirical project"
use discrim

log using LOGFILE.smcl, replace

///*****QUESTION IV******///

//Results for All stores, Burger king, KFC, Roy Rogers, Wendy's
drop if prpblck == .

tab chain // total chains= 409
tab NJ chain // total New Jersey chains= 331
//Divide NJ chain by chain to obtain percentages for All stores, Burger king, KFC, Roy Rogers, Wendy's

tab chain if prpblck >.2 // >20% black for All stores, Burger king, KFC, Roy Rogers, Wendy's 
tab chain if prppov >.2 // >20% poverty for All stores, Burger king, KFC, Roy Rogers, Wendy's 
tab chain if prpblck >.1 // >10% black for All stores, Burger king, KFC, Roy Rogers, Wendy's 
tab chain if prppov >.1 // >10% poverty for All stores, Burger king, KFC, Roy Rogers, Wendy's 

//Values for column All NJ stores
tab NJ chain if prpblck >.2 
tab NJ chain if prppov >.2 
tab NJ chain if prpblck >.1 
tab NJ chain if prppov >.1 

//Values for T test KFC vs others
ttest KFC, by(NJ) //t =  -1.0322

gen prpblck20 = prpblck >.2
gen prppov20 = prppov >.2
gen prpblck10 = prpblck >.1
gen prppov10 = prppov >.1


ttest KFC, by(prpblck20) // t =  -3.4607
ttest KFC, by(prppov20) //  t =  -2.2410
ttest KFC, by(prpblck10) //  t =  -3.6280
ttest KFC, by(prppov10) // t =  -2.6407

//Values for Primary sample
preserve 
//dropping values according to Graddy's report
drop if crmrte ==.
drop if psoda ==.
drop if psoda2 ==.
drop if pfries ==.
drop if pfries2 ==.
drop if pentree ==.
drop if pentree2 ==.
drop if wagest ==.
drop if wagest2 ==.
drop if emp ==.
drop if emp2 ==.

tab chain // total chains = 322
tab NJ chain // NJ chains = 261

// For Primary sample values, do "(total value/322)*100"
tab chain if prpblck >.2 // total value = 53
tab chain if prppov >.2 // total value = 25 
tab chain if prpblck >.1 // total value = 103 
tab chain if prppov >.1 // total value = 69

restore





///*****QUESTION VI******///

// Generating variables according to Graddy's table

gen ameal = (psoda + pfries + pentree + psoda2 + pfries2 + pentree2)/2
gen lameal = log(ameal)
gen awagest = (wagest + wagest2)/2
gen lawagest = log(awagest)
gen aemp = (emp + emp2)/2
gen laemp = log(aemp)
gen storec = nstores<=3

preserve

drop if crmrte ==.
drop if psoda ==.
drop if psoda2 ==.
drop if pfries ==.
drop if pfries2 ==.
drop if pentree ==.
drop if pentree2 ==.
drop if wagest ==.
drop if wagest2 ==.
drop if emp ==.
drop if emp2 ==.

// Values for column 1,2 and 3

reg lameal prpblck lincome prppov ldensity lawagest laemp crmrte lhseval compown prpncar NJ storec i.chain, robust
reg lameal prpblck lincome prppov ldensity lawagest laemp crmrte lhseval compown prpncar storec i.county i.chain, robust
reg lameal prpblck lincome prppov ldensity crmrte lhseval prpncar NJ i.chain, robust

restore 

preserve

drop if psoda ==.
drop if psoda2 ==.
drop if pfries ==.
drop if pfries2 ==.
drop if pentree ==.
drop if pentree2 ==.

// Values for column 4,5 and 6

reg lameal prpblck lincome prppov i.chain, robust
reg lameal prpblck i.chain, robust
reg lameal lincome i.chain, robust

// restoring previously dropped value
restore

preserve




///*****QUESTION VII******///

//Dropping the same variables dropped in table 2 for columns 1,2 and 3

drop if wagest ==.
drop if emp ==.
drop if psoda ==.
drop if pfries ==.
drop if pentree ==.
drop if wagest2 ==.
drop if emp2 ==.
drop if psoda2 ==.
drop if pfries2 ==.
drop if pentree2 ==.
drop if crmrte ==.

//F statistics, p-values and degrees of freedom generation for First 3 columns

reg lameal prpblck lincome prppov ldensity lawagest laemp crmrte lhseval compown prpncar NJ storec i.chain, robust
testparm i.chain

reg lameal prpblck lincome prppov ldensity lawagest laemp crmrte lhseval compown prpncar storec i.county i.chain, robust
testparm i.chain i.county

reg lameal prpblck lincome prppov ldensity crmrte lhseval prpncar NJ i.chain, robust
testparm i.chain

//Testparm used to chain and county dummy variables

restore

preserve

//Dropping the same variables dropped in table 2 for columns 4,5 and 6

drop if psoda ==.
drop if pfries ==.
drop if pentree ==.
drop if psoda2 ==.
drop if pfries2 ==.
drop if pentree2 ==.

reg lameal prpblck lincome prppov i.chain, robust
testparm i.chain

reg lameal prpblck i.chain, robust
testparm i.chain

reg lameal lincome i.chain, robust
testparm i.chain

restore

preserve



///*****QUESTION VIII******///


sum prpncar, detail
//Median observed at .0738916

//Generating average prices over the 2 periods

gen apentree = (pentree + pentree2)/2
gen lapentree = log(apentree)
gen apfries = (pfries + pfries2)/2
gen lapfries = log(apfries)
gen apsoda = (psoda + psoda2)/2
gen lapsoda = log(apsoda)

//Generating franchise variable to use in the regression
gen franchise = 0

replace franchise = 1 if compown ==0
// If the store is a franchise, the dummy variable is equal to 1

//Generating other values used in the regression
gen prpncar1 = prpncar>.0738916 //based on the median
gen prpblckcar = prpblck * prpncar1
gen prpblckfranchise = prpblck * franchise
gen prpblckstorec = prpblck * storec


//column MEAL regression

reg lameal prpblck lincome prppov ldensity lawagest laemp crmrte lhseval compown prpncar storec NJ prpblckstorec prpblckfranchise prpblckcar i.chain, robust

//Generating results for column SODA, FRIES and ENTREE

drop if wagest ==.
drop if emp ==.
drop if psoda ==.
drop if pfries ==.
drop if pentree ==.
drop if wagest2 ==.
drop if emp2 ==.
drop if psoda2 ==.
drop if pfries2 ==.
drop if pentree2 ==.
drop if crmrte ==.

reg lapsoda prpblck lincome prppov ldensity lawagest laemp crmrte lhseval compown prpncar storec NJ prpblckstorec prpblckfranchise prpblckcar i.chain, robust
reg lapfries prpblck lincome prppov ldensity lawagest laemp crmrte lhseval compown prpncar storec NJ prpblckstorec prpblckfranchise prpblckcar i.chain, robust
reg lapentree prpblck lincome prppov ldensity lawagest laemp crmrte lhseval compown prpncar storec NJ prpblckstorec prpblckfranchise prpblckcar i.chain, robust

//fin

log close
