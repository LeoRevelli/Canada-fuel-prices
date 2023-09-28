clear
cd "C:\Users\lucie\Downloads\Econometrics 3 - group report\data"

import delimited unique_cities_csv.csv, encoding("utf-8") varnames(1) clear
*bindquote(nobind)
save "zipcode_database.dta", replace

import delimited oil_retail_prices_canada.csv, encoding("utf-8") bindquote(nobind) varnames(1) clear
save "oil_retail_prices_canada.dta", replace

use oil_retail_prices_canada.dta, clear
rename lecity city
save "oil_retail_prices_canada.dta", replace

use "zipcode_database.dta", clear
keep if country == "Canada"
replace city = upper(city)
save "zipcode_database.dta", replace

use "oil_retail_prices_canada.dta", clear
replace city = subinstr(city, "*", "", .)
replace city = subinstr(city, "VAUGHAN/", "",.)
replace city = subinstr(city, "É", "E", .)
replace city = subinstr(city, "CITY OF TORONTO", "TORONTO",.)
replace city = subinstr(city, "È","E",.)
replace city = subinstr(city, "ST.""ST","SAINT",.)
replace city = subinstr(city, "'"," ",.)
replace city = subinstr(city, "SAINT CATHARINES","ST CATHARINES",.)
replace city = subinstr(city, "ST JOHNS","SAINT JOHNS",.)
*replace var1 = ustrtranslate(char(var1), "áéíóúàèìòùâêîôûäëïöüãõñçÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÄËÏÖÜÃÕÑÇ", "aeiouaeiouaeiouaeiouaoncAEIOUAEIOUAEIOUAEIOUAONC")
save "oil_retail_prices_canada.dta", replace

use zipcode_database, clear
replace city = subinstr(city, "Ã", "E", .)
replace city = subinstr(city, "ST.""ST","SAINT",.)
bysort city: keep if _n == 1
merge 1:1 city using oil_retail_prices_canada
drop if missing(le1_3-le12_30)
drop country countryiso
save "merged_database.dta", replace

### CONTROLS

	#population
import delimited "9810000201_donneesselectionnees (4).csv", varnames(1) clear 
save "population", replace
keep géo valeur
rename géo city
replace city=upper(city)
replace city=subinstr(city, "St. John's","SAINT JOHNS",.)
save "population", replace
replace city=subinstr(city, "é","E",.)
replace city=subinstr(city, "è","E",.)
replace city=subinstr(city, "-"," ",.)
replace city=subinstr(city, "ST.""ST","SAINT",.)
replace city=subinstr(city, "SAINT CATHARINES","ST CATHARINES",.)
replace city=subinstr(city, "LLOYDMINSTER (PART)","LLOYDMINSTER",.)
replace city=subinstr(city, "STE.","STE",.)
replace city=subinstr(city, "VAL D'OR","VAL D OR",.)
replace city=subinstr(city, "GREATER SUDBURY / GRAND SUDBURY","SUDBURY",.)
replace city=subinstr(city, "'","",.)
replace city=subinstr(city, "SAGUENAY","CHICOUTIMI",.)
rename valeur population
save "population", replace

use "merged_database.dta", clear
drop _merge
save "merged_database.dta", replace
use population
bysort city: keep if _n == 1
merge 1:1 city using "merged_database.dta"
drop if missing(le1_3-le12_30)
save population, replace
save "merged_database.dta", replace
drop _merge
save "merged_database.dta", replace

	#density
