-- =============================================
-- Sample Data for BankCoreDB - Oracle PL/SQL Banking System
-- Author: Arnav Tambe
-- =============================================

-- Insert Customers
INSERT INTO customers (customer_id, full_name, date_of_birth, mobile_number, email, address) 
VALUES (customer_seq.NEXTVAL, 'Harsha Sakpal', DATE '1995-03-15', '9876543210', 'harsha.sakpal@email.com', 'Mumbai');

INSERT INTO customers (customer_id, full_name, date_of_birth, mobile_number, email, address) 
VALUES (customer_seq.NEXTVAL, 'Navya Chavan', DATE '1998-07-22', '9123456789', 'navya.chavan@email.com', 'Panvel');

INSERT INTO customers (customer_id, full_name, date_of_birth, mobile_number, email, address) 
VALUES (customer_seq.NEXTVAL, 'Hriday Kumar', DATE '1992-11-05', '9988776655', 'hirday.kumar@email.com', 'Thane');

COMMIT;

-- Insert Accounts
INSERT INTO accounts (account_id, customer_id, account_type, balance, status) 
VALUES (account_seq.NEXTVAL, 1001, 'Savings', 45000.00, 'Active');

INSERT INTO accounts (account_id, customer_id, account_type, balance, status) 
VALUES (account_seq.NEXTVAL, 1002, 'Current', 125000.50, 'Active');

INSERT INTO accounts (account_id, customer_id, account_type, balance, status) 
VALUES (account_seq.NEXTVAL, 1003, 'Savings', 8500.00, 'Active');

COMMIT;

-- Insert Sample Transactions
INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, description) 
VALUES (trans_seq.NEXTVAL, 500001, 'Deposit', 50000.00, 'Salary Credit');

INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, description) 
VALUES (trans_seq.NEXTVAL, 500001, 'Withdrawal', 5000.00, 'ATM Withdrawal');

COMMIT;

-- Insert Sample Loan
INSERT INTO loans (loan_id, customer_id, account_id, loan_amount, interest_rate, status) 
VALUES (loan_seq.NEXTVAL, 1001, 500001, 300000.00, 8.50, 'Active');

COMMIT;

-- Verify inserted data
SELECT 'Customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'Accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'Transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'Loans', COUNT(*) FROM loans;
