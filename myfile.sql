CREATE TABLE zomato_data (
    RestaurantID INT,
    RestaurantName VARCHAR(255),
    CountryCode INT,
    CountryName VARCHAR(255),
    City VARCHAR(255),
    Address VARCHAR(500),
    Locality VARCHAR(255),
    LocalityVerbose VARCHAR(255),
    Longitude FLOAT,
    Latitude FLOAT,
    Cuisines VARCHAR(500),
    Currency VARCHAR(100),
    Has_Table_booking VARCHAR(10),
    Has_Online_delivery VARCHAR(10),
    Is_delivering_now VARCHAR(10),
    Switch_to_order_menu VARCHAR(10),
    Price_range INT,
    Votes INT,
    Average_Cost_for_two INT,
    Rating FLOAT,
    YearOpening INT,
    MonthOpening INT,
    DayOpening INT,
    USD_RATE FLOAT
);
show variables like "local_infile";
set global local_infile=1;
LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Zomato.csv'
INTO TABLE zomato_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select*from zomato_data;

CREATE TABLE CalendarTable (
    Datekey_Opening DATE PRIMARY KEY,  -- The full date (generated from Year, Month, Day)
    Year INT,                          -- A. Year
    Monthno INT,                       -- B. Month Number
    Monthfullname VARCHAR(20),         -- C. Month Full Name
    Quarter VARCHAR(2),                -- D. Quarter (Q1, Q2, Q3, Q4)
    YearMonth VARCHAR(7),              -- E. YearMonth (YYYY-MMM)
    Weekdayno INT,                     -- F. Weekday Number (1 = Sunday, 7 = Saturday)
    Weekdayname VARCHAR(10),           -- G. Weekday Name
    FinancialMonth VARCHAR(3),         -- H. Financial Month
    FinancialQuarter VARCHAR(4)        -- I. Financial Quarter
);

