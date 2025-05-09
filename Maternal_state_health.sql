-- SELECT *  FROM MaternityMortality.`maternal_health-state-mysql`;

/*  Note
Elective delivery is when a baby is delivered by choice rather than because of a medical need. 
This can happen through planned procedures, like a scheduled C-section or induction, usually decided in advance by the mother and doctor.
Elective deliveries are often scheduled for convenience or personal reasons but 
are ideally done when the baby is at least 39 weeks along to make sure the baby is fully developed and healthy.
*/

/* Note
PC-01 (Perinatal Care Measure 01) measures the rate of elective deliveries performed before 39 weeks of pregnancy without a medical reason.
It tracks how often hospitals avoid early, non-medically necessary deliveries. 
Keeping this rate low is important because babies delivered before 39 weeks can face more health risks, like breathing problems or developmental issues. 
So, a lower PC-01 rate generally indicates better adherence to recommended care practices for maternal and newborn health.
*/

-- Data Cleaning >>>>>>

-- Delete unneed coulmns from the data first.


/* 
ALTER TABLE MaternityMortality.`maternal_health-state-mysql` 
DROP COLUMN `Score`,
DROP COLUMN `Footnote`,
DROP COLUMN `Start Date`,
DROP COLUMN `End Date`;
*/ 


/*
SELECT COUNT(state)
FROM MaternityMortality.`maternal_health-state-mysql`;
*/

-- Output > 56

/*
SELECT state, COUNT(*) AS Count
FROM MaternityMortality.`maternal_health-state-mysql`
GROUP BY state
HAVING Count > 1;
*/

-- Output > No duplicates

/*
SELECT COUNT(state)
FROM MaternityMortality.`maternal_health-state-mysql`;
*/

-- Output still 56


-- Note  Create a new column 
/*
ALTER TABLE MaternityMortality.`maternal_health-state-mysql` 
ADD COLUMN `Territory` text;
*/


/* #1 GU
Disable safe updates
SET SQL_SAFE_UPDATES = 0;

UPDATE MaternityMortality.`maternal_health-state-mysql`
SET `Territory` = 'Guam'
WHERE `state` = 'GU';

Optionally, re-enable safe updates after your operation
SET SQL_SAFE_UPDATES = 1;
*/


/* #2 PR
Disable safe updates
SET SQL_SAFE_UPDATES = 0;

UPDATE MaternityMortality.`maternal_health-state-mysql`
SET `Territory` = 'Puerto Rico'
WHERE `state` = 'PR';

Optionally, re-enable safe updates after your operation
SET SQL_SAFE_UPDATES = 1;
*/


/* #3 AS
Disable safe updates
SET SQL_SAFE_UPDATES = 0;

Your update query
UPDATE MaternityMortality.`maternal_health-state-mysql`
SET `Territory` = 'American Samoa'
WHERE `state` = 'AS';


Optionally, re-enable safe updates after your operation
SET SQL_SAFE_UPDATES = 1;
*/


/* #4 MP
Disable safe updates
SET SQL_SAFE_UPDATES = 0;

UPDATE MaternityMortality.`maternal_health-state-mysql`
SET `Territory` = 'Northern Mariana Islands'
WHERE `state` = 'MP';

Optionally, re-enable safe updates after your operation
SET SQL_SAFE_UPDATES = 1;
*/


/* Handle the NULL Value
SELECT COALESCE(`Territory`, '') AS column_alias
FROM MaternityMortality.`maternal_health-state-mysql`;
*/


/* Only show the territories
SELECT *
FROM MaternityMortality.`maternal_health-state-mysql`
WHERE Territory IS NOT NULL;
*/


/* Only show the states minus the territories
SELECT State, `Measure ID`,`Measure Name`
FROM MaternityMortality.`maternal_health-state-mysql`
WHERE Territory IS NULL;
*/

