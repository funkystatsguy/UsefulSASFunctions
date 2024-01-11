*Example of how My_Beautiful_MCC_Macro works;
%include "C:\Users\afunk\Desktop\Dissertation\githubtest\githubtest\MCC Inspired Count Macro\My_Beautiful_MCC_Macro.sas";

proc import out = conds
	datafile = "C:\Users\afunk\Desktop\Dissertation\githubtest\githubtest\MCC Inspired Count Macro\Datasets\mock_MCC_conditions.csv"
	dbms = csv replace;
run;

*Import a dataset containing a list of chronic conditions people may have;
proc import out = pats
	datafile = "C:\Users\afunk\Desktop\Dissertation\githubtest\githubtest\MCC Inspired Count Macro\Datasets\mock_MCC_patients.csv"
	dbms = csv replace;
run;

%mcc_macro1(df1 = pats, df2 = conds);

*Rename Dataset;
data newdataname;
set Binary_Outcomes;
run;
*NOTE: If you do not set each dataset to a new name, it WILL overwrite the old dataset;
