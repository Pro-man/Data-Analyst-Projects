-- US Household Income Data Cleaning

SELECT * 
FROM US_Project.US_Household_Income;

SELECT * 
FROM US_Project.US_Household_Income_Statistics;

SELECT COUNT(id) 
FROM US_Project.US_Household_Income;

SELECT COUNT(id) 
FROM US_Project.US_Household_Income_Statistics;

-- Find Duplicates

SELECT id, COUNT(id)
FROM US_Project.US_Household_Income
GROUP BY id
HAVING COUNT(id) > 1;

/*Attach row ids to duplicates*/
SELECT *
FROM (
SELECT row_id, id,
ROW_NUMBER () OVER(PARTITION BY id ORDER BY id) row_num
FROM US_Project.US_Household_Income) duplicates
WHERE row_num > 1;

/*Delete duplicates*/
DELETE FROM US_Household_Income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, id,
		ROW_NUMBER () OVER(PARTITION BY id ORDER BY id) row_num
		FROM US_Project.US_Household_Income) duplicates
	WHERE row_num > 1);
/*Seven rows were delete*/

-- Fixing State names
SELECT State_Name, COUNT(State_Name)
FROM US_Project.US_Household_Income
GROUP BY State_Name;

UPDATE US_Project.US_Household_Income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';
/*52 rows were corrected.*/

UPDATE US_Project.US_Household_Income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';
/*1 row were corrected.*/

-- Changing Field Title

ALTER TABLE US_Project.US_Household_Income_Statistics
RENAME COLUMN `sum_w` to `Sum_W`;

-- Finding Blanks

SELECT *
FROM US_Project.US_Household_Income
WHERE County = 'Autauga County'
ORDER BY 1;
/*Row_id number 32 has a blank in the Place field.*/

UPDATE US_Project.US_Household_Income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';
/*Populated the blank field.*/

SELECT Type, COUNT(Type)
FROM US_Project.US_Household_Income
GROUP By Type;

UPDATE US_Project.US_Household_Income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- Exploratory Data Analysis

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Project.US_Household_Income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;
-- Top ten states with land

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Project.US_Household_Income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;
-- Top ten states with water

SELECT *
FROM US_Project.US_Household_Income u 
JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id; 

SELECT *
FROM US_Project.US_Household_Income u 
RIGHT JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE u.id IS NULL;
-- All the data is being populated and used

SELECT *
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0;
-- Have cleaner data.

SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0;

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5;
-- Lowest household income

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;
-- Highest household income

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10;

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 ASC
LIMIT 10;

SELECT Type, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY 2 DESC
LIMIT 10;

SELECT Type,COUNT(Type), ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;

SELECT *
FROM US_Household_Income
WHERE Type = 'Community';
-- Comunities at the bottom is PR.

/* Filter outliers */
SELECT Type,COUNT(Type), ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20;

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
GROUP BY u.State_Name,City
ORDER BY ROUND(AVG(Mean), 1) DESC;

SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.US_Household_Income u 
INNER JOIN US_Project.US_Household_Income_Statistics us 
	ON u.id = us.id
GROUP BY u.State_Name,City
ORDER BY 3 DESC;