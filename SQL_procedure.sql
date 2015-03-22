/*5.2*/
DROP PROCEDURE IF EXISTS Test_PatientSearch;
DELIMITER @@
CREATE PROCEDURE Test_PatientSearch(IN province VARCHAR(20), IN city VARCHAR(20), OUT num_matches INT) 
BEGIN
    SELECT COUNT(356_patients.Alias) INTO num_matches FROM 356_patients WHERE 356_patients.Addr_City = city AND 356_patients.Addr_Province = province;
END @@ 
DELIMITER ;

/*5.3*/
DROP PROCEDURE IF EXISTS Test_DoctorSearch;
DELIMITER @@
CREATE PROCEDURE Test_DoctorSearch
(IN gender VARCHAR(20), IN city VARCHAR(20), IN specialization VARCHAR(20), IN num_years_licensed INT, OUT num_matches INT)
BEGIN
    /* returns in num_matches the total number of doctors that match exactly on all the given
    criteria: gender ('male' or 'female'), city, specialization, and number of years licensed */
    SELECT COUNT(DISTINCT 356_doctors.Alias) INTO num_matches 
    FROM 356_doctors 
    JOIN 356_work ON 356_doctors.Alias = 356_work.Doctor_Alias
    JOIN 356_offices ON 356_work.Office_ID = 356_offices.Office_ID
    JOIN 356_specialize ON 356_doctors.Alias = 356_specialize.Doctor_Alias
    JOIN 356_specialization ON 356_specialize.Specialization_ID = 356_specialization.Specialization_ID
    WHERE 356_doctors.Gender = gender AND 356_doctors.Medical_Licence_Year = YEAR(curdate())-num_years_licensed 
            AND 356_offices.City = city AND 356_specialization.Specialization_Area = specialization;
END @@
DELIMITER ;

/*5.4*/
DROP PROCEDURE IF EXISTS Test_DoctorSearchStarRating;
DELIMITER @@
CREATE PROCEDURE Test_DoctorSearchStarRating
(IN avg_star_rating FLOAT, OUT num_matches INT)
BEGIN
    /* returns in num_matches the total number of doctors whose average star rating is equal to
    or greater than the given threshold */
    SELECT COUNT(Doctor) INTO num_matches FROM (SELECT AVG(356_review.Rating) AS Average_Rating, 356_review.Doctor_Alias AS Doctor
    From 356_review GROUP BY 356_review.Doctor_Alias) AS Avg_review WHERE Avg_review.Average_Rating >= avg_star_rating;
END @@
DELIMITER ;

/*5.5*/
DROP PROCEDURE IF EXISTS Test_DoctorSearchFriendReview;
DELIMITER @@
CREATE PROCEDURE Test_DoctorSearchFriendReview
(IN patient_alias VARCHAR(20), IN review_keyword VARCHAR(20), OUT num_matches INT)
BEGIN
    /* returns in num_matches the total number of doctors who have been reviewed by friends of
    the given patient, and where at least one of the reviews for that doctor (not necessarily
    written by a friend) contains the given keyword (case-sensitive) */
    SELECT COUNT(DISTINCT doctor) INTO num_matches FROM 
        (SELECT 356_review.Doctor_Alias as doctor FROM 356_friends 
        JOIN 356_review ON 356_friends.Friend_Alias = 356_review.Patient_Alias 
        WHERE 356_friends.Alias = patient_alias) AS Review_search
            JOIN 356_review ON Review_search.doctor = 356_review.Doctor_Alias 
            WHERE 356_review.Comment like CONCAT('%', review_keyword, '%');

END @@
DELIMITER ;

/*5.6*/
DROP PROCEDURE IF EXISTS Test_RequestFriend;
DELIMITER @@
CREATE PROCEDURE Test_RequestFriend
(IN requestor_alias VARCHAR(20), IN requestee_alias VARCHAR(20))
BEGIN
/* add friendship request from requestor_alias to requestee_alias */
    /*Check if the other person sends you a request*/
    DECLARE accepted BIT;
    IF EXISTS(SELECT * 
        FROM 356_friends 
        WHERE 356_friends.Alias = requestee_alias AND 356_friends.Friend_Alias = requestor_alias) THEN
        SET accepted = 1;
        UPDATE 356_friends SET 356_friends.Friend_Accept = accepted
        WHERE 356_friends.Alias = requestee_alias AND 356_friends.Friend_Alias = requestor_alias;
    ELSE
        SET accepted = 0;
    END IF;
    /*Check if you send a request already*/
    IF NOT EXISTS ( 
                SELECT *  
                FROM 356_friends  
                WHERE 356_friends.Alias = requestor_alias AND 356_friends.Friend_Alias = requestee_alias )
    THEN
        INSERT INTO 356_friends(356_friends.Alias, 356_friends.Friend_Alias, 356_friends.Friend_Accept) 
        VALUE(requestor_alias, requestee_alias, accepted );
    END IF;
