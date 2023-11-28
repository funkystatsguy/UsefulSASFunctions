*Example of how My_Beautiful_MCC_Macro works;
%include "F:\Shares\IM Family Medicine\PBR_Net\Quantitative Team\Useful Functions\MCC Inspired Count Macro\My_Beautiful_MCC_Macro.sas";

proc import out = conds
	datafile = "F:\Shares\IM Family Medicine\PBR_Net\Quantitative Team\Useful Functions\MCC Inspired Count Macro\Datasets\mock_MCC_conditions.csv"
	dbms = csv replace;
run;

*Import a dataset containing a list of chronic conditions people may have;
proc import out = pats
	datafile = "F:\Shares\IM Family Medicine\PBR_Net\Quantitative Team\Useful Functions\MCC Inspired Count Macro\Datasets\mock_MCC_patients.csv"
	dbms = csv replace;
run;

%mcc_macro1(df1 = pats, df2 = conds);
