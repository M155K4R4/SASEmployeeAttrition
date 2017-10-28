
/* Setting the library */
LIBNAME project1 '/folders/myfolders/Survival/Projects/project1';

 /*-------------------------------------------------------------------*/
 /*  					Data Definition and Manipulation			 */
 /*-------------------------------------------------------------------*/

/* Importing the raw dataset */
proc import datafile= "/folders/myfolders/Survival/Projects/project1/FermaLogis(1) - Copy.csv" 
out=project1.fermalogis
DBMS=csv replace;
Getnames=yes;
run;


DATA project1.fermalogis(DROP = I COUNT_0 COUNT_1);
SET project1.fermalogis (DROP = VAR1 RENAME = (X = SNO));
	ARRAY X[40] BONUS_1-BONUS_40;
	COUNT_0 = 0;
	COUNT_1 = 0;
	DO I = 1 TO 40;
		IF X[I] EQ "0" THEN COUNT_0 = COUNT_0+1;
		IF X[I] EQ "1" THEN COUNT_1 = COUNT_1+1;
	END;
	
	IF COUNT_0 EQ 0 and COUNT_1 EQ 0 THEN BONUS_RATIO = 0;
	ELSE BONUS_RATIO = COUNT_1/(COUNT_0+COUNT_1);
	FORMAT BONUS_RATIO 12.2;

	IF YearsAtCompany <=5 Then
		Datagroup='YOUNG_EMP';

	IF YearsAtCompany > 5 Then
		Datagroup='EXP_EMP';
RUN;

/* Create seperate datasets for young and experienced employees */
DATA project1.young_emp project1.experienced_emp;
	SET project1.fermalogis;

	If UPCASE(Datagroup)='YOUNG_EMP' THEN
		OUTPUT project1.young_emp;
	Else if UPCASE(Datagroup)='EXP_EMP' THEN
		output project1.experienced_emp;
RUN;

DATA PROJECT1.young_emp PROJECT1.experienced_emp;
SET PROJECT1.young_emp (IN = A) PROJECT1.experienced_emp (IN = B);

	IF UPCASE(Attrition)="NO" THEN Attrition_Flag=0;
	ELSE Attrition_Flag=1;

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

	IF A THEN OUTPUT PROJECT1.young_emp;
	ELSE IF B THEN OUTPUT PROJECT1.experienced_emp;
RUN;

 /*---------------------------------------------------------------------------------*/
 /*  					Exploratory analysis - identifying unimportant variables	 */
 /*----------------------------------------------------------------------------------*/


PROC SGPLOT DATA = project1.fermalogis;
SCATTER X = HourlyRate  Y = MonthlyRate;
REG X=HourlyRate Y=MonthlyRate;
TITLE 'HourlyRate vs. MonthlyIncome';
RUN;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=YearsWithCurrManager STAT=median;
	yaxis labelattrs=(size=15pt);
	xaxis labelattrs=(size=15pt);
	Title 'Bar plot for Attrition vs YearsWithCurrManager';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=NumCompaniesWorked STAT=median;
	yaxis labelattrs=(size=15pt);
	xaxis labelattrs=(size=15pt);
	Title 'Bar plot for Attrition vs NumCompaniesWorked';
run;


PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=PerformanceRating STAT=median;
	yaxis labelattrs=(size=15pt);
	xaxis labelattrs=(size=15pt);
	Title 'Bar plot for Attrition vs PerformanceRating';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=WorkLifeBalance STAT=median;
	yaxis labelattrs=(size=15pt);
	xaxis labelattrs=(size=15pt);
	Title 'Bar plot for Attrition vs WorkLifeBalance';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=YearsWithCurrManager STAT=median;
	yaxis labelattrs=(size=15pt);
	xaxis labelattrs=(size=15pt);
	Title 'Bar plot for Attrition vs YearsWithCurrManager';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=MonthlyIncome STAT=median;
	Title 'Bar plot for Attrition vs Monthly Income';
run;


PROC SGPLOT DATA=project1.fermalogis;
	VBAR JobRole/ GROUP=Attrition groupdisplay=cluster;
	yaxis labelattrs=(size=15pt);
	xaxis labelattrs=(size=15pt);
	Title 'Stacked Bar plot for Attrition vs JobRole ';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR EducationField / GROUP=Attrition groupdisplay=cluster;
	yaxis labelattrs=(size=15pt);
	xaxis labelattrs=(size=15pt);
	Title 'Bar plot for Attrition vs EducationField ';
run;


 /*---------------------------------------------------------------------------------*/
 /*  					Hypothesis test - identifying unimportant variables	 		*/
 /*----------------------------------------------------------------------------------*/


proc freq data = project1.fermalogis;
	tables Department*Attrition / NOROW NOPERCENT CHISQ;
	tables JobSatisfaction*Attrition / NOROW NOPERCENT CHISQ;
run;

PROC anova data=project1.fermalogis;
	CLASS Attrition;
	MODEL PercentSalaryHike=Attrition;
	MEANS Attrition/SCHEFFE;
	TITLE 'PercentSalaryHike based on Attrition';
