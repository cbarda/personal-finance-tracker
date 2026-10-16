CREATE PROCEDURE transfer_fund(IN p_from_account_id INT, IN p_to_account_id INT, IN p_amount DECIMAL(10,2))
BEGIN
    -- Check if sufficient balance exists
    IF (SELECT balance FROM accounts WHERE account_id = p_from_account_id) < p_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance';
    ELSE
        UPDATE accounts 
        SET balance = balance - p_amount
        WHERE account_id = p_from_account_id;

        UPDATE accounts 
        SET balance = balance + p_amount
        WHERE account_id = p_to_account_id;
    END IF;
END;