import delimited "9810000201_donneesselectionnees (5).csv", varnames(1) clear 
save "density", replace
keep géo valeur
rename géo city
replace city=upper(city)
replace city=subinstr(city, "St. John's","SAINT JOHNS",.)
save "density", replace
replace city=subinstr(city, "é","E",.)
replace city=subinstr(city, "è","E",.)
replace city=subinstr(city, "-"," ",.)
replace city=subinstr(city, "ST.""ST","SAINT",.)
replace city=subinstr(city, "SAINT CATHARINES","ST CATHARINES",.)
replace city=subinstr(city, "LLOYDMINSTER (PART)","LLOYDMINSTER",.)
replace city=subinstr(city, "STE.","STE",.)
replace city=subinstr(city, "GREATER SUDBURY / GRAND SUDBURY","SUDBURY",.)
replace city=subinstr(city, "'","",.)
replace city=subinstr(city, "SAGUENAY","CHICOUTIMI",.)
save "density", replace
use "merged_database.dta", clear
save "merged_database.dta", replace
use "merged_database.dta"
bysort city: keep if _n == 1
merge 1:m city using density
drop _merge
drop if missing(le1_3-le12_30)
rename valeur density
save "merged_database.dta", replace


import delimited "2310006601_databaseLoadingData (1).csv", varnames(1) clear 
save "gross_sale_gas", replace
keep geo value
rename geo state
save "gross_sale_gas", replace
replace state=subinstr(state, "é","E",.)
replace state=subinstr(state, "è","E",.)
replace state=subinstr(state, "-"," ",.)
save "gross_sale_gas", replace
merge 1:m state using "merged_database.dta"
drop if missing(le1_3-le12_30)
rename value gas_gross_sale
save "merged_database.dta", replace

	#state refinery dummy
gen state_refinery = 0

replace state_refinery = 1 if state == "British Columbia"
replace state_refinery = 1 if state =="Alberta"
replace state_refinery = 1 if state =="Saskatchewan"
replace state_refinery = 1 if state =="Ontario"
replace state_refinery = 1 if state =="Quebec"

	#treatment dummy
gen treatment = 0
replace treatment = 1 if state =="Ontario"
save "merged_database.dta", replace
	
	*State taxes
import delimited state_taxes.csv, encoding("utf-8") bindquote(nobind) varnames(1) clear
save "state_taxes.dta", replace

use "merged_database.dta", clear
drop _merge
merge m:1 state using "state_taxes.dta"
drop _merge
bysort city: keep if _n == 1
drop if missing(city)
replace aggreg_state_tax=subinstr(aggreg_state_tax, "%","",.)
save "merged_database.dta", replace
save "merged_database1.dta", replace
save "merged_database2.dta", replace
save "merged_database3.dta", replace
save "merged_database4.dta", replace
save "merged_database5.dta", replace
save "merged_database6.dta", replace
save "merged_database7.dta", replace
save "merged_database8.dta", replace
save "merged_database9.dta", replace
save "merged_database10.dta", replace
save "merged_database11.dta", replace
save "merged_database12.dta", replace
save "merged_database13.dta", replace
save "merged_database14.dta", replace
save "merged_database15.dta", replace
save "merged_database16.dta", replace
save "merged_database17.dta", replace


**data description 
use "merged_database", clear
summarize
keep city treatment le6_30-le7_15 population density aggreg_state_tax gas_gross_sale

**# Bookmark #6
**diff-in-diff ontario July 1
use merged_database, clear
keep city treatment le7_15 le6_30 population density aggreg_state_tax gas_gross_sale

reshape long le, i(city) j(day) string
replace day=subinstr(day, "6_30", "1",.)
replace day=subinstr(day, "7_15", "2",.)
save "long_data", replace
gen post = 0
replace post = 1 if day=="2" 

gen did = post * treatment
regress le post treatment did
estimates store b1
regress le post treatment did population
estimates store b2
regress le post treatment did density
estimates store b3
regress le post treatment did gas_gross_sale
estimates store b4
regress le post treatment did population gas_gross_sale
estimates store b5
regress le post treatment did density gas_gross_sale
estimates store b6

esttab b1 b2 b3 b4 b5 b6 using ontario_did.tex, replace title("DiD Ontario July 1") label

**# Bookmark #7
**pre trend diff in diff : Placebo test for ontario
use merged_database7, clear
keep city treatment le6_30 le6_15 population density aggreg_state_tax gas_gross_sale

