-- Step 1: Inspect the original dataset
SELECT * 
FROM yearly_housing_raw;

-- Step 2: Create a cleaned table to store processed data
CREATE TABLE cleaned_housing_data AS 
SELECT * 
FROM yearly_housing_raw;

-- Step 3: Remove unnecessary columns
ALTER TABLE cleaned_housing_data 
DROP COLUMN no_of_houses, 
DROP COLUMN area_size, 
DROP COLUMN life_satisfaction;

-- Step 4: Replace invalid data in mean_salary and recycling_pct
UPDATE cleaned_housing_data
SET mean_salary = NULL
WHERE mean_salary = '-' OR mean_salary = '#';

UPDATE cleaned_housing_data
SET recycling_pct = NULL
WHERE recycling_pct = '' OR recycling_pct = 'na';

-- Step 5: Remove rows where both salary fields are NULL
DELETE FROM cleaned_housing_data
WHERE median_salary IS NULL AND mean_salary IS NULL;

-- Step 6: Identify and replace non-numeric values with NULL in salary and recycling columns
SELECT * 
FROM cleaned_housing_data
WHERE median_salary NOT REGEXP '^[0-9]+(\.[0-9]+)?$'
   OR mean_salary NOT REGEXP '^[0-9]+(\.[0-9]+)?$'
   OR recycling_pct NOT REGEXP '^[0-9]+(\.[0-9]+)?$';

UPDATE cleaned_housing_data
SET median_salary = NULL
WHERE median_salary NOT REGEXP '^[0-9]+(\.[0-9]+)?$';

UPDATE cleaned_housing_data
SET mean_salary = NULL
WHERE mean_salary NOT REGEXP '^[0-9]+(\.[0-9]+)?$';

UPDATE cleaned_housing_data
SET recycling_pct = NULL
WHERE recycling_pct NOT REGEXP '^[0-9]+(\.[0-9]+)?$';

-- Step 7: Convert salary and recycling percentage to numeric types
ALTER TABLE cleaned_housing_data
MODIFY median_salary DECIMAL(10, 2),
MODIFY mean_salary DECIMAL(10, 2),
MODIFY recycling_pct DECIMAL(5, 2);

-- Step 8: Convert date column to proper DATE type in MySQL
ALTER TABLE cleaned_housing_data
MODIFY COLUMN date DATE;

-- If necessary, update the format of the date column
UPDATE cleaned_housing_data
SET date = STR_TO_DATE(date, '%Y-%m-%d');

-- Step 9: Add an auto-incremented ID column for managing duplicates
ALTER TABLE cleaned_housing_data
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

-- Step 10: Remove duplicate rows by keeping the row with the lowest ID
DELETE t1 
FROM cleaned_housing_data t1
JOIN cleaned_housing_data t2 
ON t1.code = t2.code
   AND t1.date = t2.date
   AND t1.id > t2.id;

-- Step 11: Remove non-borough regions from the dataset
DELETE FROM cleaned_housing_data
WHERE area IN ('england', 'scotland', 'wales', 'northern ireland', 
               'united kingdom', 'great britain', 'england and wales',
               'inner london', 'outer london', 'north east', 'north west', 
               'yorkshire and the humber', 'east midlands', 'west midlands', 
               'east', 'london', 'south east', 'south west');

-- Step 12: Trim extra spaces and ensure area names are in lowercase
UPDATE cleaned_housing_data
SET area = TRIM(LOWER(area));

-- Step 13: Remove rows with missing or non-meaningful data
DELETE FROM cleaned_housing_data
WHERE median_salary IS NULL 
   OR mean_salary IS NULL 
   OR population_size IS NULL;

-- Step 14: Convert salary and recycling_pct columns to integers for Tableau visualization
ALTER TABLE cleaned_housing_data
MODIFY COLUMN median_salary INT;

ALTER TABLE cleaned_housing_data
MODIFY COLUMN mean_salary INT;

-- Final check of distinct areas to ensure cleaning was successful
SELECT DISTINCT area
FROM cleaned_housing_data;

-- Final check of cleaned dataset
SELECT * 
FROM cleaned_housing_data;

SELECT *
FROM yearly_housing_raw;