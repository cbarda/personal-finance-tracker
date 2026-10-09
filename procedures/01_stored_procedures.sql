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

-- Get income, expenses and balance for a specific customer
CREATE PROCEDURE get_customer_balance(IN p_customer_id INT)
BEGIN
    SELECT 
        cust.first_name,
        SUM(CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END) AS total_income,
        SUM(CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END) AS total_expenses,
        SUM(CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END) -
        SUM(CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END) AS balance
    FROM transactions tra
    JOIN accounts acc ON tra.account_id = acc.account_id
    JOIN customers cust ON acc.customer_id = cust.customer_id
    WHERE cust.customer_id = p_customer_id
    GROUP BY cust.customer_id;
END;
