proc import file="C:\Users\Russ\Documents\PhD\2022\22_CS_UVT.csv"
    out=CS
    dbms=csv;
run;

/*proc print data=CS;
run; */

proc corr data=CS plots=scatter(nvar=all);
	var Yield_14_ CC220419;
run;
