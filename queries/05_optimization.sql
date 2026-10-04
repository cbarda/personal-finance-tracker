-- Analyze query execution plan
EXPLAIN SELECT * 
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id
WHERE cust.customer_id = 1;

-- Add index on date for faster date-based queries
CREATE INDEX idx_transaction_date ON transactions(date);
