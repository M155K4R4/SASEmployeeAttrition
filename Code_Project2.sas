DM LOG 'CLEAR' LOG;

libname Project2 '/folders/myfolders/Survival/Projects/project2';

/* FILE IMPORTING */
PROC IMPORT OUT=FermaLogis FILE='/folders/myfolders/Survival/Projects/project2/FermaLogis_Event_Type.csv' DBMS=CSV 
		REPLACE;
RUN;

 /*-------------------------------------------------------------------------------*/
 /*                 STEP 1: PREPROCESSING				  */
 /*-------------------------------------------------------------------------------*/

*Importing the file;
data Project2.FermaLogis;
set FermaLogis;
	*change turnover from character type to numeric type;
	if turnover="Yes" then turnover_b = 1;
	if turnover= "No" then turnover_b = 0;
	*map the turnover type;
	if type = 0 then turnoverType = "No Turnover";
	if type = 1 then turnoverType = "Retirement";
	if type = 2 then turnoverType = "Voluntary";
	if type = 3 then turnoverType = "Involuntary";
	if type = 4 then turnoverType = "Fired";

	IF turnover = "Yes" and type = 0 then delete;
run;


proc format;
	value type 0 = "No Turnover"
			   1 = "Retirement"
			   2 = "Voluntary"
			   3 = "Involuntary"
			   4 = "Fired";
run;

*Checking the frequency of occurrence of each type of events;

proc datasets library=project2 memtype=data;
	contents data=FermaLogis;
run;

*checking the the frequency of occurence of each type of events;
proc freq data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	tables Type /chisq;
	format Type type.;
run;

*Data Preprocessing*;

DATA Project2.FermaLogis (DROP= Over18 EmployeeCount EmployeeNumber);
SET Project2.FermaLogis;

	IF StockOptionLevel>0 then stock='Yes';
	ELSE stock='No';

	IF Education=3 or Education=4 or Education=5 then HigherEducation='Yes';
	ELSE HigherEducation='No';

	IF JobSatisfaction>=3 then Satisfied='Yes';
	ELSE Satisfied='No';

	IF JobInvolvement>=3 then Involved='Yes';
	ELSE Involved='No';
	
	IF UPCASE(overtime)="NO" THEN Overtime_Flag=0;
	ELSE Overtime_Flag=1;

	IF UPCASE(Gender) = 'MALE' THEN Gender_FLAG = 0;
	ELSE Gender_FLAG = 1;

	IF UPCASE(BusinessTravel)="TRAVEL_FREQUENTLY" then BusinessTravel_FLAG=2;
	ELSE IF UPCASE(BusinessTravel)="TRAVEL_RARELY" then BusinessTravel_FLAG=1;
	ELSE IF UPCASE(BusinessTravel)="NON-TRAVEL" then BusinessTravel_FLAG=0;

	IF UPCASE(MaritalStatus)='MARRIED' then MaritalStatus_FLAG=0;
	ELSE IF UPCASE(MaritalStatus)='DIVORCED' then MaritalStatus_FLAG=1;
	ELSE IF UPCASE(MaritalStatus)='SINGLE' then MaritalStatus_FLAG=2;

	IF UPCASE(Department) = 'SALES' Then Department_FLAG = 0;
	Else IF UPCASE(Department) = 'RESEARCH & DEVELOPMENT' Then Department_FLAG = 1;
	Else IF UPCASE(Department) = 'HUMAN RESOURCES' Then Department_FLAG = 2;
run;

*reordering the data to get censored to the begining*;
data Project2.FermaLogis;
	retain turnoverType;
	retain YearsAtCompany;
	set Project2.FermaLogis;
run;


*calculating the cumulative bonus effect;
DATA Project2.bonusFerma (drop=i);
	SET Project2.fermalogis;
	ARRAY bonus_(*) bonus_1-bonus_40;
	ARRAY cum(*) cum1-cum40;
	cum1=bonus_1;
	DO i=2 TO 40;
		cum(i)=cum(i-1)+bonus_(i);
	END;
run;

 /*-------------------------------------------------------------------------------*/
 /*                 STEP 2: EXPLORATORY ANALYSIS ACROSS EVENT TYPES				  */
 /*-------------------------------------------------------------------------------*/

