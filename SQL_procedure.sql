/* 5.1 */
DROP PROCEDURE IF EXISTS Test_ResetDB; DELIMITER @@
CREATE PROCEDURE Test_ResetDB () BEGIN

DROP TABLE IF EXISTS 356_specialize;
DROP TABLE IF EXISTS 356_work;
DROP TABLE IF EXISTS 356_friends;
DROP TABLE IF EXISTS 356_review;

DROP TABLE IF EXISTS 356_doctors;
CREATE TABLE 356_doctors (
  Alias varchar(64) NOT NULL,
  Salt varchar(128) NOT NULL,
  Password varchar(128) NOT NULL,
  First_Name varchar(64) NOT NULL,
  Last_Name varchar(64) NOT NULL,
  Email varchar(64) NOT NULL,
  Gender varchar(10) NOT NULL,
  Medical_Licence_Year int(100) NOT NULL DEFAULT '0',
  PRIMARY KEY (Alias)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS 356_patients;
CREATE TABLE 356_patients (
  Alias varchar(64) NOT NULL,
  Salt varchar(128) NOT NULL,
  Password varchar(128) NOT NULL,
  First_Name varchar(64) NOT NULL,
  Last_Name varchar(64) NOT NULL,
  Email varchar(64) NOT NULL,
  Addr_City varchar(64) NOT NULL,
  Addr_Province varchar(64) NOT NULL,
  PRIMARY KEY (Alias)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS 356_specialization;
CREATE TABLE 356_specialization (
  Specialization_ID int(11) NOT NULL AUTO_INCREMENT,
  Specialization_Area varchar(32) NOT NULL,
  PRIMARY KEY (Specialization_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS 356_offices;
CREATE TABLE 356_offices (
  Office_ID int(11) NOT NULL AUTO_INCREMENT,
  St_Number int(11) NOT NULL,
  St_Name varchar(64) NOT NULL,
  St_Type varchar(64) NOT NULL,
  Postal_Code_pre varchar(3) NOT NULL,
  Postal_Code_suff varchar(3) NOT NULL,
  City varchar(32) NOT NULL,
  Province varchar(32) NOT NULL,
  PRIMARY KEY (Office_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE 356_specialize (
  Specialization_ID int(11) NOT NULL,
  Doctor_Alias varchar(64) NOT NULL,
  KEY Doctors_idx (Doctor_Alias),
  KEY Specializations_idx (Specialization_ID),
  CONSTRAINT Doctors FOREIGN KEY (Doctor_Alias) REFERENCES 356_doctors (Alias) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Specializations FOREIGN KEY (Specialization_ID) REFERENCES 356_specialization (Specialization_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE 356_work (
  Doctor_Alias varchar(64) NOT NULL,
  Office_ID int(11) DEFAULT NULL,
  KEY Doctor_idx (Doctor_Alias),
  KEY Office_idx (Office_ID),
  CONSTRAINT Doctor_At_Work FOREIGN KEY (Doctor_Alias) REFERENCES 356_doctors (Alias) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT Office FOREIGN KEY (Office_ID) REFERENCES 356_offices (Office_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE 356_friends (
  Alias varchar(64) NOT NULL,
  Friend_Alias varchar(64) NOT NULL,
  Friend_Accept bit(1) NOT NULL,
  KEY Self_idx (Alias),
  KEY Friend_idx (Friend_Alias),
  CONSTRAINT Friend FOREIGN KEY (Friend_Alias) REFERENCES 356_patients (Alias) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Self FOREIGN KEY (Alias) REFERENCES 356_patients (Alias) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE 356_review (
  Review_ID int(11) NOT NULL AUTO_INCREMENT,
  Patient_Alias varchar(64) DEFAULT NULL,
  Doctor_Alias varchar(64) NOT NULL,
  Rating tinyint(3) unsigned NOT NULL DEFAULT '0',
  Comment varchar(1000) NOT NULL,
  Date date NOT NULL,
  PRIMARY KEY (Review_ID),
  KEY Patient_idx (Patient_Alias),
  KEY Doctor_idx (Doctor_Alias),
  CONSTRAINT Doctor FOREIGN KEY (Doctor_Alias) REFERENCES 356_doctors (Alias) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Patient FOREIGN KEY (Patient_Alias) REFERENCES 356_patients (Alias) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_aiken','61e4853e511baad5602cde4ef138219d593615809105325b',SHA2(CONCAT('61e4853e511baad5602cde4ef138219d593615809105325b', 'doc_aiken'), 256),'John','Aikenhead','aiken@head.com','male','1990');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Elizabeth','Street','N2L','2W8','Waterloo','Ontario');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(2,'Aikenhead','Street','N2L','1K2','Kitchener','Ontario');

INSERT INTO 356_specialization(Specialization_Area) VALUES('allergologist');
INSERT INTO 356_specialization(Specialization_Area) VALUES('naturopath');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(1,'doc_aiken');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(2,'doc_aiken');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_aiken',1);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_aiken',2);


INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_amnio','2d804813fc84fe0464150b975c3a3f260b6e8b1e1291ba93',SHA2(CONCAT('2d804813fc84fe0464150b975c3a3f260b6e8b1e1291ba93', 'doc_amnio'), 256),'Jane','Amniotic','obgyn_clinic@rogers.com','female','2005');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Jane','Street','N2L','2W8','Waterloo','Ontario');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(2,'Amniotic','Street','N2P','2K5','Kitchener','Ontario');

INSERT INTO 356_specialization(Specialization_Area) VALUES('obstetrician');
INSERT INTO 356_specialization(Specialization_Area) VALUES('gynecologist');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(3,'doc_amnio');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(4,'doc_amnio');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_amnio',3);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_amnio',4);



INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_umbilical','e12ff087e44a926a1c4a4c7739f9a7a8e2d8777ead960275',SHA2(CONCAT('e12ff087e44a926a1c4a4c7739f9a7a8e2d8777ead960275', 'doc_umbilical'), 256),'Mary','Umbilical','obgyn_clinic@rogers.com','female','2006');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Mary','Street','N2L','1A2','Cambridge','Ontario');

INSERT INTO 356_specialization(Specialization_Area) VALUES('naturopath');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(3,'doc_umbilical');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(5,'doc_umbilical');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_umbilical',4);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_umbilical',5);



INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_heart','8c030301f4d06576e6ea4676d6ad0768ba2e692e01dbf2db',SHA2(CONCAT('8c030301f4d06576e6ea4676d6ad0768ba2e692e01dbf2db', 'doc_heart'), 256),'Jack','Hearty','jack@healthyheart.com','male','1980');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Jack','Street','N2L','1G2','Guelph','Ontario');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(2,'Heart','Street','N2P','2W5','Waterloo','Ontario');

INSERT INTO 356_specialization(Specialization_Area) VALUES('cardiologist');
INSERT INTO 356_specialization(Specialization_Area) VALUES('surgeon');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(6,'doc_heart');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(7,'doc_heart');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_heart',6);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_heart',7);



INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_cutter','c93be283f06969db377f2f55ecbca0d815bb66b25fb65487',SHA2(CONCAT('c93be283f06969db377f2f55ecbca0d815bb66b25fb65487', 'doc_cutter'), 256),'Beth','Cutter','beth@tummytuck.com','female','2014');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Beth','Street','N2L','1C2','Cambridge','Ontario');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(2,'Cutter','Street','N2P','2K5','Kitchener','Ontario');

INSERT INTO 356_specialization(Specialization_Area) VALUES('psychiatrist');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(7,'doc_cutter');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(8,'doc_cutter');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_cutter',8);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_cutter',9);

INSERT INTO 356_patients(Alias,Salt,Password,First_Name,Last_Name,Email,Addr_City,Addr_Province)
VALUES('pat_bob','df36533768f536844e0f156113ddaf40f2ebe86e7a5ddb2e',SHA2(CONCAT('df36533768f536844e0f156113ddaf40f2ebe86e7a5ddb2e', 'pat_bob'), 256),'Bob','Bobberson','thebobbersons@sympatico.ca','Waterloo','Ontario');
INSERT INTO 356_patients(Alias,Salt,Password,First_Name,Last_Name,Email,Addr_City,Addr_Province)
VALUES('pat_peggy','10b3723c8c90ef2b09c5dacfa9fc2796500606a41ec27702',SHA2(CONCAT('10b3723c8c90ef2b09c5dacfa9fc2796500606a41ec27702', 'pat_peggy'), 256),'Peggy','Bobberson','thebobbersons@sympatico.ca','Waterloo','Ontario');
INSERT INTO 356_patients(Alias,Salt,Password,First_Name,Last_Name,Email,Addr_City,Addr_Province)
VALUES('pat_homer','c26762285a23482c6b83040ec026ac4efdf4548583fcbd52',SHA2(CONCAT('c26762285a23482c6b83040ec026ac4efdf4548583fcbd52', 'pat_homer'), 256),'Homer','Homerson','homer@rogers.com','Kitchener','Ontario');
INSERT INTO 356_patients(Alias,Salt,Password,First_Name,Last_Name,Email,Addr_City,Addr_Province)
VALUES('pat_kate','b4ee53101ebc42448ca17ff837c66fa076ae1647da8ee2da',SHA2(CONCAT('b4ee53101ebc42448ca17ff837c66fa076ae1647da8ee2da', 'pat_kate'), 256),'Kate','Katemyer','kate@hello.com','Cambridge','Ontario');
INSERT INTO 356_patients(Alias,Salt,Password,First_Name,Last_Name,Email,Addr_City,Addr_Province)
VALUES('pat_anne','e8dac3584beab5906877c25ab738457c6ef4fed65f593593',SHA2(CONCAT('e8dac3584beab5906877c25ab738457c6ef4fed65f593593', 'pat_anne'), 256),'Anne','MacDonald','anne@gmail.com','Guelph','Ontario');


DROP VIEW IF EXISTS Doctor_Details;
CREATE VIEW Doctor_Details AS
SELECT 356_doctors.Alias AS Doctor, 356_doctors.First_Name, 356_doctors.Last_Name, 356_doctors.Gender, 356_doctors.Email, 356_doctors.Medical_Licence_Year,
356_offices.St_Number, 356_offices.St_Name, 356_offices.St_Type, 356_offices.City, 356_offices.Province,
356_offices.Postal_Code_pre, 356_offices.Postal_Code_suff, 356_specialization.Specialization_Area
FROM 356_doctors
JOIN 356_work ON 356_doctors.Alias = 356_work.Doctor_Alias
JOIN 356_offices ON 356_work.Office_ID = 356_offices.Office_ID
JOIN 356_specialize ON 356_doctors.Alias = 356_specialize.Doctor_Alias
JOIN 356_specialization ON 356_specialize.Specialization_ID = 356_specialization.Specialization_ID;


END @@ 
DELIMITER ;

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
    IF isnull(are_friends) THEN
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

	IF isnull(avg_star) THEN 
		SET avg_star = 0; 
	END IF;
	IF isnull(num_reviews) THEN 
		SET num_reviews = 0; 
	END IF;
END @@
DELIMITER ;

