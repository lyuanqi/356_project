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
  Province varchar(2) NOT NULL,
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
VALUES(1,'Elizabeth','Street','N2L','2W8','Waterloo','ON');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(2,'Aikenhead','Street','N2L','1K2','Kitchener','ON');

INSERT INTO 356_specialization(Specialization_Area) VALUES('allergologist');
INSERT INTO 356_specialization(Specialization_Area) VALUES('naturopath');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(1,'doc_aiken');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(2,'doc_aiken');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_aiken',1);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_aiken',2);


INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_amnio','2d804813fc84fe0464150b975c3a3f260b6e8b1e1291ba93',SHA2(CONCAT('2d804813fc84fe0464150b975c3a3f260b6e8b1e1291ba93', 'doc_amnio'), 256),'Jane','Amniotic','obgyn_clinic@rogers.com','female','2005');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Jane','Street','N2L','2W8','Waterloo','ON');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(2,'Amniotic','Street','N2P','2K5','Kitchener','ON');

INSERT INTO 356_specialization(Specialization_Area) VALUES('obstetrician');
INSERT INTO 356_specialization(Specialization_Area) VALUES('gynecologist');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(3,'doc_amnio');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(4,'doc_amnio');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_amnio',3);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_amnio',4);



INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_umbilical','e12ff087e44a926a1c4a4c7739f9a7a8e2d8777ead960275',SHA2(CONCAT('e12ff087e44a926a1c4a4c7739f9a7a8e2d8777ead960275', 'doc_umbilical'), 256),'Mary','Umbilical','obgyn_clinic@rogers.com','female','2006');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Mary','Street','N2L','1A2','Cambridge','ON');

INSERT INTO 356_specialization(Specialization_Area) VALUES('naturopath');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(3,'doc_umbilical');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(5,'doc_umbilical');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_umbilical',4);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_umbilical',5);



INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_heart','8c030301f4d06576e6ea4676d6ad0768ba2e692e01dbf2db',SHA2(CONCAT('8c030301f4d06576e6ea4676d6ad0768ba2e692e01dbf2db', 'doc_heart'), 256),'Jack','Hearty','jack@healthyheart.com','male','1980');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Jack','Street','N2L','1G2','Guelph','ON');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(2,'Heart','Street','N2P','2W5','Waterloo','ON');

INSERT INTO 356_specialization(Specialization_Area) VALUES('cardiologist');
INSERT INTO 356_specialization(Specialization_Area) VALUES('surgeon');

INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(6,'doc_heart');
INSERT INTO 356_specialize(Specialization_ID,Doctor_Alias) VALUES(7,'doc_heart');

INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_heart',6);
INSERT INTO 356_work(Doctor_Alias,Office_ID) VALUES('doc_heart',7);



INSERT INTO 356_doctors(Alias,Salt,Password,First_Name,Last_Name,Email,Gender,Medical_Licence_Year)
VALUES ('doc_cutter','c93be283f06969db377f2f55ecbca0d815bb66b25fb65487',SHA2(CONCAT('c93be283f06969db377f2f55ecbca0d815bb66b25fb65487', 'doc_cutter'), 256),'Beth','Cutter','beth@tummytuck.com','female','2014');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(1,'Beth','Street','N2L','1C2','Cambridge','ON');

INSERT INTO 356_offices(St_Number,St_Name,St_Type,Postal_Code_pre,Postal_Code_suff,City,Province)
VALUES(2,'Cutter','Street','N2P','2K5','Kitchener','ON');

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

END @@ DELIMITER;