/**************************************************/
/**** PROC SGPLOT for the following attributes ****/
/*  Age DistanceFromHome BusinessTravel */
/* EnvironmentSatisfaction JobLevel MonthlyIncome */
/* NumCompaniesWorked OverTime TotalWorkingYears  */
/* RelationshipSatisfaction TrainingTimesLastYear */
/* YearsInCurrentRole YearsSinceLastPromotion 	  */
/* YearsWithCurrManager Stock HigherEducation     */
/* Satisfied Involved                             */
/**************************************************/

/* Proc sgplot data=Project2.FermaLogis; */
/* 	where turnoverType ne 'No Turnover'; */
/* 	vbox BonusRatio /category= TurnoverType; */
/* 	Title 'Bonus Ratio Analysis'; */
/* run; */

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox Age /category= TurnoverType;
	Title 'Age Analysis';
run;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox DistanceFromHome /category= TurnoverType;
	Title 'Distance From Home Analysis';
run;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox MonthlyIncome  /category= TurnoverType;
	Title 'MonthlyIncome Analysis';
run;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox NumCompaniesWorked /category= TurnoverType;
	Title 'NumCompaniesWorked  Analysis';
run;


Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox YearsInCurrentRole /category= TurnoverType;
	Title 'YearsInCurrentRole  Analysis';
run;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox YearsSinceLastPromotion  /category= TurnoverType;
	Title 'YearsSinceLastPromotion  Analysis';
run;


Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox YearsWithCurrManager /category= TurnoverType;
	Title 'YearsWithCurrManager Analysis';
run;

*plotting the Business Travel* ;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=BusinessTravel;
	Title 'Business Travel Analysis';
run;

*plotting to identify Job satisfaction effect on event types* ;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=Satisfied;
	Title 'Job satisfaction Analysis';
run;

*plotting to identify Overtime effect on event type*;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=Overtime;
	Title 'Overtime Effect on Turnover types';
run;

*plotting to identify Education effect on event typ ;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=EducationField;
	Title 'Education Vs Turnover types';
run;

*plotting to identify Gender effect on event typ ;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=Gender;
	Title 'Gender  Vs Turnover types';
run;

*plotting frequency plot to check gender frequency on event type ;

PROC FREQ DATA=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	TABLES Gender*TurnoverType/ CHISQ plots=freqplot;
	TITLE ' Frequnecy Plot: Gender vs Turnover types';
RUN;

PROC FREQ DATA=Project2.FermaLogis;
	TABLES TurnoverType;
RUN;

*Hazard and Survival Curves rate by stratifying with Stock levels of an employee in fermalogis;
*Retiring employees;

proc lifetest data=project2.fermalogis plots=(S H) method=LIFE;
	TIME YearsAtCompany*Type(0, 2, 3, 4);
	strata stock;
	title "Survival curves of Retirement type with respect to stock";
run;

*Hazard and Survival Curves rate by stratifying with Stock;
*Voluntary Resignation;

proc lifetest data=project2.fermalogis plots=(S H) method=LIFE;
	TIME YearsAtCompany*Type(0, 1, 3, 4);
	strata stock;
	title "Survival curves of Voluntary Resignation type with respect to stock";
run;

*Hazard and Survival Curves rate by stratifying with Stock;
*Involuntary Resignation;

proc lifetest data=project2.fermalogis plots=(S H) method=LIFE;
	TIME YearsAtCompany*Type(0, 1, 2, 4);
	strata stock;
	title "Survival curves of Involuntary Resignation type with respect to stock";
run;

*Hazard and Survival Curves rate by stratifying with Stock;
*Job Termination;

proc lifetest data=project2.fermalogis plots=(S H) method=LIFE;
	TIME YearsAtCompany*Type(0, 1, 2, 3);
	strata stock;
	title "Survival curves of Job Termination type with respect to stock";
run;




 /*-------------------------------------------------------------------------------*/
 /*                 STEP 3: identify variables that significantly affect the hazard rate */
 /*-------------------------------------------------------------------------------*/

