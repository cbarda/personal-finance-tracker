-- Query 1: Rewrite of basic query using CTE
WITH customer_totals AS (
    SELECT 
           cust.customer_id, 
           cust.first_name, 
           COALESCE(SUM(CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END), 0) AS total_income,
           COALESCE(SUM(CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END), 0) AS total_expenses
    FROM transactions tra
    LEFT JOIN accounts acc ON tra.account_id = acc.account_id
    LEFT JOIN customers cust ON acc.customer_id = cust.customer_id
    GROUP BY cust.customer_id
)
SELECT * FROM customer_totals
WHERE total_expenses > total_income;

-- Query 2: Chained CTEs - customer balance ranking
WITH 
customer_totals AS (
    SELECT 
           cust.customer_id, 
           cust.first_name, 
           COALESCE(SUM(CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END), 0) AS total_income,
           COALESCE(SUM(CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END), 0) AS total_expenses
    FROM transactions tra
    LEFT JOIN accounts acc ON tra.account_id = acc.account_id
    LEFT JOIN customers cust ON acc.customer_id = cust.customer_id
    GROUP BY cust.customer_id
),
customer_balance AS (
    SELECT *, total_income - total_expenses AS balance 
    FROM customer_totals
)
SELECT * FROM customer_balance
WHERE balance > 0
ORDER BY balance DESC;
