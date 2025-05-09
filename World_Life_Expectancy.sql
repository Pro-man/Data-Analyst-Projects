#World Life Expectancy Data Cleaning

SELECT * 
FROM World_Life_Expectancy.world_life_expectancy;

-- Remove Duplicates 
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM World_Life_Expectancy.world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

-- Find Duplicates Row Numbers
SELECT *
FROM (
	SELECT Row_ID,
    CONCAT(Country, Year),
    ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
    FROM world_life_expectancy) AS Row_table
WHERE Row_Num > 1;

-- Delete Duplicates
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN ( 
    SELECT Row_ID
FROM (
	SELECT Row_ID,
    CONCAT(Country, Year),
    ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
    FROM world_life_expectancy) AS Row_table
WHERE Row_Num > 1);
		
-- Find how many emppty fields I have
SELECT *
FROM world_life_expectancy
WHERE Status = '';

-- Developing status countries
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

-- Self-JOIN for developing and developed Status blanks
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

-- Format Column Names
ALTER TABLE world_life_expectancy
RENAME COLUMN `Lifeexpectancy` to `Life expectancy`;

ALTER TABLE world_life_expectancy
RENAME COLUMN `AdultMortality` to `Adult Mortality`;

ALTER TABLE world_life_expectancy
RENAME COLUMN `infantdeaths` to `Infant Deaths`;

ALTER TABLE world_life_expectancy
RENAME COLUMN `percentageexpenditure` to `Percentage Expenditure`;

ALTER TABLE world_life_expectancy
RENAME COLUMN `under-fivedeaths` to `Under-Five Deaths`;


SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy;

-- Populate blanks in Life expectancy fields with averages
SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy`= '';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = '';


-- World Life Expectancy Exploratory Data Analysis Section

SELECT *
FROM world_life_expectancy;

-- Countries that have increased their life expectancies the most
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND (MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS Life_Increase_15_years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_years DESC;

-- Average Life expetancy by Year
SELECT YEAR, ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0 AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year;
/* Increased 4.87 years from 2007 to 2022 for the whole world */

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC;
/* Qatar, Luxembourg, and Switzerland are at the top of the list. 
Only Australia and Canada aare the large countries that are near thne top of the list. 
Countries that have lower life expectancies have lower GDPs*/

-- High Correlation between GDP and Life Expetancy
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy;
/* Average age for high GDP Countries is 74.
   Average age for low GDP Countries is 65. */
   
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status;
/* Average age for Developing countires is 66. Thereare 161 developing countries.
   Average age for Developed countires is 79. There are 32 developed countries.*/
   
-- BMI & Life Expectancy
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC;
-- Low BMI lower Life Expectancy

-- Rolling Total (Add year after year)
-- Window Function
SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY YEAR) AS Rolling_total
FROM world_life_expectancy
WHERE Country LIKE '%United%';
-- United States deaths total is 931 from 2007 - 2022.