*Checking for significant variables with PHREG statement;
PROC phreg DATA=Project2.bonusFerma;
	where YearsAtCompany>1;
	class BusinessTravel Department Education EducationField
		Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0)= BusinessTravel Department	Education EducationField
	Gender JobRole MaritalStatus OverTime StockOptionLevel 
	WorkLifeBalance	Age	DailyRate DistanceFromHome 
	EnvironmentSatisfaction	JobInvolvement JobLevel	JobSatisfaction 
	MonthlyIncome NumCompaniesWorked PercentSalaryHike PerformanceRating	
	RelationshipSatisfaction TotalWorkingYears TrainingTimesLastYear YearsInCurrentRole	
	YearsSinceLastPromotion	YearsWithCurrManager;
RUN;


 /*-------------------------------------------------------------------------------*/
 /*                 STEP 4: identify variables that have non-proportional hazard  */
 /*-------------------------------------------------------------------------------*/

*Checking for non proportional variables using assess statement for martingale residuals ;
PROC phreg DATA=Project2.bonusFerma;
	where YearsAtCompany>1;
	class BusinessTravel  EducationField
		Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0)= BusinessTravel EducationField Gender JobRole
MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
JobLevel JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear
YearsInCurrentRole YearsWithCurrManager;
	title PHreg validation model/ties=efron;
	ASSESS PH/resample;
	title PHreg Non Proportional check model;
RUN;



*Checking for non proportional with Schoenfeld residuals;
ODS GRAPHICS ON;
PROC phreg DATA=Project2.bonusFerma;
	where YearsAtCompany>1;
	class BusinessTravel  EducationField
		Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0)= BusinessTravel EducationField Gender JobRole
MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
JobLevel JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear
YearsInCurrentRole YearsWithCurrManager /ties=efron;
	OUTPUT OUT=PROJECT2.TimeDependentVariableModel RESSCH=BusinessTravel EducationField Gender JobRole
MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
JobLevel JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear
YearsInCurrentRole YearsWithCurrManager ;
	title PHreg validation model;
RUN;

DATA PROJECT2.TimeDependentVariableModel;
	SET PROJECT2.TimeDependentVariableModel;
	id=_n_;
RUN;

/*find the correlations with years in thecompany and it's functions */
DATA PROJECT2.CorrTimeDependentVariableModel;
	SET PROJECT2.TimeDependentVariableModel;
	logYearsAtCompany=log(YearsAtCompany);
	YearsAtCompany2=YearsAtCompany*YearsAtCompany;

PROC CORR data=PROJECT2.CorrTimeDependentVariableModel;
	VAR YearsAtCompany logYearsAtCompany YearsAtCompany2;
	WITH  DistanceFromHome EnvironmentSatisfaction JobInvolvement
JobLevel JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear
YearsInCurrentRole YearsWithCurrManager;
RUN;

*Residuals of Number of Companies Worked vs Years At Company;

proc sgplot data=PROJECT2.TimeDependentVariableModel;
	scatter x=YearsAtCompany y=NumCompaniesWorked / datalabel=id;
	title residuals of Number of Companies Worked vs Years At Company;
	*Residuals of Total Working Years vs Years At Company;

proc sgplot data=PROJECT2.TimeDependentVariableModel;
	scatter x=YearsAtCompany y=TotalWorkingYears / datalabel=id;
	title Total Working Years vs Years At Company;
	*Residuals of Years In Current role vs Years At Company;

proc sgplot data=PROJECT2.TimeDependentVariableModel;
	scatter x=YearsAtCompany y=YearsInCurrentRole/ datalabel=id;
	title Years In Current role vs Years At Company;
run;

proc sgplot data=PROJECT2.TimeDependentVariableModel;
	scatter x=YearsAtCompany y=YearsWithCurrManager/ datalabel=id;
	title YearsWithCurrManager vs Years At Company;
run;

 /*-------------------------------------------------------------------------------*/
 /*        STEP 5: add interacting variables as product of time variable 		  */
 /*-------------------------------------------------------------------------------*/


*adding interactions for non proportional variables using YearsAtCompany ;

PROC phreg DATA=Project2.bonusFerma;
		class BusinessTravel  EducationField
		Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobLevel JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeInteractWorkingYears TimeInteractCurrentRole
		TimeInteractNumCompaniesWorked TimeInteractYearsWithCurrManager/ties=efron;
	TimeInteractWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeInteractCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeInteractNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeInteractYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	title PHreg interaction model;
RUN;


/* Remove JOBLEVEL */


*Checking number of employees left in each type;

