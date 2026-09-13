-- Personal Finance Tracker
-- Schema Definition

CREATE DATABASE IF NOT EXISTS finance_tracker;
USE finance_tracker;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    age         INT,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    type          ENUM('income','expense') NOT NULL
);

CREATE TABLE accounts (
    account_id  INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    name        VARCHAR(50) NOT NULL,
    balance     DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id     INT NOT NULL,
    category_id    INT NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    type           ENUM('income','expense') NOT NULL,
    description    VARCHAR(255),
    date           DATE NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
