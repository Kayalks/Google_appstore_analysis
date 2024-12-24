use "C:\Users\kk01426\OneDrive - University of Surrey\Documents\stats\googleapps.dta"

// General Data Analysis:
describe
summarize
codebook revenue, price, rating, num_langs, size
codebook main_category, monetization_strategies, age_target, devices

// generate log variables for varaibles with skew or large sd
gen log_revenue = log(revenue)
gen log_price = log(price)
gen log_size = log(size)

label variable log_revenue  "Ln(Revenue)"
label variable log_price  "Ln(Price)"
label variable log_size  "Ln(Size)"
label variable num_langs "#Languages"
label variable rating "Rating"
label variable monetization_strategies "Monetization Strategy"
label variable age_target "Age Target"


tab main_category
// generate a new variable games with value as 1 where main_category = "Games" and 0 where main_category != "Games" (note: excluding the missing values)
gen games= 1 if main_category == "Games"
replace games = 0 if main_category != "Games" & !missing(main_category)

tabstat log_revenue log_price log_size rating num_langs, by( games ) statistics(count mean min max sd median skewness) columns(statistics)

//Descriptive analysis
// Q1: Provide a two-way table that depicts the summary statistics of the variables for subsamples of game and non-game apps, as well as the full sample in one table
eststo clear
estpost tabstat log_revenue log_price log_size rating num_langs, by( games ) statistics(count mean min max sd median skewness) columns(statistics)
esttab using summary_stats.rtf, cells("count mean(fmt(a3)) min(fmt(a3)) max(fmt(a3)) sd(fmt(a3)) p50(fmt(a3)) skewness(fmt(a3))") noobs replace label


// Q2: Apply an appropriate test to evaluate if there is any statistically significant difference (at 0.05 significance level) across categories regarding the app revenue (logged).
oneway log_revenue main_category
graph box log_revenue, over(main_category, label(angle(forty_five)))
graph export "~\stats\box_category_revenue.jpg", as(jpg) name("Graph") quality(100) replace
// Q3: Apply an appropriate test to evaluate if there is any statistically significant difference (at 0.05 significance level) between games and non-game apps regarding the app revenue (logged).
ttest log_revenue, by(games)

// Q4:  Provide the correlation matrix of the main variables. 
eststo clear
estpost corr log_revenue log_price log_size rating num_langs, matrix listwise
eststo c1
esttab c1 using correlation.rtf, replace b(3) label unstack not

