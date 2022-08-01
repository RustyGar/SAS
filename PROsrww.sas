OPTIONS LINESIZE=80 PAGESIZE=60 NODATE;
DATA DATAWW2021;
LENGTH ENAME $ 30; 
INFILE 'C:\Users\Russ\Documents\Extension\MasterDataSRWW_mod2.prn' FIRSTOBS=2;
INPUT YEAR REGION $ LOC $ PLOT REP ENT ENAME $ WGT MOIST TEST YIELD PROT SORTN;
/*DROP SORTN;*/
IF ENAME="TAM304M" THEN ENAME="TAM304"; 
IF ENAME="TAM304_750K" THEN ENAME="TAM304";
IF ENAME="WB4303_750K" THEN ENAME="WB4303";  
PROC SORT; BY YEAR REGION LOC REP ENAME;
RUN;
/*PROC PRINT DATA=DATAWW2021;
RUN;*/


***************************;
***************************;
** COMBINED ANALYSES WITHIN A LOCATION ACROSS YEARS - BLACKLANDS - PROSPER (PRO) - **; 
DATA COMBPRO21;
SET DATAWW2021;
IF YEAR<2017 THEN DELETE;
IF (REGION="BL") AND (LOC="PRO") THEN OUTPUT COMBPRO21;
PROC SORT; BY YEAR ENAME;
/*PROC PRINT DATA=COMBPRO21;
RUN;*/

*PRO2YR;
DATA PRO212YR;
SET COMBPRO21;
WHERE YEAR IN(2022,2021);
RUN;
/*PROC PRINT DATA=PRO212YR;
RUN;*/
PROC FREQ DATA=PRO212YR NOPRINT;
TABLES ENAME*YEAR / NOROW NOCOL NOPERCENT OUT=PRO2YR;
RUN;
PROC FREQ DATA=PRO2YR NOPRINT;
TABLE ENAME/OUT=PRO2YRA(WHERE=(COUNT>1));
RUN;
/*PROC PRINT;
RUN;*/
PROC SORT DATA=PRO212YR; BY ENAME;
RUN;
DATA PRO212YRB; PERIOD=2;
MERGE PRO212YR PRO2YRA(IN=KEEP); BY ENAME;
IF KEEP; DROP COUNT PERCENT;
RUN;
/*PROC PRINT DATA=PRO212YRB;
RUN;*/

***************;
*PRO3YR;
DATA PRO213YR;
SET COMBPRO21;
WHERE YEAR IN(2022,2021,2019);
RUN;
/*PROC PRINT DATA=PRO213YR;
RUN;*/
PROC FREQ DATA=PRO213YR NOPRINT;
TABLES ENAME*YEAR / NOROW NOCOL NOPERCENT OUT=PRO3YR;
RUN;
PROC FREQ DATA=PRO3YR NOPRINT;
TABLE ENAME/OUT=PRO3YRA(WHERE=(COUNT=3));
RUN;
/*PROC PRINT;
RUN;*/
PROC SORT DATA=PRO213YR; BY ENAME;
RUN;
DATA PRO213YRB; PERIOD=3;
MERGE PRO213YR PRO3YRA(IN=KEEP); BY ENAME;
IF KEEP; DROP COUNT PERCENT;
RUN;
/*PROC PRINT DATA=PRO213YRB;
RUN;*/

***************;
*PRO4YR;
DATA PRO214YR;
SET COMBPRO21;
WHERE YEAR IN(2022,2021,2019,2018);
RUN;
/*PROC PRINT DATA=PRO214YR;
RUN;*/
PROC FREQ DATA=PRO214YR NOPRINT;
TABLES ENAME*YEAR / NOROW NOCOL NOPERCENT OUT=PRO4YR;
RUN;
PROC FREQ DATA=PRO4YR NOPRINT;
TABLE ENAME/OUT=PRO4YRA(WHERE=(COUNT=4));
RUN;
/*PROC PRINT;
RUN;*/
PROC SORT DATA=PRO214YR; BY ENAME;
RUN;
DATA PRO214YRB; PERIOD=4;
MERGE PRO214YR PRO4YRA(IN=KEEP); BY ENAME;
IF KEEP; DROP COUNT PERCENT;
RUN;
/*PROC PRINT DATA=PRO214YRB;
RUN;*/

DATA COMBPRO21;
MERGE PRO212YRB PRO213YRB PRO214YRB; BY PERIOD;
RUN;
/*PROC PRINT DATA=COMBPRO21;
RUN;*/

DATA COMBPRO21A;
SET COMBPRO21;
PROC SORT; BY PERIOD YEAR REP ENAME; 
PROC GLM DATA=COMBPRO21A; BY PERIOD;
CLASS YEAR REP ENAME;
MODEL YIELD=YEAR REP(YEAR) ENAME YEAR*ENAME/SS3;
MEANS ENAME/LSD LINES;
LSMEANS ENAME/OUT=PRO21YEARS;
PROC PRINT DATA=PRO21YEARS;
RUN;
