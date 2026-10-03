-- All Transactions withe the customer's name 
SELECT tra.*, cust.first_name 
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id;

-- Sum of incomes and expenses for each customer
SELECT cust.first_name, SUM(CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END) AS total_income, SUM(CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END) AS total_expenses
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id
GROUP BY cust.customer_id;

-- Show customers whose expenses are more than their incomes
SELECT cust.*
FROM transactions tra
JOIN accounts acc ON tra.account_id = acc.account_id
JOIN customers cust ON acc.customer_id = cust.customer_id
GROUP BY cust.customer_id
HAVING SUM(CASE WHEN tra.type = 'expense' THEN tra.amount ELSE 0 END) > SUM(CASE WHEN tra.type = 'income' THEN tra.amount ELSE 0 END);
