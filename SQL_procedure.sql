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