CREATE TABLE walmart_sales (
    store INT,
    date DATE,
    weekly_sales DECIMAL(10,2),
    holiday_flag INT,
    temperature DECIMAL(5,2),
    fuel_price DECIMAL(5,2),
    cpi DECIMAL(10,2),
    unemployment DECIMAL(5,2)
);

--Check Dataset
SELECT * FROM walmart_sales;


--Check total rows
SELECT COUNT(*) AS total_rows FROM walmart_sales;


--Check mising value
SELECT COUNT(*) AS missing_sales
FROM walmart_sales
WHERE weekly_sales IS NULL;


--How many Weekly Sales record per Store
SELECT store, COUNT(*) 
FROM walmart_sales
GROUP BY store
ORDER BY count DESC;


--Add Year and Month column
ALTER TABLE walmart_sales ADD COLUMN year INT;
ALTER TABLE walmart_sales ADD COLUMN month INT;


--Fill data in Year and Month
UPDATE walmart_sales
SET year = EXTRACT(YEAR FROM date),
    month = EXTRACT(MONTH FROM date);


--Calculate total Revenue and Year-Over-Year(Y-O-Y) growth		--YOY growth mathematically formula
																--current year sale: C, previous year sale: P
																--YOY Growth(%) = (C-P)/(P)*100
SELECT													
    ROUND(SUM(weekly_sales)::NUMERIC, 2) AS total_sales,
    ROUND(
        (SUM(weekly_sales) - LAG(SUM(weekly_sales)) OVER (ORDER BY year)) 
        / LAG(SUM(weekly_sales)) OVER (ORDER BY year) * 100, 2
    ) AS yoy_growth_percent
FROM walmart_sales
GROUP BY year
ORDER BY year;


--Top 5 Best-Performing Stores
SELECT store, ROUND(SUM(weekly_sales)::NUMERIC, 2) AS total_sales
FROM walmart_sales
GROUP BY store
ORDER BY total_sales DESC
LIMIT 5;


--Holiday Impact on Sales
SELECT
    CASE WHEN holiday_flag = 1 THEN 'Holiday Week' ELSE 'Non-Holiday Week' END AS week_type,
    ROUND(AVG(weekly_sales)::NUMERIC, 2) AS avg_weekly_sales
FROM walmart_sales
GROUP BY week_type;


--Relation Between Temperature and Sales
SELECT
    FLOOR(temperature/10)*10 AS temperature_group,
    ROUND(AVG(weekly_sales)::NUMERIC, 2) AS avg_sales
FROM walmart_sales
GROUP BY temperature_group
ORDER BY temperature_group;


--Store Performance Stability (Consistency)
SELECT
    store,
    ROUND(STDDEV(weekly_sales)::NUMERIC, 2) AS sales_volatility,
    ROUND(AVG(weekly_sales)::NUMERIC, 2) AS avg_sales
FROM walmart_sales
GROUP BY store
ORDER BY sales_volatility;


--Seasonal Trend (Monthly Sales)
SELECT
    year,
    month,
    ROUND(SUM(weekly_sales)::NUMERIC, 2) AS total_sales
FROM walmart_sales
GROUP BY year, month
ORDER BY year, month;