reshape long le, i(city) j(day) string
replace day=subinstr(day, "6_15", "1",.)
replace day=subinstr(day, "6_30", "2",.)
gen post_ont_pre = 0
replace post_ont_pre = 1 if day=="2" 

gen did_pop = post_ont_pre * treatment
regress le post_ont_pre treatment did_pop
estimates store b1op
regress le post_ont_pre treatment did_pop population
estimates store b2op
regress le post_ont_pre treatment did_pop density
estimates store b3op
regress le post_ont_pre treatment did_pop gas_gross_sale
estimates store b4op
regress le post_ont_pre treatment did_pop population gas_gross_sale
estimates store b5op
regress le post_ont_pre treatment did_pop density gas_gross_sale
estimates store b6op
esttab b1op b2op b3op b4op b5op b6op using pla_ontario_did.tex, replace title("DiD placebo, just before tax cut") label


**# Bookmark #8
**pre trend diff in diff : Placebo test for alberta
use merged_database1, clear
keep city treatment state le5_16 le5_31 population density aggreg_state_tax gas_gross_sale
gen treatment_alberta =0
replace treatment_alberta = 1 if state =="Alberta"

reshape long le, i(city) j(day) string
replace day=subinstr(day, "5_16", "1",.)
replace day=subinstr(day, "5_31", "2",.)
gen post_ap = 0
replace post_ap = 1 if day=="2" 

gen did_pre_ap = post_ap * treatment_alberta
regress le post treatment_alberta did_pre_ap
estimates store r1
regress le post_ap treatment_alberta did_pre_ap population
estimates store r2
regress le post_ap treatment_alberta did_pre_ap density
estimate store r3
regress le post_ap treatment_alberta did_pre_ap gas_gross_sale
estimate store r4
regress le post_ap treatment_alberta did_pre_ap population gas_gross_sale
estimate store r5
regress le post_ap treatment_alberta did_pre_ap density gas_gross_sale
estimate store r6
esttab r1 r2 r3 r4 r5 r6 using pla_alberta_did.tex, replace title("DiD placebo alberta, just before tax cut") label

**pre trend diff in diff : Placebo test for alberta 5 days after
use merged_database10, clear
keep city treatment state le5_31 le6_6 
gen treatment_alberta =0
replace treatment_alberta = 1 if state =="Alberta"

reshape long le, i(city) j(day) string
replace day=subinstr(day, "5_31", "1",.)
replace day=subinstr(day, "6_6", "2",.)
save "long_data_pre_dd_5a", replace
gen post_dd_5da = 0
replace post_dd_5da = 1 if day=="2" 

gen did_pre = post_dd_5da * treatment_alberta
regress le post_dd_5da treatment_alberta did_pre
estimates store t1
esttab t1 using 5d_alb_did.tex, replace title("DiD, 5 days after tax cut, Alberta") label

**pre trend diff in diff : Placebo test for alberta 1 month after
use merged_database11, clear
keep city treatment state le5_31 le6_30 
gen treatment_alberta =0
replace treatment_alberta = 1 if state =="Alberta"

reshape long le, i(city) j(day) string
replace day=subinstr(day, "5_31", "1",.)
replace day=subinstr(day, "6_30", "2",.)
save "long_data_pre_dd_1m", replace
gen post_dd_1m = 0
replace post_dd_1m = 1 if day=="2" 

gen did_pre = post_dd_1m * treatment_alberta
regress le post_dd_1m treatment_alberta did_pre
estimates store t1m
esttab t1m using 1m_alb_did.tex, replace title("DiD, 1 month after tax cut, Alberta") label

**pre trend diff in diff : Placebo test for alberta 1.5 month after
use merged_database11, clear
keep city treatment state le5_31 le7_15 
gen treatment_alberta =0
replace treatment_alberta = 1 if state =="Alberta"

reshape long le, i(city) j(day) string
replace day=subinstr(day, "5_31", "1",.)
replace day=subinstr(day, "7_15", "2",.)
save "long_data_pre_dd_1_5m", replace
gen post_dd_1_5m = 0
replace post_dd_1_5m = 1 if day=="2" 

