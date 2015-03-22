DROP PROCEDURE IF EXISTS Test_PatientSearch;
DELIMITER @@
CREATE PROCEDURE Test_PatientSearch
(IN province VARCHAR(20), IN city VARCHAR(20), OUT num_matches INT) 
proc_label:BEGIN

SELECT 356_review.Patient_Alias, count(356_review.Review_ID) AS Review_Count, max(356_review.Date) AS MOST_RECENT_DATE
FROM 356_review
JOIN 356_patients
ON 356_review.Patient_Alias = 356_patients.Alias
WHERE 356_patients.Alias = 'USER_INPUT'

END @@ DELIMITER;