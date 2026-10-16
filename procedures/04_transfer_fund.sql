DELIMITER $$
CREATE PROCEDURE transfer_fund(
    IN p_from_account_id INT,
    IN p_to_account_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    -- Variables
    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_first_id INT;
    DECLARE v_second_id INT;
    DECLARE v_locked_id INT;
    -- Detect missing rows in SELECT ... INTO
    DECLARE v_not_found BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_not_found = TRUE;
    -- Roll back everything if an SQL error occurs
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    -- Validate transfer amount
    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Amount must be greater than zero';
    END IF;
    -- Validate account IDs
    IF p_from_account_id IS NULL
       OR p_to_account_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Account IDs cannot be null';
    END IF;
    -- Prevent transfers to the same account
    IF p_from_account_id = p_to_account_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot transfer to the same account';
    END IF;
    -- Always lock accounts in ascending ID order
    SET v_first_id = LEAST(p_from_account_id, p_to_account_id);
    SET v_second_id = GREATEST(p_from_account_id, p_to_account_id);

    START TRANSACTION;
    -- Lock the first account
    SET v_not_found = FALSE;
    SELECT account_id INTO v_locked_id
    FROM accounts
    WHERE account_id = v_first_id
    FOR UPDATE;
    IF v_not_found THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'One of the accounts does not exist';
    END IF;
    -- Lock the second account
    SET v_not_found = FALSE;
    SELECT account_id INTO v_locked_id
    FROM accounts
    WHERE account_id = v_second_id
    FOR UPDATE;
    IF v_not_found THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'One of the accounts does not exist';
    END IF;
    -- Read the source balance while its row is locked
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = p_from_account_id;
    -- Check sufficient balance
    IF v_balance IS NULL OR v_balance < p_amount THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient balance';
    END IF;
    -- Deduct money from source account
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_from_account_id;
    -- Add money to destination account
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_to_account_id;
    -- Record the transfer
    INSERT INTO transfers (
        from_account_id,
        to_account_id,
        amount
    )
    VALUES (
        p_from_account_id,
        p_to_account_id,
        p_amount
    );
    -- Commit both balance updates and transfer record
    COMMIT;
END$$
DELIMITER ;
