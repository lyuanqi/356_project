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
	ELSE
		SET accepted = 0;
	END IF;
    /*Check if you send a request already*/
	INSERT INTO 356_friends(356_friends.Alias, 356_friends.Friend_Alias, 356_friends.Friend_Accept)
		SELECT requestee_alias, requestor_alias, accepted
		FROM 356_friends
		WHERE NOT EXISTS (
			SELECT * 
			FROM 356_friends 
			WHERE 356_friends.Alias = requestor_alias AND 356_friends.Friend_Alias = requestee_alias );Test_ResetDBTest_RequestFriendTest_RequestFriend
END @@
DELIMITER ;