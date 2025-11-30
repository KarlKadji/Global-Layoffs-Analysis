-- Exploratory Data Analysis

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

-- This is telling me that the largest number of people laid off from a company was 12000, and that was 100% of the employees in the company

select *
from layoffs_staging2
where percentage_laid_off = 1;

-- The results show that all these companies have laid off 100% of their employees

select *
from layoffs_staging2
order by funds_raised_millions desc;

-- The results show the amount of funds raised by these companies in millions of dollars

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

-- The results show that Britishvolt was the highest fundraiser with a 100% layoff

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- The results show the sum of total layoffs by company. We can see Amazon, Google, and Meta are among the top 10

select min(`date`), max(`date`)
from layoffs_staging2;

-- I want to see the date range of these lay-offs, and it seems like it's almost exactly 3 years from March 2020 to March 2023
-- good to remember these are peak COVID times

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- I can see that consumer, retail, and transportation were all amongst the top 10 of the most industry layoffs
-- This would make sense, as during COVID, all of those industries financially regressed

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- The United States is leading the table with the largest number of layoffs by far

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

-- the largest number of lay-offs happened in 2022, then in 2023
-- keep in mind this is only 3 months of data into 2023

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- most layoffs are coming from IPO's

select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- The percentage laid off is not very relevant because it is specific to each company

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

-- This is to see the total amount of layoffs per month

with rolling_total as
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off, sum(total_off) over(order by `month`) as ROLLING_TOTAL
from rolling_total;

-- The rolling total results show that:
-- 2021 was the best year in terms of layoffs
-- The end of 2022 and the beginning of 2023 were the worst

select company, Year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
order by company asc;

-- This is to see the total layoffs per year of each company

select company, Year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
order by 3 desc;

-- The results show that Google had the most layoffs in general in 2023
-- I want to see the top 5 total layoffs per year per company and give them a rank
-- dense rank was used because some are tied


with company_year (company, years, total_laid_off) as
(
select company, Year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
), 
company_year_rank as
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not NULL
)
select*
from Company_Year_Rank
where Ranking <= 5
;





























