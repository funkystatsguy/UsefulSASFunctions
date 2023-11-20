libname MyMacros "SAS-library";
options mstored sasmstore = My_SAS_MACROS;

*Import a dataset containing a list of possible chronic conditions;
proc import out = conds
	datafile = "F:\Shares\IM Family Medicine\PBR_Net\Quantitative Team\Useful Functions\MCC Inspired Count Macro\Datasets\mock_MCC_conditions.csv"
	dbms = csv replace;
run;

*Import a dataset containing a list of chronic conditions people may have;
proc import out = pats
	datafile = "F:\Shares\IM Family Medicine\PBR_Net\Quantitative Team\Useful Functions\MCC Inspired Count Macro\Datasets\mock_MCC_patients.csv"
	dbms = csv replace;
run;


%macro mcc_macro1 (df1, df2) / store source;
	des = "MCC_MACRO1";
*Create empty datasets for later use;
data Total_Outcomes;
run;

data Binary_Outcomes;
run;

*Excution of df1 stuffs;
proc contents data = &df1 out = &df1._names(keep = NAME);
run;

proc sql noprint;
	select count (*)
		into :df1NObs
	from &df1._names;

	select Name
		into :df1Name1 - :df1Name%left(&df1NObs)
	from &df1._names;
quit;


*Execution of df2 stuffs;
proc contents data = &df2 out = &df2._names(keep = NAME);
run;

proc sql noprint;
	select count (*)
		into :df2NObs
	from &df2._names;

	select Name
		into :df2Name1 - :df2Name%left(&df2NObs)
	from &df2._names;
quit;

%do i = 1 %to &df2NObs;
data cell&i;
	set &df2._names(obs = &i firstobs = &i keep = NAME);
run;

data _null_;
	set cell&i;
	call symput("df2val&i", NAME);
run;

proc sql;
create table data&i as
select &&df2val&i from &df2;
quit;

%let df2name = &&df2val&i;

data data&i;
set data&i;
if &df2name = "" then &df2name = "NA";
run;


%let list&i = ;
	data _null_;
	set data&i;
	call execute(catx(" ", '%let list&i = &&list&i', quote(trim(&&df2val&i)), ";"));
run;

*Bring both togethere;

	data &df2name.dat;
	&df2name.val = 0;
	%do j=1 %to &df1NObs;
		set &df1;
		if upcase(&&df1Name&j) in (&&list&i) then df1val&j = 1;
		else df1val&j = 0;
		&df2name.val = sum(&df2name.val, df1val&j);
	%end;
	run;

	data &df2name.totval;
	set &df2name.dat;
	keep &df2name.val;
	run;

	data &df2name.bindata;
	set &df2name.dat;
	if &df2name.val >0 then &df2name.bin = 1;
	else &df2name.bin = 0;
	keep &df2name.bin;
	run;

	data Total_Outcomes;
	merge Total_Outcomes &df2name.totval;
	run;

	data Binary_Outcomes;
	merge Binary_Outcomes &df2name.bindata;
	run;

%end;

data Binary_Outcomes;
set Binary_Outcomes;
total = sum(of _numeric_);
run;

%mend mcc_macro1;

%mcc_macro1(df1 = pats, df2 = conds);
