/******************** Irene Hsueh's BS 851 Homework 3 ********************/
libname homework "C:/Irene Hsueh's Documents/MS Applied Biostatistics/BS 851 - Applied Statistics in Clinical Trials I/Class 3 - Continuous and Binary Endpoints/Homework 3";
data depression;
	set homework.depression;
	where visit=8;
	if cmiss(of _all_) then delete;
run;

title "Depression Dataset";
proc print data=depression;
run;
title;



title "Creating Binary Outcome";
data depression;
set depression;
	if y<=7 then not_depressed=1;
	else not_depressed=0;
run;
title;

title "Depression Dataset";
proc print data=depression;
run;
title;



title "Descriptive Statistics of Continuous Outcome";
proc univariate data=depression;
	class trt;
	var change;
run;
title;




ODS HTML close;
ODS HTML;




title "T-Test for Continuous Outcome";
proc ttest data=depression;
	class trt;
	var change;
run;
title;

title "Chi-Square Test for Binary Outcome";
proc freq data=depression;
	table trt*not_depressed / nocol nopercent chisq 			/*Chi Square Test*/
	riskdiff (column=2 CL=wald CL=newcombe(correct) norisks)	/*Risk Difference, 95% CI*/
	relrisk (column=2 CL=wald)									/*Risk Ratio, 95% CI*/
	oddsratio (CL=wald)											/*1/(Odds Ratio), 95% CI*/
;
run;



title "Linear Regression for Continuous Outcome";
data depression;
set depression;
	if trt=1 then x=1;
	else x=0;
run;

proc reg data=depression;
	model change=x;
run;
quit;

proc glm data=depression;
	class trt;
	model change=trt / solution clparm;
	means trt / hovtest=levene welch;
run;
quit;
title;



title "Linear Regression for Continuous Outcome with New Dummy Variable Coding";
data depression;
set depression;
	if trt=1 then x=1;
	else x=-1;
run;

proc reg data=depression;
	model change=x;
run;
quit;
title;




ODS HTML close;
ODS HTML;




title "Depression Binary Outcome";
proc format;
	value depression_format 0="No Depression" 1="Depression";
	value $trt_format "P"="Placebo" "A"="Treatment";
run;

data cards_depression;
	input trt $ depression count;
	label trt="Treatment" depression="Depression";
	format trt $trt_format. depression depression_format.;
cards; 
P	0	25
P	1	27
A   0	35
A   1	20
;
run;

proc print data=cards_depression label;
run;
title;


title "Binary Outcome Analysis";
proc freq data=cards_depression;
	weight count;
	table trt*depression / nocol nopercent chisq 	/*Chi Square Test*/
	riskdiff (column=2 CL=wald norisks)				/*Risk Difference, 95% CI*/
	relrisk (column=2 CL=wald)						/*Risk Ratio, 95% CI*/
	oddsratio (CL=wald)								/*1/(Odds Ratio), 95% CI*/
;
run;
title;



