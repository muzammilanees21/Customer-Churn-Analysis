-- ============================================================================
-- Customer Churn Analysis - SQL Queries
-- ============================================================================
-- Dataset: Telco Customer Churn (IBM)
-- Purpose: Analyze customer churn patterns and identify key drivers
-- ============================================================================

-- ============================================================================
-- PART 1.1: CUSTOMER OVERVIEW QUERIES
-- ============================================================================

-- Query 1: Count total customers
SELECT COUNT(*) as Total_Customers 
FROM customers;

-- Query 2: Count churned customers (Churn = 'Yes')
SELECT COUNT(*) as Churned_Customers 
FROM customers 
WHERE Churn = 'Yes';

-- ============================================================================
-- PART 1.2: DEMOGRAPHICS QUERIES
-- ============================================================================

-- Query 3: Count customers by gender
SELECT gender, COUNT(*) as Count 
FROM customers 
GROUP BY gender;

-- Query 4: Count senior citizens (SeniorCitizen = 1)
SELECT COUNT(*) as Senior_Citizens 
FROM customers 
WHERE SeniorCitizen = 1;

-- ============================================================================
-- PART 1.3: CONTRACT & TENURE QUERIES
-- ============================================================================

-- Query 5: Average tenure for churned vs non-churned customers
SELECT 
    Churn,
    AVG(CAST(tenure AS FLOAT)) as Avg_Tenure_Months,
    COUNT(*) as Customer_Count
FROM customers 
GROUP BY Churn
ORDER BY Avg_Tenure_Months DESC;

-- Query 6: Number of customers by Contract type
SELECT 
    Contract,
    COUNT(*) as Count 
FROM customers 
GROUP BY Contract
ORDER BY Count DESC;

-- ============================================================================
-- PART 1.4: INTERNET SERVICE & CHARGES QUERIES
-- ============================================================================

-- Query 7: Average MonthlyCharges by InternetService category
SELECT 
    InternetService,
    AVG(CAST(MonthlyCharges AS FLOAT)) as Avg_Monthly_Charges,
    COUNT(*) as Customer_Count
FROM customers 
GROUP BY InternetService
ORDER BY Avg_Monthly_Charges DESC;

-- Query 8: Total TotalCharges by PaymentMethod
SELECT 
    PaymentMethod,
    COUNT(*) as Customer_Count,
    SUM(CAST(TotalCharges AS FLOAT)) as Total_Charges,
    AVG(CAST(TotalCharges AS FLOAT)) as Avg_Total_Charges
FROM customers 
GROUP BY PaymentMethod
ORDER BY Total_Charges DESC;

-- ============================================================================
-- PART 1.5: CHURN DRIVER QUERIES
-- ============================================================================

-- Query 9: Churn rate by Contract type
SELECT 
    Contract,
    COUNT(*) as Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as Churned_Count,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Percent
FROM customers
GROUP BY Contract
ORDER BY Churn_Rate_Percent DESC;

-- Query 10: Churn rate by InternetService type
SELECT 
    InternetService,
    COUNT(*) as Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as Churned_Count,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Percent
FROM customers
GROUP BY InternetService
ORDER BY Churn_Rate_Percent DESC;

-- Query 11: Churn rate by OnlineSecurity (Yes vs No)
SELECT 
    OnlineSecurity,
    COUNT(*) as Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as Churned_Count,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Percent
FROM customers
GROUP BY OnlineSecurity
ORDER BY Churn_Rate_Percent DESC;

-- ============================================================================
-- PART 1.6: ADVANCED AGGREGATION QUERIES
-- ============================================================================

-- Query 12: Top 5 customer segments (by Contract and InternetService) 
--           with highest churn rate
SELECT 
    Contract,
    InternetService,
    COUNT(*) as Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as Churned_Count,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Percent
FROM customers
GROUP BY Contract, InternetService
ORDER BY Churn_Rate_Percent DESC
LIMIT 5;

-- ============================================================================
-- BONUS: Additional Analytical Queries for Deeper Insights
-- ============================================================================

-- Bonus Query 1: Customer value analysis by tenure and churn
SELECT 
    CASE 
        WHEN CAST(tenure AS FLOAT) <= 6 THEN '0-6 months'
        WHEN CAST(tenure AS FLOAT) <= 12 THEN '6-12 months'
        WHEN CAST(tenure AS FLOAT) <= 24 THEN '1-2 years'
        WHEN CAST(tenure AS FLOAT) <= 48 THEN '2-4 years'
        ELSE '4+ years'
    END as Tenure_Bracket,
    COUNT(*) as Total_Customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as Churned_Count,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Percent,
    ROUND(AVG(CAST(MonthlyCharges AS FLOAT)), 2) as Avg_Monthly_Charges,
    ROUND(AVG(CAST(TotalCharges AS FLOAT)), 2) as Avg_Total_Charges
FROM customers
GROUP BY Tenure_Bracket
ORDER BY 
    CASE 
        WHEN Tenure_Bracket = '0-6 months' THEN 1
        WHEN Tenure_Bracket = '6-12 months' THEN 2
        WHEN Tenure_Bracket = '1-2 years' THEN 3
        WHEN Tenure_Bracket = '2-4 years' THEN 4
        ELSE 5
    END;

-- Bonus Query 2: Comprehensive customer segmentation for targeting
SELECT 
    Contract,
    CASE 
        WHEN CAST(MonthlyCharges AS FLOAT) < 50 THEN 'Low-Cost'
        WHEN CAST(MonthlyCharges AS FLOAT) < 85 THEN 'Mid-Tier'
        ELSE 'Premium'
    END as Price_Segment,
    COUNT(*) as Customer_Count,
    ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Percent,
    ROUND(AVG(CAST(tenure AS FLOAT)), 1) as Avg_Tenure_Months
FROM customers
GROUP BY Contract, Price_Segment
ORDER BY Churn_Rate_Percent DESC;