END @@
DELIMITER ;

/*5.7*/
DROP PROCEDURE IF EXISTS Test_ConfirmFriendRequest;
DELIMITER @@
CREATE PROCEDURE Test_ConfirmFriendRequest
(IN requestor_alias VARCHAR(20), IN requestee_alias VARCHAR(20))
BEGIN
    /* add friendship between requestor_alias and requestee_alias, assuming that friendship was
    requested previously */

    /*Check if the other person sends you a request*/
    DECLARE accepted BIT;
    IF EXISTS(SELECT * 
        FROM 356_friends 
        WHERE 356_friends.Alias = requestor_alias AND 356_friends.Friend_Alias = requestee_alias) THEN
        SET accepted = 1;
        UPDATE 356_friends SET 356_friends.Friend_Accept = accepted
        WHERE 356_friends.Alias = requestor_alias AND 356_friends.Friend_Alias = requestee_alias;
    ELSE
        SET accepted = 0;
    END IF;
    /*Check if you send a request already*/
    IF NOT EXISTS ( 
                    SELECT *  
                    FROM 356_friends  
                    WHERE 356_friends.Alias = requestee_alias AND 356_friends.Friend_Alias = requestor_alias ) THEN
    INSERT INTO 356_friends(356_friends.Alias, 356_friends.Friend_Alias, 356_friends.Friend_Accept)
        VALUE (requestee_alias, requestor_alias, accepted);
    END IF;
END @@
DELIMITER ;

/*5.8*/
DROP PROCEDURE IF EXISTS Test_AreFriends;
DELIMITER @@
CREATE PROCEDURE Test_AreFriends
(IN patient_alias_1 VARCHAR(20), IN patient_alias_2 VARCHAR(20), OUT are_friends INT)
BEGIN
    /* returns 1 in are_friends if patient_alias_1 and patient_alias_2 are friends, 0 otherwise */
    SELECT 356_friends.Friend_Accept INTO are_friends
    FROM 356_friends
    WHERE 356_friends.Alias = patient_alias_1 AND 356_friends.Friend_Alias = patient_alias_2;
    IF are_friends = NULL THEN
    SET are_friends = 0;
    END IF;
END @@
DELIMITER ;


/* 5.9 */
DROP PROCEDURE IF EXISTS Test_AddReview;
DELIMITER @@
CREATE PROCEDURE Test_AddReview
(IN patient_alias VARCHAR(20), IN doctor_alias VARCHAR(20), IN star_rating FLOAT, IN comments VARCHAR(256))
BEGIN
    /* add review by patient_alias for doctor_alias with the given star_rating and comments
    fields, assign the current date to the review automatically, assume that star_rating is an
    integer multiple of 0.5 (e.g., 1.5, 2.0, 2.5, etc.) */
    INSERT INTO 356_review (Doctor_Alias, Patient_Alias, Date, Rating, Comment)
    VALUES (doctor_alias, patient_alias, CURDATE(), star_rating, comments);

END @@
DELIMITER ;

/*5.10*/
DROP PROCEDURE IF EXISTS Test_CheckReviews;
DELIMITER @@
CREATE PROCEDURE Test_CheckReviews
(IN doctor_alias VARCHAR(20), OUT avg_star FLOAT, OUT num_reviews INT)
BEGIN
    /* returns the average star rating and total number of reviews for the given doctor alias */
    SELECT AVG(356_review.Rating) AS Average_Rating, COUNT(356_review.Review_ID) AS Review_Counts INTO avg_star, num_reviews
    From 356_review 
    WHERE 356_review.Doctor_Alias = doctor_alias GROUP BY 356_review.Doctor_Alias;
END @@
DELIMITER ;