gen did_pre = post_dd_1_5m * treatment_alberta
regress le post_dd_1_5m treatment_alberta did_pre
estimates store t1m_5
esttab t1m_5 using 1_5m_alb_did.tex, replace title("DiD, 1.5 months after tax cut, Alberta") label

**pre trend diff in diff : Placebo test for alberta 3 month after
use merged_database12, clear
keep city treatment state le5_31 le8_1 
gen treatment_alberta =0
replace treatment_alberta = 1 if state =="Alberta"

reshape long le, i(city) j(day) string
replace day=subinstr(day, "5_31", "1",.)
replace day=subinstr(day, "8_1", "2",.)
save "long_data_pre_dd_1_5m", replace
gen post_dd_1_3m = 0
replace post_dd_1_3m = 1 if day=="2" 

gen did_pre = post_dd_1_3m * treatment_alberta
regress le post_dd_1_3m treatment_alberta did_pre
estimates store t1m_3
esttab t1m_3 using 3m_alb_did.tex, replace title("DiD, 3 monthsafter tax cut, Alberta") label

**# Bookmark #4
**pre trend diff in diff : Placebo test for ontario 5 days after
use merged_database13, clear
keep city treatment state le7_1 le7_6 

reshape long le, i(city) j(day) string
replace day=subinstr(day, "7_1", "1",.)
replace day=subinstr(day, "7_6", "2",.)
save "long_data_o5d", replace
gen post_o5d = 0
replace post_o5d = 1 if day=="2" 

gen did_pre_o5d = post_o5d * treatment
regress le post_o5d treatment did_pre_o5d
estimates store t1o5d
esttab t1o5d  using 5d_ont_did.tex, replace title("DiD, 5 days after tax cut, Ontario") label

**pre trend diff in diff : Placebo test for ontario 1 month after
use merged_database14, clear
keep city treatment state le7_1 le8_1

reshape long le, i(city) j(day) string
replace day=subinstr(day, "7_1", "1",.)
replace day=subinstr(day, "8_1", "2",.)
save "long_data_pre_o5d1", replace
gen post_o5d1 = 0
replace post_o5d1 = 1 if day=="2" 

gen did_pre_o5d1 = post_o5d1 * treatment
regress le post_o5d1 treatment did_pre_o5d1
estimates store t1o5d1
esttab t1o5d1 using 1m_ont_did.tex, replace title("DiD, 1 month after tax cut, Ontario") label

**pre trend diff in diff : Placebo test for ontario 1.5 month after
use merged_database15, clear
keep city treatment state le7_1 le8_22

reshape long le, i(city) j(day) string
replace day=subinstr(day, "7_1", "1",.)
replace day=subinstr(day, "8_22", "2",.)
save "long_data_pre_o5d2", replace
gen post_o5d2 = 0
replace post_o5d2 = 1 if day=="2" 

gen did_pre_o5d2 = post_o5d2 * treatment
regress le post_o5d2 treatment did_pre_o5d2
estimates store t1o5d2
esttab t1o5d2 using 15m_ont_did.tex, replace title("DiD, 1.5 months after tax cut, Ontario") label

**diff in diff alberta
use "merged_database2.dta", clear
gen treatment_alberta =0
replace treatment_alberta = 1 if state =="Alberta"
keep city treatment_alberta le3_31 le4_15 population density gas_gross_sale

reshape long le, i(city) j(day) string
replace day=subinstr(day, "3_31", "1",.)
replace day=subinstr(day, "4_15", "2",.)
save "long_data_alberta", replace
gen post_alberta1 = 0
replace post_alberta1 = 1 if day=="2" 

