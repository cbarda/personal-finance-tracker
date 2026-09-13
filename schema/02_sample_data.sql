USE finance_tracker;

INSERT INTO customers (first_name, last_name, email, age) VALUES
('Maria', 'Papadopoulou', 'maria@email.com', 32),
('Nikos', 'Georgiou', 'nikos@email.com', 45),
('Elena', 'Dimitriou', 'elena@email.com', 28);

INSERT INTO categories (name, type) VALUES
('Salary', 'income'),
('Freelance', 'income'),
('Rent', 'expense'),
('Food', 'expense'),
('Transport', 'expense'),
('Entertainment', 'expense');

INSERT INTO accounts (customer_id, name, balance) VALUES
(1, 'Main Account', 2500.00),
(2, 'Savings', 8000.00),
(3, 'Main Account', 1200.00);

INSERT INTO transactions (account_id, category_id, amount, type, description, date) VALUES
(1, 1, 1500.00, 'income',  'Monthly salary',    '2024-01-01'),
(1, 3, 600.00,  'expense', 'January rent',      '2024-01-02'),
(1, 4, 150.00,  'expense', 'Supermarket',       '2024-01-05'),
(2, 1, 2500.00, 'income',  'Monthly salary',    '2024-01-01'),
(2, 3, 900.00,  'expense', 'January rent',      '2024-01-03'),
(3, 2, 800.00,  'income',  'Freelance project', '2024-01-10'),
(3, 5, 50.00,   'expense', 'Bus pass',          '2024-01-11');