PROC FREQ DATA=Project2.FermaLogis;
	TABLES Type*turnoverType / CHISQ plots=freqplot;
	TITLE 'employees left in each type ';
RUN;

 /*-------------------------------------------------------------------------------*/
 /*        STEP 6: Handling cumulative bonus as a time-varying covariate		  */
 /*-------------------------------------------------------------------------------*/


*Implementing phreg using programming step for all the turnover types in one model;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel  EducationField
		Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeIntercatWorkingYears TimeIntercatCurrentRole
		TimeIntercatNumCompaniesWorked TimeIntercatYearsWithCurrManager 
		EmployBonus /ties=BRESLOW;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeIntercatYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	title PHreg model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;


 /*-------------------------------------------------------------------------------*/
 /*                STEP 7: HAZARD DIFFERENCE BETWEEN EVENT TYPES				  */
 /*-------------------------------------------------------------------------------*/



/*Graphically test for linear relation between type hazards*/
DATA Retirement;
	length turnoverType $30.;
	/*create Retirementexit data*/
	SET Project2.FermaLogis;
	event=(Type=1);
	/*this is for censoring out other types, another way to write if statement*/
	turnoverType='Retirement';
run;

DATA VoluntaryResignation;
	length turnoverType $30.;
	/*create Voluntary Resignation exit data*/
	SET Project2.FermaLogis;
	event=(Type=2);

	/*this is for censoring out other types, another way to write if statement*/
	turnoverType='Voluntary Resignation';
run;

DATA InvoluntaryResignation;
	length turnoverType $30.;
	/*create Involuntary Resignation  exit data*/
	SET Project2.FermaLogis;
	event=(Type=3);

	/*this is for censoring out other types, another way to write if statement*/
	turnoverType='Involuntary Resignation';
run;

DATA JobTermination;
	length turnoverType $30.;
	/*create Job Termination  exit data*/
	SET Project2.FermaLogis;
	event=(Type=4);

	/*this is for censoring out other types, another way to write if statement*/
	turnoverType='Job Termination';
run;

Data Project2.combine;
	set Retirement VoluntaryResignation InvoluntaryResignation JobTermination;
run;

	/*Graphically test for linear relation between type hazards*/
PROC LIFETEST DATA=project2.combine method=life PLOTS=(LLS);
	/*LLS plot is requested*/
	TIME YearsAtCompany*event(0);
	STRATA turnoverType /diff=all;
RUN;

/*-------------------------------------------------------------------------------*/
 /*        STEP 7B: evaluating full model against individual event type model	  */
 /*-------------------------------------------------------------------------------*/


*Implementing phreg using programming step for the type Retirement;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel  EducationField Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0, 2, 3, 4)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeIntercatWorkingYears TimeIntercatCurrentRole
		TimeIntercatNumCompaniesWorked TimeIntercatYearsWithCurrManager 
		EmployBonus /ties=BRESLOW;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeIntercatYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

*Implementing phreg using programming step for the type Voluntary Resignation/ Turnover;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel  EducationField Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0, 1, 3, 4)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeIntercatWorkingYears TimeIntercatCurrentRole
		TimeIntercatNumCompaniesWorked TimeIntercatYearsWithCurrManager 
		EmployBonus /ties=BRESLOW;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeIntercatYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	title PHreg model for Voluntary Resignation/ Turnover;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=cum1;
RUN;

*Implementing phreg using programming step for the type InVoluntary Resignation;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel  EducationField Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0, 1, 2, 4)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeIntercatWorkingYears TimeIntercatCurrentRole
		TimeIntercatNumCompaniesWorked TimeIntercatYearsWithCurrManager 
		EmployBonus /ties=BRESLOW;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeIntercatYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	title PHreg model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

*Implementing phreg using programming step for the type Termination;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel  EducationField Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0, 1, 2, 3)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeIntercatWorkingYears TimeIntercatCurrentRole
		TimeIntercatNumCompaniesWorked TimeIntercatYearsWithCurrManager 
		EmployBonus /ties=BRESLOW;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeIntercatYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	title PHreg model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

DATA LogRatioTest_PHregTime;
	Nested=2194.858;
	Retirement=201.90;
	VoluntaryResignation=902.032;
	InVoluntaryResignation=492.815;
	Termination=350.609;
	Total=Retirement+ VoluntaryResignation+InVoluntaryResignation+Termination;
	Diff=Nested - Total;
	P_value=1 - probchi(Diff, 99);