gen did_alberta1 = post_alberta1 * treatment_alberta
regress le post_alberta1 treatment_alberta did_alberta1
estimates store a1
regress le post_alberta1 treatment_alberta did_alberta1 population
estimates store a2
regress le post_alberta1 treatment_alberta did_alberta1 density
estimate store a3
regress le post_alberta1 treatment_alberta did_alberta1 gas_gross_sale
estimate store a4
regress le post_alberta1 treatment_alberta did_alberta1 population gas_gross_sale
estimate store a5
regress le post_alberta1 treatment_alberta did_alberta1 density gas_gross_sale
estimate store a6
esttab a1 a2 a3 a4 a5 a6 using alb_did.tex, replace title("DiD Alberta April 1st") label

**pre trend diff in diff : Placebo test beginning of the year
use merged_database3, clear
gen treatment_two = 0
replace treatment_two = 1 if state =="Ontario"
replace treatment_two = 1 if state =="Alberta"
gen treatment_ontario = 0
replace treatment_ontario = 1 if state =="Ontario"
gen treatment_alberta = 0
replace treatment_alberta = 1 if state =="Alberta"
save "merged_database3.dta", replace
keep city treatment_two treatment_alberta treatment_ontario le1_14 le1_31

reshape long le, i(city) j(day) string
replace day=subinstr(day, "1_14", "1",.)
replace day=subinstr(day, "1_31", "2",.)
save "long_data_beg", replace
gen post_beg = 0
replace post_beg = 1 if day=="2" 

gen did_beg_year = post_beg * treatment_two
regress le post_beg treatment_two did_beg_year
estimate store c1

gen did_beg_alberta = post_beg * treatment_alberta
regress le post_beg treatment_alberta did_beg_alberta
estimate store c2

gen did_beg_ontario = post_beg * treatment_ontario
regress le post_beg treatment_ontario did_beg_ontario
estimate store c3

**diff-in-diff, october alberta, reimplementation of state taxes
use "merged_database4.dta", clear
gen treatment_alberta =0
replace treatment_alberta = 1 if state =="Alberta"
keep city treatment_alberta le9_30 le10_12 population density gas_gross_sale

reshape long le, i(city) j(day) string
replace day=subinstr(day, "9_30", "1",.)
replace day=subinstr(day, "10_12", "2",.)
save "long_data_alberta_october", replace
gen post_alberta_oct = 0
replace post_alberta_oct = 1 if day=="2" 

gen did_alberta_oct = post_alberta_oct * treatment_alberta
regress le post_alberta_oct treatment_alberta did_alberta_oct
estimate store d1
regress le post_alberta_oct treatment_alberta did_alberta_oct population
estimate store d2
regress le post_alberta_oct treatment_alberta did_alberta_oct density
estimate store d3
regress le post_alberta_oct treatment_alberta did_alberta_oct gas_gross_sale
estimate store d4
regress le post_alberta_oct treatment_alberta did_alberta_oct population gas_gross_sale
estimate store d5
regress le post_alberta_oct treatment_alberta did_alberta_oct density gas_gross_sale
estimate store d6
esttab d1 d2 d3 d4 d5 d6 using oct_alb_did.tex, replace title("DiD Alberta October 1st") label

**Sample restriction
	**for alberta
use merged_database5, clear
gen treatment_alberta =0
replace treatment_alberta = 1 if state =="Alberta"
keep city state treatment_alberta le3_31 le4_15 population density gas_gross_sale

reshape long le, i(city) j(day) string
replace day=subinstr(day, "3_31", "1",.)
replace day=subinstr(day, "4_15", "2",.)
save "long_data_alberta", replace
gen post_albertas = 0
replace post_albertas = 1 if day=="2" 
drop if state== "British Columbia"
drop if state== "Northwest Territories"
drop if state== "Saskatchewan"
drop if state== "Ontario"
gen did_albertas = post_albertas * treatment_alberta

regress le post_albertas treatment_alberta did_albertas
estimates store so1
regress le post_albertas treatment_alberta did_albertas population
estimates store so2
regress le post_albertas treatment_alberta did_albertas density
estimate store so3
regress le post_albertas treatment_alberta did_albertas gas_gross_sale
estimate store so4
regress le post_albertas treatment_alberta did_albertas population gas_gross_sale
estimate store so5
regress le post_albertas treatment_alberta did_albertas density gas_gross_sale
estimate store so6
esttab so1 so2 so3 so4 so5 so6 using sralb_did.tex, replace title("DiD April 1st, Alberta, sample restriction") label

	**for ontario
