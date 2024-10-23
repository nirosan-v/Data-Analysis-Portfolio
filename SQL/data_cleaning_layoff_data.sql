-- Creating a stageld data table for layoffs data
SELECT *
FROM layoffs_raw;

CREATE TABLE layoffs_staging
LIKE layoffs_raw;

-- Copying data from original table to raw table
INSERT INTO layoffs_staging
SELECT * 
FROM layoffs_raw;

SELECT * 
FROM layoffs_staging;

-- PART 1: Removing duplicates using ROW_NUMBER -----------------------------------------------------------------------------------------------------

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
FROM layoffs_staging;

WITH duplicate_cte AS (
  SELECT *,
         ROW_NUMBER() OVER(
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
         ) AS row_num
  FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;  -- Identify duplicate rows

-- Create a new table for cleaned layoffs data
CREATE TABLE `layoffs_cleaned` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` TEXT,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` TEXT,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Checking the table creation
SELECT *
FROM layoffs_cleaned;

-- Insert data into the cleaned table with row numbers for duplicate identification
INSERT INTO layoffs_cleaned
SELECT *, ROW_NUMBER() OVER(
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
         ) AS row_num
FROM layoffs_staging;

-- Delete duplicate rows (rows with row_num > 1)
DELETE FROM layoffs_cleaned
WHERE row_num > 1;

-- PART 2: Standardize the data (trim white spaces and correct inconsistencies) -----------------------------------------------------------------------
-- Trim white spaces around company names
SELECT company, (TRIM(company))
FROM layoffs_cleaned;

UPDATE layoffs_cleaned
SET company = TRIM(company);

-- Standardise industry names (e.g., group all variations of "Crypto" under one name)
UPDATE layoffs_cleaned
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";

-- Removing full stops in country names
UPDATE layoffs_cleaned
SET country = TRIM(TRAILING "." FROM country)
WHERE country LIKE "United States%";

-- PART 3: Fixing the date format -----------------------------------------------------------------------------------------------------------------------
-- Previewing valid dates before conversion
SELECT `date`,
       STR_TO_DATE(`date`, "%m/%d/%Y") AS standardised_date
FROM layoffs_cleaned
WHERE `date` IS NOT NULL
	AND `date` != ''
    AND `date` != 'None' 
    AND STR_TO_DATE(`date`, '%m/%d/%Y') IS NOT NULL;

-- Converting valid dates to a standardised format (YYYY-MM-DD)
UPDATE layoffs_cleaned
SET `date` = STR_TO_DATE(`date`, "%m/%d/%Y")
WHERE `date` IS NOT NULL 
	AND `date` != '' 
    AND `date` != 'None' 
    AND STR_TO_DATE(`date`, "%m/%d/%Y") IS NOT NULL;

-- Handle invalid date values by setting them to NULL
UPDATE layoffs_cleaned
SET `date` = NULL
WHERE `date` = 'None';

-- Change the layoff_date column type to DATE
ALTER TABLE layoffs_cleaned
MODIFY COLUMN `date` DATE;

-- PART 4: Handling null values and fixing missing data -----------------------------------------------------------------------------------------------
-- Check for rows with null or invalid values for total laid off and percentage laid off
SELECT *
FROM layoffs_cleaned
WHERE total_laid_off ="None"
OR percentage_laid_off ="None";

-- Join with another table to populate missing industries where possible
UPDATE layoffs_cleaned t1
JOIN layoffs_cleaned t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL) 
AND t2.industry IS NOT NULL;

-- Set empty industries to NULL
UPDATE layoffs_cleaned
SET industry = NULL
WHERE industry = "";

-- Set invalid "None" values for total laid off to NULL
UPDATE layoffs_cleaned
SET total_laid_off = NULL
WHERE total_laid_off = "None";

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = "None";

SELECT *
FROM layoffs_cleaned;

-- PART 5: Removing unnecessary columns and rows ------------------------------------------------------------------------------------------------------
-- Remove rows where both total_laid_off and percentage_laid_off are NULL
SELECT *			
FROM layoffs_cleaned 
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;

DELETE FROM layoffs_cleaned 
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;

-- Drop the row_num column used for duplicate identification
ALTER TABLE layoffs_cleaned
DROP COLUMN row_num;

-- Final check of the cleaned data
SELECT * FROM layoffs_cleaned;