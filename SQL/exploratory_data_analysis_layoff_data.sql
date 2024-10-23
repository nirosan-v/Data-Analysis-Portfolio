-- Exploratory Data Analysis: Analysing layoffs data to identify trends and insights

-- Select all records from the cleaned layoffs data
SELECT *
FROM layoffs_cleaned;        #percentage laid off isn't very informative without company size

-- Convert columns to appropriate data types for analysis
ALTER TABLE layoffs_cleaned  
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_cleaned  
MODIFY COLUMN funds_raised_millions INT;

-- Retrieve the maximum values for total layoffs and percentage laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off) #1 means 100%
FROM layoffs_cleaned;

-- Identify companies with 100% layoffs
SELECT *
FROM layoffs_cleaned
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; 

-- Identify companies with 100% layoffs, ordered by funds raised
SELECT *
FROM layoffs_cleaned
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;  

-- Group total layoffs by company and order by total laid off
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
GROUP BY company
ORDER BY total_laid_off DESC; 

-- Retrieve the minimum and maximum dates in the dataset
SELECT MIN(`date`) AS earliest_date, MAX(`date`) AS latest_date
FROM layoffs_cleaned;

-- Group total layoffs by industry and order by total laid off
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
GROUP BY industry
ORDER BY total_laid_off DESC;  

-- Group total layoffs by country and order by total laid off
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
GROUP BY country
ORDER BY total_laid_off DESC;  

-- Group total layoffs by year and order by year
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
GROUP BY YEAR(`date`)
ORDER BY year DESC;  # Order by year in descending order (2023 has only three months of data)

-- Group total layoffs by stage of the layoffs process
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
GROUP BY stage
ORDER BY total_laid_off DESC;  

-- Group total percentage laid off by company (not very relevant)
SELECT company, SUM(percentage_laid_off) AS total_percentage_laid_off
FROM layoffs_cleaned
GROUP BY company
ORDER BY total_percentage_laid_off DESC; 

-- Analyzing trends over time: Monthly layoffs
SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL  # Filter for valid months
GROUP BY `month`
ORDER BY `month`;  # Order by month

-- CTE to calculate rolling totals of layoffs by month
WITH Rolling_Total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_off
    FROM layoffs_cleaned
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL  # Filter for valid months
    GROUP BY `month`
    ORDER BY `month` ASC
)
SELECT `month`, total_off,
    SUM(total_off) OVER (ORDER BY `month`) AS rolling_total  # Calculate rolling total of layoffs
FROM Rolling_Total;  # Results show increasing trend over time

-- Company layoffs sorted by total laid off
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
GROUP BY company
ORDER BY total_laid_off DESC;  # Order by total laid off in descending order

-- Company layoffs sorted by year
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;  

-- Company layoffs sorted by year and total laid off
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_cleaned
GROUP BY company, YEAR(`date`)
ORDER BY total_laid_off DESC;  

-- CTE to rank companies by layoffs per year
WITH Company_year AS (
    SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_cleaned
    GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking  # Rank companies by total layoffs
    FROM Company_year
    WHERE year IS NOT NULL
    ORDER BY year ASC
)

-- Select top 5 companies with the highest layoffs per year
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;  # Filter for top 5 companies