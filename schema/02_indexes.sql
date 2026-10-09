-- Analyze query execution plan
EXPLAIN SELECT * 
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id 
JOIN customers cust ON acc.customer_id = cust.customer_id  
WHERE cust.customer_id = 1;
-- ------------------------------------------------------------------
-- PRIMARY KEYs crete automatically INDEXes
-- ------------------------------------------------------------------

-- Index on transaction type for faster filtering
CREATE INDEX idx_transactions_type ON transactions(type);

-- Index on transaction date for faster date-based queries
CREATE INDEX idx_transactions_date ON transactions(date);

-- Index on accounts customer_id for faster joins
CREATE INDEX idx_accounts_customer_id ON accounts(customer_id);

-- Index on transactions account_id for faster joins
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