RUN;

PROC PRINT DATA=LogRatioTest_PHregTime;
	FORMAT P_Value 5.3;
	title Total nested vs Individual hypothesis;
RUN;

*checking involuntry  resignation and job termination;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel  EducationField Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0, 1, 2)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeIntercatWorkingYears TimeIntercatCurrentRole
		TimeIntercatNumCompaniesWorked TimeIntercatYearsWithCurrManager 
		EmployBonus /ties=BRESLOW;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeIntercatYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	title PHreg model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;


*checking involuntry  resignation and job termination;

DATA LogRatioTest_PHregIVJT;
	Nested=900.728;
	InVoluntaryResignation=492.815;
	Termination=350.609;
	Total=InVoluntaryResignation+Termination;
	Diff=Nested - Total;
	P_value=1 - probchi(Diff, 33);
	*26*2coef. in 2 models - 26coef. in nested;
RUN;

*checking involuntry  resignation and job termination;

PROC PRINT DATA=LogRatioTest_PHregIVJT;
	FORMAT P_Value 5.3;
	title Nested(involuntry, termination) vs individual hypothesis;
RUN;










/*-------------------------------------------------------------------------------*/
 /*   FINAL STEP: CUSTOMIZE VARIABLES FOR EACH EVENT TYPE	  */
 /*-------------------------------------------------------------------------------*/

*Implementing phreg using programming step for the type Retirement;

PROC phreg DATA=Project2.bonusFerma;
	class   OverTime;
	MODEL YearsAtCompany*Type(0, 2, 3, 4)=  OverTime YearsInCurrentRole YearsWithCurrManager 
	TimeIntercatNumCompaniesWorked	EmployBonus /ties=BRESLOW;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;




/*-------------------------------------------------------------------------------*/
 /*   pending	  */
 /*-------------------------------------------------------------------------------*/

*Implementing phreg using programming step for the type Voluntary Resignation/ Turnover;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel  EducationField Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0, 1, 3, 4)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeIntercatWorkingYears TimeIntercatCurrentRole
		TimeIntercatNumCompaniesWorked TimeIntercatYearsWithCurrManager 
		EmployBonus /ties=BRESLOW;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeIntercatYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	title PHreg model for Voluntary Resignation/ Turnover;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=cum1;
RUN;

*Implementing phreg using programming step for the type InVoluntary Resignation;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel  EducationField Gender JobRole MaritalStatus OverTime;
	MODEL YearsAtCompany*Type(0, 1, 2, 4)=BusinessTravel EducationField Gender JobRole
		MaritalStatus OverTime DistanceFromHome EnvironmentSatisfaction JobInvolvement
		JobSatisfaction NumCompaniesWorked TotalWorkingYears TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager TimeIntercatWorkingYears TimeIntercatCurrentRole
		TimeIntercatNumCompaniesWorked TimeIntercatYearsWithCurrManager 
		EmployBonus /ties=BRESLOW;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	TimeIntercatYearsWithCurrManager=YearsAtCompany*YearsWithCurrManager;
	title PHreg model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

*Implementing phreg using programming step for the type Termination;

PROC phreg DATA=Project2.bonusFerma;
	MODEL YearsAtCompany*Type(0, 1, 2, 3)= TrainingTimesLastYear 
		YearsInCurrentRole YearsWithCurrManager /ties=BRESLOW;
	title PHreg model;
RUN;



/*-------------------------------------------------------------------------------*/
 /*   EDA  */
 /*-------------------------------------------------------------------------------*/

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox DistanceFromHome /category= TurnoverType;
	Title 'DistanceFromHome  Analysis';
run;


Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbox Age /category= TurnoverType;
	Title 'Age  Analysis';
run;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=Overtime;
	Title 'Overtime Effect on Turnover types';
	
	
Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=Department;
	Title 'Department on Turnover types';
run;


Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=JobRole;
	Title 'JobRole on Turnover types';
run;

Proc sgplot data=Project2.FermaLogis;
	where turnoverType ne 'No Turnover';
	vbar TurnoverType /group=YearsWithCurrManager;
	Title 'YearsWithCurrManager on Turnover types';
run;



