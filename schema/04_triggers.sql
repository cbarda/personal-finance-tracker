-- Automatically update account balance after each transaction
CREATE TRIGGER update_balance_after_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.type = 'income' THEN
        UPDATE accounts 
        SET balance = balance + NEW.amount
        WHERE account_id = NEW.account_id;
    ELSE
        UPDATE accounts 
        SET balance = balance - NEW.amount
        WHERE account_id = NEW.account_id;
    END IF;
END;
