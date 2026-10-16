CREATE PROCEDURE monthly_spent(
    IN p_customer_id INT,
    IN p_month INT,
    IN p_year INT
)
BEGIN
    DECLARE v_customer_exists INT;
    DECLARE v_start_date DATE;
    DECLARE v_end_date DATE;
    -- Validate parameters
    IF p_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer ID cannot be NULL';
    END IF;
    IF p_month IS NULL OR p_month NOT BETWEEN 1 AND 12 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Month must be between 1 and 12';
    END IF;
    IF p_year IS NULL OR p_year NOT BETWEEN 1000 AND 9998 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid year';
    END IF;
    -- Check customer existence
    SELECT COUNT(*) INTO v_customer_exists
    FROM customers
    WHERE customer_id = p_customer_id;
    IF v_customer_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;
    -- Calculate date range
    SET v_start_date = STR_TO_DATE(
        CONCAT(p_year, '-', LPAD(p_month, 2, '0'), '-01'),
        '%Y-%m-%d'
    );
    SET v_end_date = DATE_ADD(v_start_date, INTERVAL 1 MONTH);
    -- Calculate monthly expenses
    SELECT
        cust.first_name,
        p_month AS month,
        p_year AS year,
        COALESCE(SUM(tra.amount), 0) AS total_spent
    FROM customers cust
    LEFT JOIN accounts acc
        ON cust.customer_id = acc.customer_id
    LEFT JOIN transactions tra
        ON tra.account_id = acc.account_id
        AND tra.type = 'expense'
        AND tra.date >= v_start_date
        AND tra.date < v_end_date
    WHERE cust.customer_id = p_customer_id
    GROUP BY cust.customer_id, cust.first_name;
END;