use merged_database6, clear
keep city state treatment le6_30 le7_15 population density aggreg_state_tax gas_gross_sale

reshape long le, i(city) j(day) string
replace day=subinstr(day, "6_30", "1",.)
replace day=subinstr(day, "7_15", "2",.)
save "long_data_spil_ontario", replace
gen posto = 0
replace posto = 1 if day=="2" 
drop if state== "Manitoba"
drop if state== "Quebec"
gen dido = posto * treatment

regress le posto treatment dido
estimates store se1
regress le posto treatment dido population
estimates store se2
regress le posto treatment dido density
estimates store se3
regress le posto treatment dido gas_gross_sale
estimates store se4
regress le posto treatment dido population gas_gross_sale
estimates store se5
regress le posto treatment dido density gas_gross_sale
estimates store se6
esttab se1 se2 se3 se4 se5 se6 using sront_did.tex, replace title("DiD July 1st, sample restriction, Ontario") label

	**placebo test- ontario - tax annoucment April 4th
use merged_database8, clear
keep city treatment state le4_1 le4_20 population density aggreg_state_tax gas_gross_sale

reshape long le, i(city) j(day) string
replace day=subinstr(day, "4_1", "1",.)
replace day=subinstr(day, "4_20", "2",.)
save "long_data_pre_al_an", replace
gen post = 0
replace post = 1 if day=="2" 

gen did_pre = post * treatment
regress le post treatment did_pre
estimates store ronp1
regress le post treatment did_pre population
estimates store ronp2
regress le post treatment did_pre density
estimate store ronp3
regress le post treatment did_pre gas_gross_sale
estimate store ronp4
regress le post treatment did_pre population gas_gross_sale
estimate store ronp5
regress le post treatment did_pre density gas_gross_sale
estimate store ronp6
esttab ronp1 ronp2 ronp3 ronp4 ronp5 ronp6
	**placebo test- ontario - election June 2th
use merged_database9, clear
keep city treatment state le6_1 le6_20 population density aggreg_state_tax gas_gross_sale

reshape long le, i(city) j(day) string
replace day=subinstr(day, "6_1", "1",.)
replace day=subinstr(day, "6_20", "2",.)
save "long_data_pre_al_el", replace
gen post = 0
replace post = 1 if day=="2" 

gen did_pre = post * treatment
regress le post treatment did_pre
estimates store ralp11
regress le post treatment did_pre population
estimates store ralp21
regress le post treatment did_pre density
estimate store ralp31
regress le post treatment did_pre gas_gross_sale
estimate store ralp41
regress le post treatment did_pre population gas_gross_sale
estimate store ralp51
regress le post treatment did_pre density gas_gross_sale
estimate store ralp61
esttab ralp11 ralp21 ralp31 ralp41 ralp51 ralp61

*plot parallel trend
python:

import sys
import subprocess
import re
subprocess.check_call([sys.executable, "-m", "pip", "install", "pandas"])
import pandas as pd

df = pd.read_stata("merged_database.dta")
def format_columns(col_name):
    if col_name.startswith('le'):
        parts = col_name.split('_')
        parts[0] = parts[0][0:2] + parts[0][2:].zfill(2)
        parts[1] = parts[1].zfill(2)
        return '_'.join(parts)
    else:
        return col_name
df.columns = [format_columns(col) for col in df.columns]
df.to_stata("merged_database.dta")
end 

use "merged_database.dta", clear

// Now try reshaping the data
python:
import re 
import pandas as pd

