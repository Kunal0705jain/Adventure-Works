create database adventure;
use adventure;

-- Q0
create table Sales
select * from fact_internet_sales_new
union
select * from factinternetsales;

select * from sales;
select * from dimproduct;

-- Q1 
SELECT    
sales.*,      
EnglishProductName
FROM
    sales
JOIN
    dimproduct
ON
    sales.ProductKey = dimproduct.ProductKey;

-- Q2
SELECT S.ProductKey, S.CustomerKey, concat_ws(' ',C.FirstName, C.MiddleName, C.LastName) AS FullName, P.Unit price
FROM Sales S
JOIN dimcustomer C ON S.CustomerKey = C.CustomerKey
JOIN dimproduct P ON S.ProductKey = P.ProductKey;

-- Q3
ALTER TABLE Sales
ADD COLUMN Year INT,
ADD COLUMN Monthno INT,
ADD COLUMN Monthfullname VARCHAR(15),
ADD COLUMN Quarter VARCHAR(2),
ADD COLUMN YearMonth VARCHAR(10),
ADD COLUMN Weekdayno INT,
ADD COLUMN Weekdayname VARCHAR(10),
ADD COLUMN FinancialMonth INT,
ADD COLUMN FinancialQuarter VARCHAR(2);

ALTER TABLE Sales
MODIFY COLUMN YearMonth VARCHAR(10);

UPDATE Sales
SET 
    -- Convert Orderdatekey to DATE format
    OrderDate = STR_TO_DATE(Orderdatekey, '%Y%m%d'),

    -- A. Year
    Year = YEAR(STR_TO_DATE(Orderdatekey, '%Y%m%d')),

    -- B. Month number
    Monthno = MONTH(STR_TO_DATE(Orderdatekey, '%Y%m%d')),

    -- C. Month full name
    Monthfullname = MONTHNAME(STR_TO_DATE(Orderdatekey, '%Y%m%d')),

    -- D. Quarter
    Quarter = CONCAT('Q', QUARTER(STR_TO_DATE(Orderdatekey, '%Y%m%d'))),

    -- E. Year-Month (YYYY-MMM)
    YearMonth = DATE_FORMAT(STR_TO_DATE(Orderdatekey, '%Y%m%d'), '%Y-%b'),

    -- F. Weekday number
    Weekdayno = DAYOFWEEK(STR_TO_DATE(Orderdatekey, '%Y%m%d')),

    -- G. Weekday name
    Weekdayname = DAYNAME(STR_TO_DATE(Orderdatekey, '%Y%m%d')),

    -- H. Financial Month
    FinancialMonth = CASE 
        WHEN MONTH(STR_TO_DATE(Orderdatekey, '%Y%m%d')) >= 4 
        THEN MONTH(STR_TO_DATE(Orderdatekey, '%Y%m%d')) - 3 
        ELSE MONTH(STR_TO_DATE(Orderdatekey, '%Y%m%d')) + 9 
    END,

    -- I. Financial Quarter
    FinancialQuarter = CASE 
        WHEN MONTH(STR_TO_DATE(Orderdatekey, '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(Orderdatekey, '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(Orderdatekey, '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END;
    
select * from sales;

-- Q4
ALTER TABLE Sales
ADD COLUMN Sales_Amount DECIMAL(10, 2);

UPDATE Sales
SET Sales_Amount = (UnitPrice * OrderQuantity) * (1 - DiscountAmount);

-- Q5
ALTER TABLE Sales
ADD COLUMN Production_Cost DECIMAL(10, 2);

UPDATE Sales
SET Production_Cost = ProductStandardCost * OrderQuantity;

-- Q6
ALTER TABLE Sales
ADD COLUMN Profit DECIMAL(10, 2);

UPDATE Sales
SET Profit = Sales_Amount - (Production_Cost + TaxAmt + Freight);

-- Q7
select Monthfullname, Sales_Amount from sales;

-- Q8
select Year, Sales_Amount from sales;

-- Q9
select Monthfullname, Sales_Amount from sales;

-- Q10
select Quarter, Sales_Amount from sales;

-- Q11
select Sales_Amount, Production_Cost from sales;

-- Q12
select EnglishProductName, Sales_Amount from sales

