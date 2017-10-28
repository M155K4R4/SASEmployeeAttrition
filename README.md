# Diagnosing Employee Attrition using Survival Analysis

Code_Project1.sas: 

Dataset with information on 1470 employees is analyzed using Life-Table and Kaplan-Meier methods


Code_Project2.sas:

a) Analyzed competing risks such as Retirement, Termination, Voluntary and Involuntary resignation 

b) Modeled effect of time-varying covariates such as Bonus across employment tenure


Data Dictionary:

The project involved analyzing the data of 1470 employees of FermaLogis. 

It included information employees such as demographics, professional experience, job-satisfaction indicators, and job details that may influence the decision to leave the company. 

Below is the description of all variables in the data: 

•	Age: Age of the employee when the dataset was created

•	Attrition: Shows whether the employee left the company or not

•	BusinessTravel: Shows how much travel employee makes

•	DailyRate: Daily compensation of employee before any cuts/taxes

•	Department: Shows the department of the employee when this dataset was created

•	DistanceFromHome: Commuting distance for the employee in miles

•	Education:	
o	1 'Below College'
o	2 'College'
o	3 'Bachelor'
o	4 'Master'
o	5 'Doctor'

•	EducationField: Shows the education field of the employee

•	EmployeeCount: A field used for aggregation calculations

•	EmloyeeNumber: ID of the employee

•	EnvironmentSatisfaction: A score indicating employees’ satisfaction with company's facilities
o	1 'Low'
o	2 'Medium'
o	3 'High'
o	4 'Very High'

•	Gender: Shows the gender of the employee

•	HourlyRate: Hourly compensation of employee before any cuts/taxes

•	JobInvolvement: A score given by supervisors to indicate employee’s involvement in company's operations
o	1 'Low'
o	2 'Medium'
o	3 'High'
o	4 'Very High'

•	JobRole: Shows the job role of the employee in the company

•	JobLevel: Shows the management level of the employee

•	JobSatisfaction: Shows the most recent survey result employee’s job satisfaction

•	MaritalStatus: Shows the marital status of the company

•	MonthlyIncome: Shows the monthly income of the employee

•	MontlyRate: Monthly compensation of employee before any cuts/taxes

•	NumCompaniesWorked: Number of companies the employee worked before starting here

•	Over18: Shows whether the employee is over 18 years old.

•	OverTime: Shows whether employee works overtime more than 10 hours a week 

•	PercentSalaryHike: Shows the agreed yearly salary rise percent

•	PerformanceRating: Score given by supervisors showing employees’ performance last year
o	1 'Low'
o	2 'Good'
o	3 'Excellent'
o	4 'Outstanding'

•	RelationshipSatisfaction: Shows the last survey result of the employee’s satisfaction with other employees in the company
o	1 'Low'
o	2 'Medium'
o	3 'High'
o	4 'Very High'

•	StandardHours: Number of hours employee works for one payroll period (two weeks) 

•	StockOptionLevel: Shows the stock option for an employee. If the analyses give significant results for this variable, you can refer to that group as "employees with stock option level x"

•	TotalWorkingYears: Shows the time the employee worked as a professional (at any company)

•	TrainingTimesLastYear: Shows number of training programs employee attended last year

•	WorkLifeBalance: Shows employee’s satisfaction of the work load (4 is the highest satisfaction level)
o	1 'Bad'
o	2 'Good'
o	3 'Better'
o	4 'Best' 

•	YearsAtCompany: Tenure at the company

•	YearsInCurrentRole: Number of years employee has been in the current position

•	YearsSinceLastPromotion: Shows the number of years passed since the last promotion

•	YearsWithCurrentManager: Shows the number of years with the current supervisor.

•	bonus_1-40: Shows whether the employee received bonus payments in the last 40 years. bonus_1 is last year.
For our analysis, all employees with less than five years tenure in the company were considered as “Young” and the rest as “Experienced”.
