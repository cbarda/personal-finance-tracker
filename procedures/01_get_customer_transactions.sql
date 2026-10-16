CREATE PROCEDURE get_customer_transactions(IN p_customer_id INT)
BEGIN
    DECLARE v_customer_exists INT;
    -- Validate input
    IF p_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer ID cannot be NULL';
    END IF;
    -- Check if customer exists
    SELECT COUNT(*) INTO v_customer_exists
    FROM customers
    WHERE customer_id = p_customer_id;
    IF v_customer_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;
    -- Get all transactions for a customer
    SELECT
        cust.first_name,
        acc.account_id,
        tra.transaction_id,
        tra.description,
        tra.amount,
        tra.type,
        tra.date
    FROM transactions tra
    JOIN accounts acc
        ON tra.account_id = acc.account_id
    JOIN customers cust
        ON acc.customer_id = cust.customer_id
    WHERE cust.customer_id = p_customer_id
    ORDER BY tra.date DESC, tra.transaction_id DESC;
END;
