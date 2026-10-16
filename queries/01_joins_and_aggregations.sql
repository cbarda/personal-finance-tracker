-- All Transactions with the customer's name 
SELECT tra.transaction_id, cust.first_name, cust.last_name, acc.account_id, tra.description, tra.amount, tra.type, tra.date
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id;

-- Sum of incomes and expenses for each customer
SELECT 
  cust.first_name, 
  COALESCE( SUM( CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END), 0) AS total_income, 
  COALESCE( SUM( CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END), 0) AS total_expenses
FROM transactions tra
LEFT JOIN accounts acc ON tra.account_id = acc.account_id
LEFT JOIN customers cust ON acc.customer_id = cust.customer_id
GROUP BY cust.customer_id;

-- Show customers whose expenses are more than their incomes
SELECT 
  cust.custome_id, 
  cust.first_name,
  cust.last_name,
  SUM( CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END) AS total_income,
  SUM( CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END) AS total_expenses
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id
GROUP BY cust.customer_id, cust.first_name, cust.last_name,
HAVING SUM(CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END) > SUM(CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END);
