CREATE PROCEDURE transfer_fund(
    IN p_from_account_id INT, 
    IN p_to_account_id INT, 
    IN p_amount DECIMAL(10,2)
)
BEGIN
    -- Declarations
    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_account_exists INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    -- Check for null or negative amount
    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Amount must be greater than zero';
    END IF;
    -- Check for null account ids
    IF p_from_account_id IS NULL OR p_to_account_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account IDs cannot be null';
    END IF;
    -- Check for same account transfer
    IF p_from_account_id = p_to_account_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot transfer to the same account';
    END IF;

    START TRANSACTION;
        -- Check if source account exists
        SELECT COUNT(*) INTO v_account_exists 
        FROM accounts 
        WHERE account_id = p_from_account_id;
        IF v_account_exists = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Source account does not exist';
        END IF;
        -- Check if destination account exists
        SELECT COUNT(*) INTO v_account_exists 
        FROM accounts 
        WHERE account_id = p_to_account_id;
        IF v_account_exists = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Destination account does not exist';
        END IF;
        -- Lock the row and read balance
        SELECT balance INTO v_balance 
        FROM accounts 
        WHERE account_id = p_from_account_id
        FOR UPDATE;
        -- Check sufficient balance
        IF v_balance < p_amount THEN
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
