-- View: customer balance summary
CREATE VIEW customer_balance_view AS
WITH 
customer_totals AS (
    SELECT cust.first_name, 
           SUM(CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END) AS total_income, 
           SUM(CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END) AS total_expenses
    FROM transactions tra
    JOIN accounts acc ON tra.account_id = acc.account_id
    JOIN customers cust ON acc.customer_id = cust.customer_id
    GROUP BY cust.customer_id
),
customer_balance AS (
    SELECT *, total_income - total_expenses AS balance 
    FROM customer_totals
)
SELECT * FROM customer_balance;

-- View: monthly income and expenses summary
CREATE VIEW monthly_transactions_view AS
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) AS total_expenses,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY YEAR(date), MONTH(date);