INSERT INTO CalendarTable (Datekey_Opening, Year, Monthno, Monthfullname, Quarter, YearMonth, Weekdayno, Weekdayname, FinancialMonth, FinancialQuarter)
SELECT 
    STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d') AS Datekey_Opening,  -- Combine Year, Month, Day into a date
    `YearOpening` AS Year,                -- A. Year
    `MonthOpening` AS Monthno,            -- B. Month Number
    MONTHNAME(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d')) AS Monthfullname,  -- C. Month Full Name
    CONCAT('Q', QUARTER(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d'))) AS Quarter, -- D. Quarter
    CONCAT(`YearOpening`, '-', LEFT(MONTHNAME(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d')), 3)) AS YearMonth, -- E. YearMonth (YYYY-MMM)
    DAYOFWEEK(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d')) AS Weekdayno,  -- F. Weekday Number
    DAYNAME(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d')) AS Weekdayname,  -- G. Weekday Name
    CASE                                        -- H. Financial Month (April = FM1, ..., March = FM12)
        WHEN `MonthOpening` = 4 THEN 'FM1'
        WHEN `MonthOpening` = 5 THEN 'FM2'
        WHEN `MonthOpening` = 6 THEN 'FM3'
        WHEN `MonthOpening` = 7 THEN 'FM4'
        WHEN `MonthOpening` = 8 THEN 'FM5'
        WHEN `MonthOpening` = 9 THEN 'FM6'
        WHEN `MonthOpening` = 10 THEN 'FM7'
        WHEN `MonthOpening` = 11 THEN 'FM8'
        WHEN `MonthOpening` = 12 THEN 'FM9'
        WHEN `MonthOpening` = 1 THEN 'FM10'
        WHEN `MonthOpening` = 2 THEN 'FM11'
        WHEN `MonthOpening` = 3 THEN 'FM12'
    END AS FinancialMonth,
    CASE                                        -- I. Financial Quarter (Based on Financial Month)
        WHEN `MonthOpening` IN (4, 5, 6) THEN 'FQ1'
        WHEN `MonthOpening` IN (7, 8, 9) THEN 'FQ2'
        WHEN `MonthOpening` IN (10, 11, 12) THEN 'FQ3'
        WHEN `MonthOpening` IN (1, 2, 3) THEN 'FQ4'
    END AS FinancialQuarter
FROM zomato_data;

INSERT IGNORE INTO CalendarTable (Datekey_Opening, Year, Monthno, Monthfullname, Quarter, YearMonth, Weekdayno, Weekdayname, FinancialMonth, FinancialQuarter)
SELECT 
    STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d') AS Datekey_Opening,  
    `YearOpening` AS Year,                
    `MonthOpening` AS Monthno,            
    MONTHNAME(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d')) AS Monthfullname,  
    CONCAT('Q', QUARTER(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d'))) AS Quarter,
    CONCAT(`YearOpening`, '-', LEFT(MONTHNAME(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d')), 3)) AS YearMonth,  
    DAYOFWEEK(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d')) AS Weekdayno,  
    DAYNAME(STR_TO_DATE(CONCAT(`YearOpening`, '-', `MonthOpening`, '-', `DayOpening`), '%Y-%m-%d')) AS Weekdayname,  
    CASE                                        
        WHEN `MonthOpening` = 4 THEN 'FM1'
        WHEN `MonthOpening` = 5 THEN 'FM2'
        WHEN `MonthOpening` = 6 THEN 'FM3'
        WHEN `MonthOpening` = 7 THEN 'FM4'
        WHEN `MonthOpening` = 8 THEN 'FM5'
        WHEN `MonthOpening` = 9 THEN 'FM6'
        WHEN `MonthOpening` = 10 THEN 'FM7'
        WHEN `MonthOpening` = 11 THEN 'FM8'
        WHEN `MonthOpening` = 12 THEN 'FM9'
        WHEN `MonthOpening` = 1 THEN 'FM10'
        WHEN `MonthOpening` = 2 THEN 'FM11'
        WHEN `MonthOpening` = 3 THEN 'FM12'
    END AS FinancialMonth,
    CASE                                        
        WHEN `MonthOpening` IN (4, 5, 6) THEN 'FQ1'
        WHEN `MonthOpening` IN (7, 8, 9) THEN 'FQ2'
        WHEN `MonthOpening` IN (10, 11, 12) THEN 'FQ3'
        WHEN `MonthOpening` IN (1, 2, 3) THEN 'FQ4'
    END AS FinancialQuarter
FROM zomato_data;

select*from calendartable;

SELECT
    (Average_Cost_for_two * 0.012) AS Average_Cost_for_two_in_USD
FROM zomato_data;

SELECT 
    CountryName, 
    COUNT(*) AS Number_of_Restaurants
FROM zomato_data
GROUP BY  CountryName
ORDER BY Number_of_Restaurants DESC;

SELECT 
    City, 
    COUNT(*) AS Number_of_Restaurants
FROM zomato_data
GROUP BY  City
ORDER BY Number_of_Restaurants DESC;

SELECT 
    YearOpening, 
    COUNT(*) AS Number_of_Restaurants
FROM zomato_data
GROUP BY YearOpening
ORDER BY YearOpening;

SELECT 
    YearOpening, 
    QUARTER(STR_TO_DATE(CONCAT(YearOpening, '-', MonthOpening, '-01'), '%Y-%m-%d')) AS Quarter,
    COUNT(*) AS Number_of_Restaurants
FROM zomato_data
GROUP BY YearOpening, Quarter
ORDER BY YearOpening, Quarter;

SELECT 
    YearOpening, 
    MonthOpening, 
    COUNT(*) AS Number_of_Restaurants
FROM zomato_data
GROUP BY YearOpening, MonthOpening
ORDER BY YearOpening, MonthOpening;

SELECT 
    Rating,
    COUNT(*) AS Restaurant_Count
FROM zomato_data
GROUP BY Rating
ORDER BY Rating DESC;

SELECT 
    CASE 
        WHEN Average_Cost_for_two < 50 THEN 'Under $50'
        WHEN Average_Cost_for_two BETWEEN 50 AND 100 THEN '$50 - $100'
        WHEN Average_Cost_for_two BETWEEN 101 AND 200 THEN '$101 - $200'
        WHEN Average_Cost_for_two BETWEEN 201 AND 300 THEN '$201 - $300'
        WHEN Average_Cost_for_two BETWEEN 301 AND 500 THEN '$301 - $500'
        WHEN Average_Cost_for_two > 500 THEN 'Above $500'
        ELSE 'Unknown'
    END AS Price_Bucket,
    COUNT(*) AS Restaurant_Count
FROM zomato_data
GROUP BY Price_Bucket
ORDER BY Price_Bucket;

SELECT 
    Has_Table_booking,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato_data) AS Percentage_Restaurants
FROM zomato_data
GROUP BY Has_Table_booking;

SELECT 
    Has_Online_delivery,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato_data) AS Percentage_Restaurants
FROM zomato_data
GROUP BY Has_Online_delivery;




