USE finance_tracker_test;

UPDATE accounts SET balance = 1000.00 WHERE account_id = 1; 
UPDATE accounts SET balance = 500.00 WHERE account_id = 2;
UPDATE accounts SET balance = 200.00 WHERE account_id = 3;

DROP PROCEDURE IF EXISTS run_transfer_tests;
DELIMITER $$
CREATE PROCEDURE run_transfer_tests()
BEGIN
    DECLARE v_error_occurred BOOLEAN DEFAULT FALSE;
    DECLARE v_sqlstate CHAR(5);
    DECLARE v_error_message TEXT;
    DECLARE v_before_1 DECIMAL(10,2);
    DECLARE v_before_2 DECIMAL(10,2);
    DECLARE v_after_1 DECIMAL(10,2);
    DECLARE v_after_2 DECIMAL(10,2);
    DECLARE v_log_before INT;
    DECLARE v_log_after INT;
    -- --------------------------------------------------------
    -- TEST 1: Successful transfer
    -- --------------------------------------------------------
    SELECT COUNT(*) INTO v_log_before
    FROM transfers;
    CALL transfer_fund(1, 2, 100.00);
    SELECT balance INTO v_after_1
    FROM accounts
    WHERE account_id = 1;
    SELECT balance INTO v_after_2
    FROM accounts
    WHERE account_id = 2;
    SELECT COUNT(*) INTO v_log_after
    FROM transfers;
    SELECT
        'TEST 1: Successful transfer' AS test_name,
        CASE
            WHEN v_after_1 = 900.00
             AND v_after_2 = 600.00
             AND v_log_after = v_log_before + 1
            THEN 'PASS'
            ELSE 'FAIL'
        END AS result;
    -- Restore starting balances for the next tests.
    UPDATE accounts
    SET balance = 1000.00
    WHERE account_id = 1;

    UPDATE accounts
    SET balance = 500.00
    WHERE account_id = 2;
    -- --------------------------------------------------------
    -- TEST 2: Insufficient balance
    -- --------------------------------------------------------
    SET v_error_occurred = FALSE;
    SET v_error_message = NULL;
    SET v_sqlstate = NULL;
    SELECT balance INTO v_before_1
    FROM accounts WHERE account_id = 1;
    SELECT balance INTO v_before_2
    FROM accounts WHERE account_id = 2;
    SELECT COUNT(*) INTO v_log_before
    FROM transfers;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            SET v_error_occurred = TRUE;

            GET DIAGNOSTICS CONDITION 1
                v_sqlstate = RETURNED_SQLSTATE,
                v_error_message = MESSAGE_TEXT;
        END;

        CALL transfer_fund(1, 2, 9999.00);
    END;
    SELECT balance INTO v_after_1
    FROM accounts WHERE account_id = 1;
    SELECT balance INTO v_after_2
    FROM accounts WHERE account_id = 2;
    SELECT COUNT(*) INTO v_log_after
    FROM transfers;
    SELECT
        'TEST 2: Insufficient balance' AS test_name,
        CASE
            WHEN v_error_occurred = TRUE
             AND v_sqlstate = '45000'
             AND v_error_message = 'Insufficient balance'
             AND v_before_1 = v_after_1
             AND v_before_2 = v_after_2
             AND v_log_before = v_log_after
            THEN 'PASS'
            ELSE 'FAIL'
        END AS result;
    -- --------------------------------------------------------
    -- TEST 3: Same account transfer
    -- --------------------------------------------------------
    SET v_error_occurred = FALSE;
    SET v_error_message = NULL;
    SET v_sqlstate = NULL;
    SELECT COUNT(*) INTO v_log_before
    FROM transfers;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            SET v_error_occurred = TRUE;
            GET DIAGNOSTICS CONDITION 1
                v_sqlstate = RETURNED_SQLSTATE,
                v_error_message = MESSAGE_TEXT;
        END;
        CALL transfer_fund(1, 1, 100.00);
    END;
    SELECT balance INTO v_after_1
    FROM accounts WHERE account_id = 1;
    SELECT COUNT(*) INTO v_log_after
    FROM transfers;
    SELECT
        'TEST 3: Same account transfer' AS test_name,
        CASE
            WHEN v_error_occurred = TRUE
             AND v_sqlstate = '45000'
             AND v_error_message =
                 'Cannot transfer to the same account'
             AND v_after_1 = 1000.00
             AND v_log_before = v_log_after
            THEN 'PASS'
            ELSE 'FAIL'
        END AS result;
    -- --------------------------------------------------------
    -- TEST 4: Negative amount
    -- --------------------------------------------------------
    SET v_error_occurred = FALSE;
    SET v_error_message = NULL;
    SET v_sqlstate = NULL;
    SELECT COUNT(*) INTO v_log_before
    FROM transfers;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            SET v_error_occurred = TRUE;
            GET DIAGNOSTICS CONDITION 1
                v_sqlstate = RETURNED_SQLSTATE,
                v_error_message = MESSAGE_TEXT;
        END;
        CALL transfer_fund(1, 2, -50.00);
    END;
    SELECT COUNT(*) INTO v_log_after
    FROM transfers;
    SELECT
        'TEST 4: Negative amount' AS test_name,
        CASE
            WHEN v_error_occurred = TRUE
             AND v_sqlstate = '45000'
             AND v_error_message =
                 'Amount must be greater than zero'
             AND v_log_before = v_log_after
            THEN 'PASS'
            ELSE 'FAIL'
        END AS result;
    -- --------------------------------------------------------
    -- TEST 5: NULL amount
    -- --------------------------------------------------------
    SET v_error_occurred = FALSE;
    SET v_error_message = NULL;
    SET v_sqlstate = NULL;
    SELECT COUNT(*) INTO v_log_before
    FROM transfers;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            SET v_error_occurred = TRUE;

            GET DIAGNOSTICS CONDITION 1
                v_sqlstate = RETURNED_SQLSTATE,
                v_error_message = MESSAGE_TEXT;
        END;
        CALL transfer_fund(1, 2, NULL);
    END;
    SELECT COUNT(*) INTO v_log_after
    FROM transfers;
    SELECT
        'TEST 5: NULL amount' AS test_name,
        CASE
            WHEN v_error_occurred = TRUE
             AND v_sqlstate = '45000'
             AND v_error_message =
                 'Amount must be greater than zero'
             AND v_log_before = v_log_after
            THEN 'PASS'
            ELSE 'FAIL'
        END AS result;
    -- --------------------------------------------------------
    -- TEST 6: Non-existent destination account
    -- --------------------------------------------------------
    SET v_error_occurred = FALSE;
    SET v_error_message = NULL;
    SET v_sqlstate = NULL;
    SELECT balance INTO v_before_1
    FROM accounts WHERE account_id = 1;
    SELECT COUNT(*) INTO v_log_before
    FROM transfers;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            SET v_error_occurred = TRUE;
            GET DIAGNOSTICS CONDITION 1
                v_sqlstate = RETURNED_SQLSTATE,
                v_error_message = MESSAGE_TEXT;
        END;

        CALL transfer_fund(1, 9999, 100.00);
    END;
    SELECT balance INTO v_after_1
    FROM accounts WHERE account_id = 1;
    SELECT COUNT(*) INTO v_log_after
    FROM transfers;
    SELECT
        'TEST 6: Non-existent destination account'
            AS test_name,
        CASE
            WHEN v_error_occurred = TRUE
             AND v_sqlstate = '45000'
             AND v_error_message =
                 'Destination account does not exist'
             AND v_before_1 = v_after_1
             AND v_log_before = v_log_after
            THEN 'PASS'
            ELSE 'FAIL'
        END AS result;
    -- --------------------------------------------------------
    -- TEST 7: Verify transfer audit log
    -- --------------------------------------------------------
    SELECT
        'TEST 8: Transfer audit log' AS test_name,
        CASE
            WHEN COUNT(*) >= 1
            THEN 'PASS'
            ELSE 'FAIL'
        END AS result
    FROM transfers
    WHERE from_account_id = 1
      AND to_account_id = 2
      AND amount = 100.00;
END$$
DELIMITER ;
-- --------------------------------------------------------
-- EXECUTE TESTS
-- --------------------------------------------------------
CALL run_transfer_tests();

-- --------------------------------------------------------
-- FINAL INSPECTION
-- --------------------------------------------------------
SELECT account_id, balance
FROM accounts
WHERE account_id IN (1, 2, 3)
ORDER BY account_id;
SELECT *
FROM transfers
ORDER BY transfer_id DESC;

-- OPTIONAL CLEANUP
-- Uncomment only if you want to remove the test runner.
-- DROP PROCEDURE IF EXISTS run_transfer_tests;
