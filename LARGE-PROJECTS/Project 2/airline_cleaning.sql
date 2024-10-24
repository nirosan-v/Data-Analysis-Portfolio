-- Select all records from the raw airline data
SELECT *
FROM airline_data_raw;

-- Create a staging table with the same structure as the original table
CREATE TABLE airline_staged 
LIKE airline_data_raw;

-- Copy data from the original table to the staging table
INSERT INTO airline_staged
SELECT * 
FROM airline_data_raw;

-- Drop unnecessary columns from the staging table
ALTER TABLE airline_staged
DROP COLUMN WORK_CITY;

ALTER TABLE airline_staged
DROP COLUMN LOAD_TIME;

-- Display the contents of the staging table after modifications
SELECT *
FROM airline_staged;

-- Trim whitespace from specified columns in the staging table
UPDATE airline_staged
SET 
    MEMBER_NO = TRIM(MEMBER_NO),
    FFP_DATE = TRIM(FFP_DATE),
    FIRST_FLIGHT_DATE = TRIM(FIRST_FLIGHT_DATE),
    GENDER = TRIM(GENDER),
    FFP_TIER = TRIM(FFP_TIER),
    WORK_CITY = TRIM(WORK_CITY),
    WORK_PROVINCE = TRIM(WORK_PROVINCE),
    WORK_COUNTRY = TRIM(WORK_COUNTRY),
    AGE = TRIM(AGE),
    LOAD_TIME = TRIM(LOAD_TIME),
    FLIGHT_COUNT = TRIM(FLIGHT_COUNT),
    BP_SUM = TRIM(BP_SUM),
    SUM_YR_1 = TRIM(SUM_YR_1),
    SUM_YR_2 = TRIM(SUM_YR_2),
    SEG_KM_SUM = TRIM(SEG_KM_SUM),
    LAST_FLIGHT_DATE = TRIM(LAST_FLIGHT_DATE),
    LAST_TO_END = TRIM(LAST_TO_END),
    AVG_INTERVAL = TRIM(AVG_INTERVAL),
    MAX_INTERVAL = TRIM(MAX_INTERVAL),
    EXCHANGE_COUNT = TRIM(EXCHANGE_COUNT),
    avg_discount = TRIM(avg_discount),
    Points_Sum = TRIM(Points_Sum),
    Point_NotFlight = TRIM(Point_NotFlight);

-- Display the contents of the staging table after trimming
SELECT *
FROM airline_staged;

-- Remove rows with unwanted symbols in WORK_PROVINCE and WORK_COUNTRY
DELETE FROM airline_staged
WHERE 
    WORK_PROVINCE REGEXP "[0-9#\\-\\*\\.,!]";

DELETE FROM airline_staged
WHERE 
    WORK_COUNTRY REGEXP "[0-9#\\-\\*\\.,!]";

