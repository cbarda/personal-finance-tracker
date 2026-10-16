CREATE PROCEDURE transfer_fund(
    IN p_from_account_id INT, 
    IN p_to_account_id INT, 
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transfer failed - rolled back';
    END;
    START TRANSACTION;
        -- Check sufficient balance
        IF (SELECT balance FROM accounts WHERE account_id = p_from_account_id) < p_amount THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance';
        END IF;
        -- Deduct from source account
        UPDATE accounts 
        SET balance = balance - p_amount
        WHERE account_id = p_from_account_id;
        -- Add to destination account
        UPDATE accounts 
        SET balance = balance + p_amount
        WHERE account_id = p_to_account_id;
    COMMIT;
END;