df = pd.read_stata('merged_database.dta')
id_vars = ['index', 'city', 'state', 'stateiso']
# Filter rows where the date matches the format "leMM_DD"
regex = re.compile("^le\d{2}_\d{2}$")
date_vars = [var for var in df.columns if regex.match(var)]
df = df[id_vars + date_vars]
# Melt the dataset, converting it from wide to long format
df_melted = df.melt(id_vars=id_vars, var_name='date', value_name='le')
# Extract month and day from the date variable
df_melted['month'] = df_melted['date'].str[2:4]
df_melted['day'] = df_melted['date'].str[5:7]
# Convert month and day to numeric format
df_melted['month'] = pd.to_numeric(df_melted['month'])
df_melted['day'] = pd.to_numeric(df_melted['day'])
# Create a proper date variable
df_melted['date_new'] = pd.to_datetime(df_melted[['month', 'day']].assign(year=2022))
# Remove the time part from the date
df_melted['date_new'] = df_melted['date_new'].dt.floor('D')
# Drop the original date variable and the month and day variables
df_melted = df_melted.drop(columns=['date', 'month', 'day'])
df_melted["date_new"] = pd.to_datetime(df_melted["date_new"]).dt.normalize()
df_melted["date_new"] = df_melted["date_new"].astype(str).str.split(" ").str[0]
df_melted.to_stata('reshaped_database.dta', write_index=False)

df_state = df_melted.groupby(['state', 'date_new'])['le'].mean().reset_index()
df_state.to_stata('state_level_database.dta', write_index=False)

#Now we create a dataset with the average of prices in different regions
df_melted = pd.read_stata('reshaped_database.dta')
def classify_state(state):
    if state == 'Alberta':
        return 'Alberta'
    elif state == 'Ontario':
        return 'Ontario'
    else:
        return 'Other_states'
df_melted['state_class'] = df_melted['state'].apply(classify_state)
df_state = df_melted.groupby(['state_class', 'date_new'])['le'].mean().reset_index()
df_state.to_stata('state_aggreg_database.dta', write_index=False)

end

use "state_level_database.dta", clear

gen date_only = date(date_new, "YMD")
format date_only %td

set scheme plotplain

twoway (line le date_only if state == "Alberta", sort lcolor(red) lpattern(dash)) ///
       (line le date_only if state == "Ontario", sort lcolor(green) lpattern(dash)) ///
       (line le date_only if state == "British Columbia", sort lcolor(blue) lpattern(solid)) ///
       (line le date_only if state == "Manitoba", sort lcolor(blue) lpattern(solid)) ///
       (line le date_only if state == "New Brunswick", sort lcolor(blue) lpattern(solid)) ///
       (line le date_only if state == "Newfoundland and Labrador", sort lcolor(blue) lpattern(solid)) ///
       , legend(order(1 "Alberta" 2 "Ontario" 3 "British Columbia" 4 "Manitoba" 5 "New Brunswick" 6 "Newfoundland and Labrador")) ///
       xtitle("Date") ytitle("Value") title("Parallel trend (Figure 1)") 
	   
set scheme plotplain

twoway (line le date_only if state == "Alberta", sort lcolor(red) lpattern(dash)) ///
       (line le date_only if state == "Ontario", sort lcolor(green) lpattern(dash)) ///
       (line le date_only if state == "Nova Scotia", sort lcolor(blue) lpattern(solid)) ///
       (line le date_only if state == "Quebec", sort lcolor(blue) lpattern(solid)) ///
       (line le date_only if state == "Saskatchewan", sort lcolor(blue) lpattern(solid)) ///
       (line le date_only if state == "Yukon", sort lcolor(blue) lpattern(solid)) ///
       (line le date_only if state == "Northwest Territories", sort lcolor(blue) lpattern(solid)) ///
       , legend(order(1 "Alberta" 2 "Ontario" 3 "Nova Scotia" 4 "Quebec" 5 "Saskatchewan" 6 "Yukon" 7 "Northwest Territories")) ///
       xtitle("Date") ytitle("Value") title("My Fancy Graph") subtitle("Created with Stata") 

use "state_aggreg_database.dta",clear

gen date_only = date(date_new, "YMD")
format date_only %td