-- Remove rows with empty or null critical fields
DELETE FROM airline_staged
WHERE 
    TRIM(MEMBER_NO) = '' OR TRIM(MEMBER_NO) = 'None' OR MEMBER_NO IS NULL OR
    TRIM(FFP_DATE) = '' OR TRIM(FFP_DATE) = 'None' OR FFP_DATE IS NULL OR
    TRIM(FIRST_FLIGHT_DATE) = '' OR TRIM(FIRST_FLIGHT_DATE) = 'None' OR FIRST_FLIGHT_DATE IS NULL OR
    TRIM(GENDER) = '' OR TRIM(GENDER) = 'None' OR GENDER IS NULL OR
    TRIM(FFP_TIER) = '' OR TRIM(FFP_TIER) = 'None' OR FFP_TIER IS NULL OR
    TRIM(WORK_PROVINCE) = '' OR TRIM(WORK_PROVINCE) = 'None' OR WORK_PROVINCE IS NULL OR
    TRIM(WORK_COUNTRY) = '' OR TRIM(WORK_COUNTRY) = 'None' OR WORK_COUNTRY IS NULL OR
    TRIM(AGE) = '' OR TRIM(AGE) = 'None' OR AGE IS NULL OR
    TRIM(LOAD_TIME) = '' OR TRIM(LOAD_TIME) = 'None' OR LOAD_TIME IS NULL OR
    TRIM(FLIGHT_COUNT) = '' OR TRIM(FLIGHT_COUNT) = 'None' OR FLIGHT_COUNT IS NULL OR
    TRIM(BP_SUM) = '' OR TRIM(BP_SUM) = 'None' OR BP_SUM IS NULL OR
    TRIM(SUM_YR_1) = '' OR TRIM(SUM_YR_1) = 'None' OR SUM_YR_1 IS NULL OR
    TRIM(SUM_YR_2) = '' OR TRIM(SUM_YR_2) = 'None' OR SUM_YR_2 IS NULL OR
    TRIM(SEG_KM_SUM) = '' OR TRIM(SEG_KM_SUM) = 'None' OR SEG_KM_SUM IS NULL OR
    TRIM(LAST_FLIGHT_DATE) = '' OR TRIM(LAST_FLIGHT_DATE) = 'None' OR LAST_FLIGHT_DATE IS NULL OR
    TRIM(LAST_TO_END) = '' OR TRIM(LAST_TO_END) = 'None' OR LAST_TO_END IS NULL OR
    TRIM(AVG_INTERVAL) = '' OR TRIM(AVG_INTERVAL) = 'None' OR AVG_INTERVAL IS NULL OR
    TRIM(MAX_INTERVAL) = '' OR TRIM(MAX_INTERVAL) = 'None' OR MAX_INTERVAL IS NULL OR
    TRIM(EXCHANGE_COUNT) = '' OR TRIM(EXCHANGE_COUNT) = 'None' OR EXCHANGE_COUNT IS NULL OR
    TRIM(avg_discount) = '' OR TRIM(avg_discount) = 'None' OR avg_discount IS NULL OR
    TRIM(Points_Sum) = '' OR TRIM(Points_Sum) = 'None' OR Points_Sum IS NULL OR
    TRIM(Point_NotFlight) = '' OR TRIM(Point_NotFlight) = 'None' OR Point_NotFlight IS NULL;

-- Display the contents of the staging table after deletions
SELECT *
FROM airline_staged;

-- Delete rows from airline_staged where WORK_PROVINCE contains unwanted characters
DELETE FROM airline_staged
WHERE WORK_PROVINCE REGEXP '[^A-Z ]';  -- Keeps only uppercase letters and spaces

-- Replace invalid data with NULL in AGE and other numeric fields
UPDATE airline_staged
SET AGE = NULL
WHERE AGE < 0 OR AGE > 100;  -- Assuming age should be within a reasonable range

-- Convert WORK_PROVINCE values to uppercase for consistency
UPDATE airline_staged
SET WORK_PROVINCE = UPPER(WORK_PROVINCE);

-- Remove invalid date records from the staging table
DELETE FROM airline_staged
WHERE LAST_FLIGHT_DATE LIKE '%2014/2/29%'; -- Invalid date, not real

-- Convert date columns to a proper date format
UPDATE airline_staged
SET 
    FFP_DATE = STR_TO_DATE(FFP_DATE, '%m/%d/%Y'),
    FIRST_FLIGHT_DATE = STR_TO_DATE(FIRST_FLIGHT_DATE, '%m/%d/%Y'),
    LAST_FLIGHT_DATE = STR_TO_DATE(LAST_FLIGHT_DATE, '%m/%d/%Y');

-- Modify the data types of specific columns for better accuracy
ALTER TABLE airline_staged
MODIFY COLUMN FFP_DATE DATE,
MODIFY COLUMN FIRST_FLIGHT_DATE DATE,
MODIFY COLUMN LAST_FLIGHT_DATE DATE,
MODIFY COLUMN AGE INT,
MODIFY COLUMN SUM_YR_1 INT,
MODIFY COLUMN SUM_YR_2 INT,
MODIFY COLUMN avg_discount DECIMAL(10, 5),
MODIFY COLUMN avg_interval DECIMAL(10, 5);

-- Display the final contents of the staging table
SELECT *
FROM airline_staged;

SELECT * 
FROM airline_data_raw 
ORDER BY MEMBER_NO;

SELECT * 
FROM airline_staged
ORDER BY MEMBER_NO;