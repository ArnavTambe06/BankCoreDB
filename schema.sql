-- =============================================
-- BankCoreDB Schema - Oracle PL/SQL Banking System
-- Author: Arnav Tambe
-- Description: Normalized schema for core banking operations
-- =============================================

-- Drop tables if they exist (for re-running)
DROP TABLE audit_log CASCADE CONSTRAINTS;
DROP TABLE transactions CASCADE CONSTRAINTS;
DROP TABLE loans CASCADE CONSTRAINTS;
DROP TABLE accounts CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;

-- 1. Customers Table
CREATE TABLE customers (
    customer_id     NUMBER(10)      PRIMARY KEY,
    full_name       VARCHAR2(100)   NOT NULL,
    date_of_birth   DATE            NOT NULL,
    mobile_number   VARCHAR2(15)    UNIQUE NOT NULL,
    email           VARCHAR2(100)   UNIQUE,
    address         VARCHAR2(200),
    created_date    DATE            DEFAULT SYSDATE
);

-- 2. Accounts Table
CREATE TABLE accounts (
    account_id      NUMBER(12)      PRIMARY KEY,
    customer_id     NUMBER(10)      NOT NULL,
    account_type    VARCHAR2(20)    CHECK (account_type IN ('Savings', 'Current')) NOT NULL,
    balance         NUMBER(15,2)    DEFAULT 0 NOT NULL,
    opening_date    DATE            DEFAULT SYSDATE,
    status          VARCHAR2(20)    DEFAULT 'Active' CHECK (status IN ('Active', 'Closed', 'Frozen')),
    CONSTRAINT fk_account_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 3. Transactions Table
CREATE TABLE transactions (
    transaction_id   NUMBER(15)      PRIMARY KEY,
    account_id       NUMBER(12)      NOT NULL,
    transaction_type VARCHAR2(20)    CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer')) NOT NULL,
    amount           NUMBER(15,2)    NOT NULL,
    transaction_date DATE            DEFAULT SYSDATE,
    description      VARCHAR2(100),
    reference_id     NUMBER(15),     -- For transfers (target account_id)
    CONSTRAINT fk_transaction_account FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- 4. Loans Table 
CREATE TABLE loans (
    loan_id         NUMBER(10)      PRIMARY KEY,
    customer_id     NUMBER(10)      NOT NULL,
    account_id      NUMBER(12),
    loan_amount     NUMBER(15,2)    NOT NULL,
    interest_rate   NUMBER(5,2)     NOT NULL,
    loan_date       DATE            DEFAULT SYSDATE,
    status          VARCHAR2(20)    DEFAULT 'Active',
    CONSTRAINT fk_loan_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_loan_account  FOREIGN KEY (account_id)  REFERENCES accounts(account_id)
);

-- 5. Audit Log Table (for triggers)
CREATE TABLE audit_log (
    log_id          NUMBER(15)      PRIMARY KEY,
    account_id      NUMBER(12),
    action          VARCHAR2(50)    NOT NULL,
    old_balance     NUMBER(15,2),
    new_balance     NUMBER(15,2),
    amount          NUMBER(15,2),
    action_date     DATE            DEFAULT SYSDATE,
    description     VARCHAR2(200)
);

-- Sequences for auto-generating IDs
CREATE SEQUENCE customer_seq START WITH 1001 INCREMENT BY 1;
CREATE SEQUENCE account_seq  START WITH 500001 INCREMENT BY 1;
CREATE SEQUENCE trans_seq    START WITH 10000001 INCREMENT BY 1;
CREATE SEQUENCE loan_seq     START WITH 9001 INCREMENT BY 1;
CREATE SEQUENCE audit_seq    START WITH 1 INCREMENT BY 1;

-- Indexes for performance
CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_transactions_account ON transactions(account_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_audit_account ON audit_log(account_id);

COMMIT;
