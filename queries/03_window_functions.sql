-- Total amount per customer alongside each transaction
SELECT 
    cust.first_name,
    tra.description,
    tra.amount,
    SUM(tra.amount) OVER (PARTITION BY cust.customer_id) AS customer_total
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id;

-- Rank transactions per customer by amount (highest first)
SELECT 
    cust.first_name,
    tra.description,
    tra.amount,
    ROW_NUMBER() OVER (PARTITION BY cust.customer_id ORDER BY tra.amount DESC) AS rank_by_amount
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id;

-- Highest transactions per customer
WITH ranked AS (
    SELECT 
        cust.first_name,
        tra.description,
        tra.amount,
        ROW_NUMBER() OVER (PARTITION BY cust.customer_id ORDER BY tra.amount DESC) AS rank_by_amount
    FROM transactions tra
    JOIN accounts acc ON tra.account_id = acc.account_id
    JOIN customers cust ON acc.customer_id = cust.customer_id
)
SELECT * FROM ranked
WHERE rank_by_amount = 1;

-- Compare each transaction to the previous one per customer (LAG)
SELECT 
    cust.first_name,
    tra.date,
    tra.amount,
    LAG(tra.amount) OVER (PARTITION BY cust.customer_id ORDER BY tra.date) AS previous_amount,
    tra.amount - LAG(tra.amount) OVER (PARTITION BY cust.customer_id ORDER BY tra.date) AS difference
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id;

-- Compare each transaction to the next one per customer (LEAD)
SELECT 
    cust.first_name,
    tra.date,
    tra.amount,
    LEAD(tra.amount) OVER (PARTITION BY cust.customer_id ORDER BY tra.date) AS next_amount,
    tra.amount - LEAD(tra.amount) OVER (PARTITION BY cust.customer_id ORDER BY tra.date) AS difference
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id;
