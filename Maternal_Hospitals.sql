
-- SELECT *
-- FROM maternal_hospitals;


-- Deleting unnecessary columns > footnote, start date, and end date

-- Note > Have to use backticks ` ` for the column names.
/*
ALTER TABLE maternal_hospitals
DROP COLUMN `Footnote`,
DROP COLUMN `Start Date`,
DROP COLUMN `End Date`;
*/


-- Counting how many lines od data their is before I check for duplicates.
/*
SELECT COUNT(*)
FROM maternal_hospitals;
*/ 
-- 13740 rows


-- Checking for exact duplicates
/*
SELECT 
    `Facility ID`, 
    `Facility Name`, 
    `Address`, 
    `City/Town`, 
    `State`, 
    `ZIP Code`, 
    `County/Parish`, 
    `Telephone Number`, 
    `Measure ID`, 
    `Measure Name`, 
    `Score`, 
    `Sample`, 
    COUNT(*) AS duplicate_count
FROM 
    maternal_hospitals
GROUP BY 
    `Facility ID`, 
    `Facility Name`, 
    `Address`, 
    `City/Town`, 
    `State`, 
    `ZIP Code`, 
    `County/Parish`, 
    `Telephone Number`, 
    `Measure ID`, 
    `Measure Name`, 
    `Score`, 
    `Sample` 
HAVING 
    duplicate_count > 1;
*/

-- 0 rows for exact duplicate data
-- Note > When I remore measure id, measure name, score and sample the output returns 4625 rows


-- Top 5 states with the most hospitals that participated
/*
SELECT state, COUNT(DISTINCT `facility id`) AS hospital_count
FROM maternal_hospitals
GROUP BY state
ORDER BY hospital_count DESC
LIMIT 5;
*/

-- Output TX 388, CA 326, FL 182, IL 172, OH 159 (In order, from most to least)


-- Bottom 5 states with the least hospitals that participated
/*
SELECT state, COUNT(DISTINCT `facility id`) AS hospital_count
FROM maternal_hospitals
GROUP BY state
HAVING hospital_count > 2
ORDER BY hospital_count ASC
LIMIT 5;
*/

-- Output DE 7, DC 7, RI 10, VT 14, AK 21 (In order, least to most)


-- List of Virginia Hospitals with a score of 'Yes' for Maternal Morbidity Structual Measure
/*
SELECT `state`, `facility name`, `address`, `zip code`, `measure name`, `score`
FROM maternal_hospitals
WHERE `state` = 'VA' AND `measure name` = 'Maternal Morbidity Structural Measure' AND `score` = 'Yes';
*/
-- 41

-- List of North Carolina Hospitals with a score of 'Yes' for Maternal Morbidity Structual Measure
/*
SELECT `state`, `facility name`, `address`, `zip code`, `measure name`, `score`
FROM maternal_hospitals
WHERE `state` = 'NC' AND `measure name` = 'Maternal Morbidity Structural Measure' AND `score` = 'Yes';
*/
-- 67

-- States with low MMR and Low Deaths
/*
SELECT 
    State,
    COUNT(CASE WHEN TRIM(UPPER(`Score`)) = 'YES' THEN 1 END) AS Yes_Count,
    COUNT(CASE WHEN TRIM(UPPER(`Score`)) = 'NO' THEN 1 END) AS No_Count
FROM 
    maternal_hospitals
WHERE 
    `Measure ID` = 'SM_7' 
    AND `Measure Name` = 'Maternal Morbidity Structural Measure'
    AND `State` IN ('VT', 'WY', 'SD', 'RI', 'ND', 'MT', 'ME', 'HI', 'DE', 'AK')
GROUP BY 
    State ;
*/


-- States with the highest MMR and deaths
/*
SELECT 
    State,
    COUNT(CASE WHEN TRIM(UPPER(`Score`)) = 'YES' THEN 1 END) AS Yes_Count,
    COUNT(CASE WHEN TRIM(UPPER(`Score`)) = 'NO' THEN 1 END) AS No_Count
FROM 
    maternal_hospitals
WHERE 
    `Measure ID` = 'SM_7' 
    AND `Measure Name` = 'Maternal Morbidity Structural Measure'
    AND `State` IN ('VA', 'NC', 'GA', 'NJ', 'TN','MS', 'AL', 'KY', 'LA', 'OH', 'AK', 'SC', 'IN')
GROUP BY 
    State ;
*/


-- States with low MMR but high deaths
/*
SELECT 
    State,
    COUNT(CASE WHEN TRIM(UPPER(`Score`)) = 'YES' THEN 1 END) AS Yes_Count,
    COUNT(CASE WHEN TRIM(UPPER(`Score`)) = 'NO' THEN 1 END) AS No_Count
FROM 
    maternal_hospitals
WHERE 
    `Measure ID` = 'SM_7' 
    AND `Measure Name` = 'Maternal Morbidity Structural Measure'
    AND `State` IN ('CA', 'MN', 'WV','NV', 'WI', 'UT','CT', 'CO', 'OR', 'PA', 'MA', 'ID', 'NM', 'NE' )
GROUP BY 
    State ;
*/
/*
SELECT `Score`, COUNT(*) AS total_count
FROM maternal_hospitals
GROUP BY `Score`;
*/
-- Yes 2,225
