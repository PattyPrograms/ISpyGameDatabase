-- 1. Add Trigger Automatically sets current date on Wishlist insert if null
DELIMITER $$
CREATE TRIGGER before_wishlist_insert
BEFORE INSERT ON Wishlist
FOR EACH ROW
BEGIN
    -- If no date is provided, use today's date
    IF NEW.dateAdded IS NULL THEN
        SET NEW.dateAdded = CURDATE();
    END IF;
END $$

DELIMITER ;

-- 2. AFTER UPDATE trigger: log rating changes
DELIMITER $$

CREATE TRIGGER log_rating_changes
AFTER UPDATE ON Game
FOR EACH ROW
BEGIN
    IF OLD.rating <> NEW.rating THEN
        INSERT INTO GameRatingLog (gameID, oldRating, newRating, changedAt)
        VALUES (OLD.gameID, OLD.rating, NEW.rating, NOW());
    END IF;
END $$

DELIMITER ;

-- 3. Delete Trigger: Log deletions from Wishlist
DELIMITER $$

CREATE TRIGGER after_wishlist_delete
AFTER DELETE ON wishlist
FOR EACH ROW
BEGIN
    INSERT INTO wishlistlog (userID, gameID, deletedAt)
    VALUES (OLD.userID, OLD.gameID, NOW());
END $$

DELIMITER ;

-- AddToWishList Procedure: Add game to wishlist if not already present
DELIMITER $$

CREATE PROCEDURE AddToWishlist (
    IN p_userID INT,
    IN p_gameID INT
)
BEGIN
    -- Check if already exists
    IF NOT EXISTS (
        SELECT 1 
        FROM Wishlist 
        WHERE userID = p_userID AND gameID = p_gameID
    ) THEN
        INSERT INTO Wishlist (userID, gameID, dateAdded)
        VALUES (p_userID, p_gameID, CURDATE());
    END IF;
END $$

DELIMITER ;

-- GetUserWishListCount function, gets the total wishlist count for a user
DELIMITER $$

CREATE FUNCTION GetUserWishlistCount (p_userID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM Wishlist
    WHERE userID = p_userID;

    RETURN total;
END $$

DELIMITER ;


-- Tests all the functions

-- Tests the before_wishlist_insert trigger, Inserting WITHOUT the date so trigger should set it
INSERT INTO Wishlist (userID, gameID, dateAdded)
VALUES (1, 101, NULL);
-- Check result
SELECT * FROM Wishlist WHERE userID = 1 AND gameID = 101;

-- Tests the log_rating_changes trigger where you Update a gameratinglog rating
UPDATE Game
SET rating = rating + 1
WHERE gameID = 101;
-- Check log table
SELECT * FROM GameRatingLog WHERE gameID = 101;

-- Tests the 3rd trigger,by Deleting a wishlist entry to see if it logs it
DELETE FROM Wishlist
WHERE userID = 1 AND gameID = 101;
-- Check log
SELECT * FROM WishlistLog WHERE userID = 1 AND gameID = 101;

-- Tests the AddToWishlist procedure Should insert only if NOT already there
-- First call (should insert)
CALL AddToWishlist(2, 202);
-- Second call (should do NOTHING)
CALL AddToWishlist(2, 202);
-- Check result (should only be ONE row)
SELECT * FROM Wishlist WHERE userID = 2 AND gameID = 202;

-- Test GetUserWishlistCount function Should return total wishlist items
SELECT GetUserWishlistCount(2) AS wishlist_count;