// Exploratory Analysis:
// Q1: 
// skweness
 histogram log_revenue, normal xtitle(Ln(Revenue))
 graph export "~\stats\hist_revenue.jpg", as(jpg) name("Graph") quality(100) replace
 histogram log_price, normal xtitle(Ln(Price))
 graph export "~\stats\hist_price.jpg", as(jpg) name("Graph") quality(100) replace
 histogram rating, normal xtitle(Rating)
 graph export "~\stats\hist_rating.jpg", as(jpg) name("Graph") quality(100) replace
 histogram num_langs, normal xtitle(#Languages)
 graph export "~\stats\hist_languages.jpg", as(jpg) name("Graph") quality(100) replace
 
 // outliers
 graph box log_price
 graph export "~\stats\box_price.jpg", as(jpg) name("Graph") quality(100) replace
 graph box log_revenue
 graph export "~\stats\box_revenue.jpg", as(jpg) name("Graph") quality(100) replace
 graph box rating
 graph box num_langs
 graph box log_revenue , over( age_target )
 graph box log_price , over( monetization_strategies )
 
 // relationship
twoway (scatter log_revenue log_price, sort), ytitle(Ln(Revenue)) xtitle(Ln( Price))
graph export "~\stats\price_revenue.jpg", as(jpg) name("Graph") quality(100) replace
twoway (scatter log_revenue rating , sort), ytitle(Ln(Revenue)) xtitle(Rating)
graph export "~\stats\rating_revenue.jpg", as(jpg) name("Graph") quality(100) replace
twoway (scatter log_price rating, sort), ytitle(Ln(Price)) xtitle(Rating)
twoway (scatter log_revenue num_langs , sort) , ytitle(Ln(Revenue)) xtitle(#Languages)
twoway (scatter rating num_langs , sort), ytitle(Rating) xtitle(#Languages)
twoway (scatter log_price num_langs , sort), ytitle(Ln(Price)) xtitle(#Languages)

graph bar (count), over(monetization_strategies) blabel(bar)
graph export "~\stats\monetization_bar.jpg", as(jpg) name("Graph") quality(100) replace
graph hbar (count), over(main_category) blabel(bar)
graph export "~\stats\main_category_bar.jpg", as(jpg) name("Graph") quality(100) replace
graph bar (count), over(age_target) blabel(bar)
graph export "~\stats\age_target_bar.jpg", as(jpg) name("Graph") quality(100) replace
graph bar (mean) rating, over(monetization_strategies) blabel(bar)
graph bar (mean) log_revenue, over(monetization_strategies) blabel(bar)
graph export "~\stats\revenue_monetize_bar.jpg", as(jpg) name("Graph") quality(100) replace
graph bar (mean) log_revenue, over(age_target) blabel(bar)
graph export "~\stats\revenue_age_target_bar.jpg", as(jpg) name("Graph") quality(100) replace



//Main Regression Analysis:
// Q1: Conduct an OLS regression to estimate the effect of app rating, app price (logged), monetization strategies, and age target on the app revenue (logged) while controlling the number of available languages and app main category
encode monetization_strategies, generate(monetize_dum)
encode age_target, generate(age_dum)
encode main_category, generate(main_cat_dum)
label variable monetize_dum "Monetization Strategy"
label variable age_dum "Age Target"
label variable main_cat_dum "Main Category"

//baseline model
reg log_revenue rating log_price i.monetize_dum i.age_dum num_langs i.main_cat_dum

// Q1.a: which monetization strategy is the best for revenue generation
margins monetize_dum
marginsplot
graph export "~\stats\monetizationeffect.jpg", as(jpg) name("Graph") quality(100) replace

// Q1.b: Looking at the regression results, discuss whether it is better to target all ages (a broader segment) or better to focus on specific age levels
margins age_dum
marginsplot
graph export "~\stats\age_targeteffect.jpg", as(jpg) name("Graph") quality(100) replace

// Q2: Modify the baseline model to evaluate the differential effect of app rating on app revenue (logged) for different monetization strategies
reg log_revenue log_price i.monetize_dum##c.rating i.age_dum num_langs i.main_cat_dum

// which monetization strategy is the best for high-quality apps. Which one is the worst?
margins monetize_dum, at(rating=(1(0.1)5))
marginsplot
graph export "~\stats\differncialeffect.jpg", as(jpg) name("Graph") quality(100) replace

//export of OLS regression models (1&2)
set more off
eststo clear
reg log_revenue rating log_price i.monetize_dum i.age_dum num_langs i.main_cat_dum
eststo model1
reg log_revenue log_price c.rating##i.monetize_dum i.age_dum num_langs i.main_cat_dum
eststo model2
esttab model1 model2 using ols_regression.rtf, replace ar2(3) b(3) se(3) r2(3) label compress title(Table 3: OLS Regression analysis for Revenue, main analysis) mtitles("Baseline Model" "Rating vs Monetization") 

// Diagnostics and Robustness Analysis:
// Q1: Apply diagnostic analyses on the baseline model to check the potential heteroskedasticity
reg log_revenue rating log_price i.monetize_dum i.age_dum num_langs i.main_cat_dum

rvfplot, yline(0) title(non-robust errors)
graph export "~\stats\nonrobust_errors.jpg", as(jpg) name("Graph") quality(100) replace
hettest
imtest,white

// apply an appropriate remedy if needed.:
reg log_revenue rating log_price i.monetize_dum i.age_dum num_langs i.main_cat_dum, vce(robust)
rvfplot, yline(0) title(Robust Errors)
graph export "~\stats\robust_errors.jpg", as(jpg) name("Graph") quality(100) replace

// Q2: Investigate the possibility of a quadratic effect of the app price (logged) on the app revenue(logged)
twoway (scatter log_revenue log_price) (lfit log_revenue log_price)(lowess log_revenue log_price)

//  for revenue generation, is it better to set a low price (to increase app installs), a high price (to boost revenue per install), or somewhere in the middle?
reg log_revenue rating c.log_price##c.log_price i.monetize_dum i.age_dum num_langs i.main_cat_dum , vce(robust)
twoway (scatter log_revenue log_price) (lfit log_revenue log_price)(qfit log_revenue log_price) 

graph export "~\stats\quadraticeffect.jpg", as(jpg) name("Graph") quality(100) replace


// export of models 3&4
eststo clear
reg log_revenue rating log_price i.monetize_dum i.age_dum num_langs i.main_cat_dum, vce(robust)
eststo model3
reg log_revenue rating c.log_price##c.log_price i.monetize_dum i.age_dum num_langs i.main_cat_dum , vce(robust)
eststo model4
esttab model3 model4 using robustness_models.rtf, replace ar2(3) b(3) se(3) r2(3) label compress title(Table 4: OLS Regression for Revenue, Diagnostic and Robustness Analysis) mtitles("Robust standard errors" "Quadratic model") 