use "state_aggreg_database.dta", clear

gen date_only = date(date_new, "YMD")
format date_only %td

/* Define the date for the vertical line */
local vline_date = mdy(7,1,2022)

twoway (line le date_only if state_class=="Alberta", lcolor(blue) lpattern(solid)) ///
       (line le date_only if state_class=="Ontario", lcolor(red) lpattern(solid)) ///
       (line le date_only if state_class=="Other_states", lcolor(green) lpattern(solid)) ///
       , xtitle("Date") ytitle("Average Price") ///
         legend(order(1 "Alberta" 2 "Ontario" 3 "Other States")) ///
         title("Average Price by State") ///
         xline(`vline_date', lcolor(red) lpattern(dash)) /* Add vertical line */

		 
use "state_aggreg_database.dta", clear

gen date_only = date(date_new, "YMD")
format date_only %td

/* Define the dates for the vertical lines */
local vline_date1 = mdy(4,1,2022)
local vline_date2 = mdy(7,1,2022)

twoway (line le date_only if state_class=="Alberta", lcolor(blue) lpattern(solid)) ///
       (line le date_only if state_class=="Ontario", lcolor(red) lpattern(solid)) ///
       (line le date_only if state_class=="Other_states", lcolor(green) lpattern(solid)) ///
       , xtitle("Date") ytitle("Average Price") ///
         legend(order(1 "Alberta" 2 "Ontario" 3 "Other States")) ///
         title("Average Price by State") ///
         xline(`vline_date1' `vline_date2', lcolor(blue) lpattern(dash)) /* Add vertical lines */

**diff in diff graph alberta - 1st April
local vline_date1 = mdy(4,1,2022)
		 
twoway (line le date_only if state == "Alberta", sort lcolor(red) lpattern(dash)) ///
       (line le date_only if state == ("Ontario", "Nova Scotia","Quebec", "Saskatchewan","Yukon","Northwest Territories","Ontario","Manitoba","New Brunswick","Newfoundland and labrador","Nunavut"), sort lcolor(green) lpattern(dash)) ///
       , legend(order(1 "Treated/ Alberta" 2 "Control")) ///
       xtitle("Date") ytitle("Value") title("Tax cut, Alberta") subtitle("April 1 ") ///
	            xline(`vline_date1' `vline_date2', lcolor(blue) lpattern(dash)) /* Add vertical lines */

**diff-in-diff graph- alberta - 1st october
local vline_date1 = mdy(10,1,2022)
		 
twoway (line le date_only if state == "Alberta", sort lcolor(red) lpattern(dash)) ///
       (line le date_only if state == ("Ontario", "Nova Scotia","Quebec", "Saskatchewan","Yukon","Northwest Territories","Ontario","Manitoba","New Brunswick","Newfoundland and labrador","Nunavut"), sort lcolor(green) lpattern(dash)) ///
       , legend(order(1 "Treated/ Alberta" 2 "Control")) ///
       xtitle("Date") ytitle("Value") title("Tax cut, Alberta") subtitle("April 1 ") ///
	            xline(`vline_date1' `vline_date2', lcolor(blue) lpattern(dash)) /* Add vertical lines */
				
**diff-in-diff graph- ontario - 1st June
local vline_date1 = mdy(7,1,2022)
		 
twoway (line le date_only if state == "Ontario", sort lcolor(red) lpattern(dash)) ///
       (line le date_only if state == ("Alberta", "Nova Scotia","Quebec", "Saskatchewan","Yukon","Northwest Territories","Ontario","Manitoba","New Brunswick","Newfoundland and labrador","Nunavut"), sort lcolor(green) lpattern(dash)) ///
       , legend(order(1 "Treated/ Ontario" 2 "Control")) ///
       xtitle("Date") ytitle("Value") title("Tax cut, Alberta") subtitle("April 1 ") ///
	            xline(`vline_date1' `vline_date2', lcolor(blue) lpattern(dash)) /* Add vertical lines */
				