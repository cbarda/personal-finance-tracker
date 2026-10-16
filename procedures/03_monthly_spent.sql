CREATE PROCEDURE monthly_spent(IN p_customer_id INT, IN p_month INT, IN p_year INT)
BEGIN
    SELECT 
        cust.first_name,
        MONTH(tra.date) AS month,
        YEAR(tra.date) AS year,
        SUM(tra.amount) AS total_spent
    FROM transactions tra
    JOIN accounts acc ON tra.account_id = acc.account_id
    JOIN customers cust ON acc.customer_id = cust.customer_id
    WHERE cust.customer_id = p_customer_id
    AND MONTH(tra.date) = p_month
    AND YEAR(tra.date) = p_year
    AND tra.type = 'expense'
    GROUP BY month, year;
END;