run;

PROC anova data=project1.fermalogis;
	CLASS Attrition;
	MODEL YearsSinceLastPromotion=Attrition;
	MEANS Attrition/SCHEFFE;
	TITLE 'YearsSinceLastPromotion based on Attrition';
run;

/*--------------------------------------------------------------------------------------*/
 /*  Experienced employees:	Hypothesis test - identifying unimportant variables	 		*/
 /*----------------------------------------------------------------------------------*/ 

proc freq data = project1.experienced_emp;
	tables Department*Attrition / NOROW NOPERCENT CHISQ;
	tables JobSatisfaction*Attrition / NOROW NOPERCENT CHISQ;
run;

PROC anova data=project1.experienced_emp;
	CLASS Attrition;
	MODEL DistanceFromHome=Attrition;
	MEANS Attrition/SCHEFFE;
	TITLE 'DistanceFromHome based on Attrition';
run;

PROC anova data=project1.experienced_emp;
	CLASS Attrition;
	MODEL TotalWorkingYears=Attrition;
	MEANS Attrition/SCHEFFE;
	TITLE 'TotalWorkingYears based on Attrition';
run;

PROC anova data=project1.experienced_emp;
	CLASS Attrition;
	MODEL TrainingTimesLastYear=Attrition;
	MEANS Attrition/SCHEFFE;
	TITLE 'TrainingTimesLastYear based on Attrition';
run;

PROC anova data=project1.experienced_emp;
	CLASS Attrition;
	MODEL YearsInCurrentRole=Attrition;
	MEANS Attrition/SCHEFFE;
	TITLE 'YearsInCurrentRole based on Attrition';
run;



/* Exploratory analysis on Quantitative variables */
PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=Age STAT=median;
	Title 'Bar plot for Attrition vs Age';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=OverTime STAT=median;
	Title 'Bar plot for Attrition vs OverTime';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=YearsAtCompany STAT=median;
	Title 'Bar plot for Attrition vs YearsAtCompany';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=YearsInCurrentRole STAT=median;
	Title 'Bar plot for Attrition vs YearsInCurrentRole';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=DistanceFromHome STAT=median;
	Title 'Bar plot for Attrition vs DistanceFromHome';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=PercentSalaryHike STAT=median;
	Title 'Bar plot for Attrition vs PercentSalaryHike';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ RESPONSE=BonusReceivedRatio STAT=median;
	Title 'Bar plot for Attrition vs BonusReceivedRatio';
run;



/* Exploratory analysis on categorical variables */


PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ GROUP=Department groupdisplay=cluster;
	Title 'Bar plot for Attrition vs Department ';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ GROUP=Education groupdisplay=cluster;
	Title 'Bar plot for Attrition vs Education ';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ GROUP=Gender groupdisplay=cluster;
	Title 'Bar plot for Attrition vs Gender';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ GROUP=JobInvolvement groupdisplay=cluster;;
	Title 'Bar plot for Attrition vs JobInvolvement';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ GROUP=JobLevel groupdisplay=cluster;;
	Title 'Bar plot for Attrition vs JobLevel';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ GROUP=StockOptionLevel groupdisplay=cluster;
	Title 'Bar plot for Attrition vs StockOptionLevel';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ GROUP=BusinessTravel groupdisplay=cluster;
	Title 'Bar plot for Attrition vs BusinessTravel';
run;

PROC SGPLOT DATA=project1.fermalogis;
	VBAR Attrition/ GROUP=MaritalStatus groupdisplay=cluster;
	Title 'Bar plot for Attrition vs MaritalStatus';
run;

/*--------------------------------------------------------------------------------------*/
 /*  Young employees:	DATA EXPLORATION WITH SURVIVAL METHODS 							*/
 /*-------------------------------------------------------------------------------------*/ 

PROC LIFETEST data=PROJECT1.young_emp method=life intervals=0 1 2 3 4 5 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	test  bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel EnvironmentSatisfaction 
		 JobSatisfaction TotalWorkingYears TrainingTimesLastYear YearsInCurrentRole Age DistanceFromHome;
RUN;

/* Strata for Overtime (Yes - 1 and No - 0) */
PROC LIFETEST data=PROJECT1.young_emp method=life intervals=0 1 2 3 4 5 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	strata Overtime_Flag;
	test bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel EnvironmentSatisfaction 
		 JobSatisfaction TotalWorkingYears YearsInCurrentRole Age DistanceFromHome;
RUN;

/* Strata for Department (SALES: 0; RESEARCH & DEVELOPMENT: 1; HUMAN RESOURCES: 2)*/
PROC LIFETEST data=PROJECT1.young_emp method=life intervals=0 1 2 3 4 5 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	strata Department;
	test bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel EnvironmentSatisfaction 
		 JobSatisfaction TotalWorkingYears YearsInCurrentRole Age DistanceFromHome;
RUN;

