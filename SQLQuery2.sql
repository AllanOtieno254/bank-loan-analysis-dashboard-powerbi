--DASHBOARD1 SUMMARY

SELECT * 
FROM Bank_loan_data

--TOTAL LOAN APPLICATION(KPI)
--Total Application
SELECT COUNT(id) AS Total_Loan_Applications
FROM Bank_loan_data 

--MTD Loan Application
SELECT COUNT(id) AS MTD_Total_Loan_Applications
FROM Bank_loan_data 
WHERE MONTH(issue_date)= 12 AND YEAR(issue_date)=2021

--PMTD Loan Application
SELECT COUNT(id) AS PMTD_Total_Loan_Applications
FROM Bank_loan_data 
WHERE MONTH(issue_date)= 11 AND YEAR(issue_date)=2021

--TOTAL FUNDED AMOUNT(KPI)
SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM Bank_loan_data

--MTD Funded amount
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM Bank_loan_data
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021

--PMTD Funded amount
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount
FROM Bank_loan_data
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021

--Total Amount Received(KPI)
SELECT SUM(total_payment) AS Total_Amount_Received
FROM Bank_loan_data

--MTD Amount Received
SELECT SUM(total_payment) AS MTD_Total_Amount_Received
FROM Bank_loan_data
WHERE MONTH( issue_date)=12 AND YEAR(issue_date)=2021

--PMTD Amount Received
SELECT SUM(total_payment) AS PMTD_Total_Amount_Received
FROM Bank_loan_data
WHERE MONTH( issue_date)=11 AND YEAR(issue_date)=2021

--AVERAGE INTEREST RATE(KPI)
SELECT ROUND(AVG(int_rate),4)*100 AS Average_interest_Rate 
FROM Bank_loan_data

--MTD Interest Rate
SELECT ROUND(AVG(int_rate),4) * 100 AS MTD_Average_interest_Rate 
FROM Bank_loan_data
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021

--PMTD Interest Rate
SELECT ROUND(AVG(int_rate),4)*100 AS PMTD_Average_interest_Rate 
FROM Bank_loan_data
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021

--AVERAGE DEPT TO INCOME RATIO(KPI)
SELECT ROUND(AVG(dti),4) *100 AS Avg_DTI
FROM Bank_loan_data

--MTDAVERAGE DEPT TO INCOME RATIO
SELECT ROUND(AVG(dti),4) *100 AS MTD_Avg_DTI
FROM Bank_loan_data
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021

--PMTDAVERAGE DEPT TO INCOME RATIO
SELECT ROUND(AVG(dti),4) *100 AS PMTD_Avg_DTI
FROM Bank_loan_data
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021

--GOOD LOAN VS BAD LOAN(KPI)
SELECT loan_status 
FROM Bank_loan_data

--Good Loan 
SELECT 
       (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100) 
	   /
	   COUNT(id) AS Good_Loan_Percentage
	   FROM Bank_loan_data

--Good loan Applications
SELECT COUNT(id) AS Good_loan_Applications
FROM Bank_loan_data
WHERE loan_status IN ('Fully Paid', 'Current')

--Good loan funded amount
SELECT SUM(total_payment) AS Good_loan_Received_Amount
FROM Bank_loan_data
WHERE loan_status IN ('Fully Paid', 'Current')


--BAD LOANS
--% Bad loans

SELECT 
         (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)*100.0)
		 /
		 COUNT(id) AS Bad_Loan_Percentage
FROM Bank_loan_data

--Bad loan Applications
SELECT COUNT(id) AS Bad_loan_Applications
FROM Bank_loan_data
WHERE loan_status = 'Charged off'

--Bad loan funded amount
SELECT SUM(loan_amount) AS Bad_loan_Funded_Amount
FROM Bank_loan_data
WHERE loan_status = 'Charged off'

--Bad loan Received amount
SELECT SUM(total_payment) AS Bad_loan_Amount_Received
FROM Bank_loan_data
WHERE loan_status = 'Charged off'

--LOAN STATUS GRID VIEW
SELECT
		loan_status,
		COUNT(id) AS Total_Loan_Applications,
		SUM(total_payment) AS Total_Amount_Received,
		SUM(loan_amount) AS Total_Total_Funded_Amount,
		AVG(int_rate) AS Interest_Rate,
		AVG(dti *100) AS DTI
	FROM
		Bank_loan_data
	GROUP BY
	loan_status

--Current MTD amount received
SELECT
		loan_status,
		SUM(total_payment) AS MTD_Total_Amount_Received,
		SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM Bank_loan_data
WHERE MONTH(issue_date) = 12
GROUP BY loan_status

--DASHBOARD 2: OVERVIEW
--CHARTS(NB: Ensure the charts are based on specific objectives for all of them for ours are i.e specific dashboard metrics :
--1. Total loan application
--2. Total funded amount
--3. total received amount
SELECT * 
FROM Bank_loan_data

--monthly trends by issued date(line chart)
SELECT
		MONTH(issue_date) AS Month_Number,
		DATENAME(MONTH, issue_date) AS Month_Name, --interval,date column
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
FROM Bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)

--Region Analysis by state(filled map)
SELECT
		address_state,
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
FROM Bank_loan_data
GROUP BY address_state
ORDER BY COUNT(id) DESC

--Loan term analysis (donut chart)

SELECT
		term,
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
FROM Bank_loan_data
GROUP BY term
ORDER BY term

--employee length analysis(bar chart)

SELECT
		emp_length,
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
FROM Bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) DESC

--purpose for the loan(bar chart)
SELECT
		purpose,
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
FROM Bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC

--Home ownership analysis(tree map)
SELECT
		home_ownership,
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
FROM Bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC

--DASHBOARD 3: DETAILS
--GRID
SELECT
		home_ownership,
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
FROM Bank_loan_data
WHERE grade = 'A'
GROUP BY home_ownership
ORDER BY COUNT(id) DESC

SELECT
		home_ownership,
		COUNT(id) AS Total_Loan_Applications,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
FROM Bank_loan_data
WHERE grade = 'A' AND address_state = 'CA'
GROUP BY home_ownership
ORDER BY COUNT(id) DESC


































