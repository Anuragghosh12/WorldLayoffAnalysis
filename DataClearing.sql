-- Data Cleaning

SELECT * 
FROM layoffs;

-- 1. Removing Duplicates
-- 2. Standardize the Data
-- 3. Null Value or Blank Values
-- 4. Remove Any Columns

CREATE TABLE layoff_staging
LIKE layoffs;	

SELECT * 
FROM layoff_staging;

INSERT layoff_staging
SELECT * 
FROM layoffs;

SELECT * 
FROM layoff_staging;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY
company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num 
FROM layoff_staging;


WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY
company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num 
FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


SELECT *
FROM layoff_staging
WHERE company = 'Oda';

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoff_staging
WHERE company = 'Casper';

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoff_staging2;

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoff_staging;	


SELECT *
FROM layoff_staging2
WHERE row_num > 1;

DELETE
FROM layoff_staging2
WHERE row_num > 1;

SELECT *
FROM layoff_staging2
WHERE row_num > 1;

SELECT *
FROM layoff_staging2;


-- Standardizing Data

SELECT company,trim(company)
FROM layoff_staging2;


UPDATE layoff_staging2
SET company=trim(company);

SELECT *
from layoff_staging2
WHERE industry like 'crypto%';

UPDATE layoff_staging2
SET industry = 'Crypto'
WHERE industry like 'crypto%';

SELECT DISTINCT industry
FROM layoff_staging2;

SELECT DISTINCT country
FROM layoff_staging2
ORDER BY 1; 

SELECT *
FROM layoff_staging2
WHERE country like 'United States%'
ORDER BY 1;

SELECT DISTINCT country, trim(trailing '.' from country)
FROM layoff_staging2
ORDER BY 1;

UPDATE layoff_staging2
SET country = trim(trailing '.' from country)
WHERE country like 'United States%';

SELECT `date`,
str_to_date(`date`,'%m/%d/%Y')
FROM layoff_staging2; 


UPDATE layoff_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoff_staging2;

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM layoff_staging2;


-- Removing NULLS

SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoff_staging2
WHERE industry is NULL
OR industry = '';

SELECT *
FROM layoff_staging2
WHERE company LIKE 'Bally%';

UPDATE layoff_staging2
SET industry = NULL
WHERE industry = '';


SELECT *
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company= t2.company
	AND t1.location=t2.location
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;    

UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company= t2.company
SET t1.industry = t2.industry    
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL; 

-- Removing Columns
DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoff_staging2
DROP COLUMN row_num;

SELECT *
FROM layoff_staging2;