/* Strata for MaritalStatus (Married - 0; Divorced - 1; Single - 2) */
PROC LIFETEST data=PROJECT1.young_emp method=life intervals=0 1 2 3 4 5 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	strata MaritalStatus;
	test  bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel EnvironmentSatisfaction 
		 JobSatisfaction TotalWorkingYears YearsInCurrentRole Age DistanceFromHome;
RUN;

PROC LIFETEST data=PROJECT1.young_emp method=life intervals=0 1 2 3 4 5 6 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	strata BusinessTravel;
	test  bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel EnvironmentSatisfaction 
		 JobSatisfaction TotalWorkingYears YearsInCurrentRole Age DistanceFromHome;
RUN;
/*--------------------------------------------------------------------------------------*/
 /*  Experienced employees:	DATA EXPLORATION WITH SURVIVAL METHODS 							*/
 /*-------------------------------------------------------------------------------------*/ 

PROC LIFETEST data=PROJECT1.experienced_emp method=life intervals=4 10 15 20 25 30 35 40 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	test bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel 
		 EnvironmentSatisfaction RelationshipSatisfaction YearsSinceLastPromotion Age;
RUN;

/* strata Overtime */
PROC LIFETEST data=PROJECT1.experienced_emp method=life intervals=4 10 15 20 25 30 35 40 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	strata Overtime;
	test bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel Age;
RUN;

/* strata MaritalStatus */
PROC LIFETEST data=PROJECT1.experienced_emp method=life intervals=4 10 15 20 25 30 35 40 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	strata MaritalStatus;
	test bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel Age;
RUN;

/* strata BusinessTravel */
PROC LIFETEST data=PROJECT1.experienced_emp method=life intervals=4 10 15 20 25 30 35 40 plots=(S H);
	time YearsAtCompany*Attrition_FLAG(0);
	strata BusinessTravel;
	test bonus_ratio JobInvolvement JobLevel MonthlyIncome StockOptionLevel Age;
RUN;

/*--------------------------------------------------------------------------------------*/
 /*  						Young Employees:MODELING													*/
 /*-------------------------------------------------------------------------------------*/ 

/** Weibull Model **/

/* Backward Stepwise Regression */
PROC LIFEREG data=project1.young_emp;
	CLASS BusinessTravel Department MaritalStatus JobInvolvement OverTime;
	MODEL YearsAtCompany*Attrition_FLAG(0)=  EnvironmentSatisfaction JobSatisfaction 
	DistanceFromHome MaritalStatus  
	YearsInCurrentRole BONUS_RATIO/ DISTRIBUTION=WEIBULL;
RUN;

/** lognormal Model **/

/* Backward Stepwise Regression */
PROC LIFEREG data=project1.young_emp;
	CLASS BusinessTravel Department JobInvolvement OverTime;
	MODEL YearsAtCompany*Attrition_FLAG(0)=  Joblevel EnvironmentSatisfaction JobSatisfaction 
	DistanceFromHome YearsInCurrentRole BONUS_RATIO/ DISTRIBUTION=lognormal;
RUN;




DATA ComparebetweenModels_Young;
	L_weibull=-292.94;
	L_lognormal=-262.47;
	LRTLW=-2*(L_lognormal - L_weibull);
	p_valueLW=1 - probchi(LRTLW, 1);
RUN;

PROC PRINT DATA=ComparebetweenModels_Young;
RUN;



/*--------------------------------------------------------------------------------------*/
 /*  						Experienced Employees:MODELING													*/
 /*-------------------------------------------------------------------------------------*/ 


/** exponential Model **/
PROC LIFEREG DATA=project1.experienced_emp;
	MODEL YearsAtCompany*Attrition_FLAG(0)=/DISTRIBUTION=exponential;
RUN;

PROC LIFEREG data=project1.experienced_emp;
		CLASS BusinessTravel JobInvolvement MaritalStatus OverTime StockOptionLevel;
	MODEL YearsAtCompany*Attrition_FLAG(0)=BusinessTravel JobInvolvement MaritalStatus
	OverTime StockOptionLevel BONUS_RATIO/ DISTRIBUTION=exponential;
RUN;

/* Backward Stepwise Regression */
PROC LIFEREG data=project1.experienced_emp;
	CLASS OverTime;
	MODEL YearsAtCompany*Attrition_FLAG(0)= BONUS_RATIO / DISTRIBUTION=exponential;
RUN;


PROC LIFEREG data=project1.experienced_emp;
	MODEL YearsAtCompany*Attrition_FLAG(0)= / DISTRIBUTION=weibull;
	CLASS EnvironmentSatisfaction BusinessTravel ;
RUN;




/**Comparison between all three model for Experienced Employee**/
DATA ComparebetweenModelsExp;
	L_exponential=-246.94;
	L_weibull=-169.91;
	LRTEW=-2*(L_exponential - L_weibull);
	p_valueEW=1 - probchi(LRTEW, 1);
RUN;

PROC PRINT DATA=ComparebetweenModelsExp;
RUN;