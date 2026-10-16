-- Get all transactions for a specific customer
CREATE PROCEDURE get_customer_transactions(IN p_customer_id INT)
BEGIN
    SELECT 
        cust.first_name,
        tra.description,
        tra.amount,
        tra.type,
        tra.date
    FROM transactions tra
    JOIN accounts acc ON tra.account_id = acc.account_id
    JOIN customers cust ON acc.customer_id = cust.customer_id
    WHERE cust.customer_id = p_customer_id;
END;
