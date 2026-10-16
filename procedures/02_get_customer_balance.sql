CREATE PROCEDURE get_customer_balance(IN p_customer_id INT)
BEGIN
    DECLARE v_customer_exists INT;
    -- Validate customer ID
    IF p_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer ID cannot be NULL';
    END IF;
    -- Check customer existence
    SELECT COUNT(*) INTO v_customer_exists
    FROM customers
    WHERE customer_id = p_customer_id;

    IF v_customer_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;
    -- Calculate income, expenses and balance
    SELECT
        summary.first_name,
        summary.total_income,
        summary.total_expenses,
        summary.total_income - summary.total_expenses AS balance
    FROM (
        SELECT
            cust.customer_id,
            cust.first_name,
            COALESCE(SUM(
                CASE WHEN tra.type = 'income'
                     THEN tra.amount ELSE 0 END
            ), 0) AS total_income,
            COALESCE(SUM(
                CASE WHEN tra.type = 'expense'
                     THEN tra.amount ELSE 0 END
            ), 0) AS total_expenses
        FROM customers cust
        LEFT JOIN accounts acc
            ON cust.customer_id = acc.customer_id
        LEFT JOIN transactions tra
            ON acc.account_id = tra.account_id
        WHERE cust.customer_id = p_customer_id
        GROUP BY cust.customer_id, cust.first_name
    ) AS summary;
END;
