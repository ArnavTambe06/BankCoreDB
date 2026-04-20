
-- =============================================
-- procedures.sql - PL/SQL for BankCoreDB
-- Core Banking Operations using Stored Procedures & Functions
-- Author: Arnav Tambe
-- =============================================

-- 1. Function: Get current balance
CREATE OR REPLACE FUNCTION get_balance(p_account_id IN NUMBER) 
RETURN NUMBER IS
    v_balance NUMBER;
BEGIN
    SELECT balance INTO v_balance 
    FROM accounts 
    WHERE account_id = p_account_id;
    
    RETURN v_balance;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Account not found');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error fetching balance');
END;
/

-- 2. Procedure: Deposit Money
CREATE OR REPLACE PROCEDURE deposit(
    p_account_id IN NUMBER,
    p_amount     IN NUMBER,
    p_description IN VARCHAR2 DEFAULT 'Cash Deposit'
) IS
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Deposit amount must be positive');
    END IF;

    UPDATE accounts 
    SET balance = balance + p_amount 
    WHERE account_id = p_account_id;

    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, description)
    VALUES (trans_seq.NEXTVAL, p_account_id, 'Deposit', p_amount, p_description);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Deposit of ' || p_amount || ' successful for Account ' || p_account_id);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Deposit failed: ' || SQLERRM);
END;
/

-- 3. Procedure: Withdraw Money (with overdraft check via trigger later)
CREATE OR REPLACE PROCEDURE withdraw(
    p_account_id IN NUMBER,
    p_amount     IN NUMBER,
    p_description IN VARCHAR2 DEFAULT 'Cash Withdrawal'
) IS
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Withdrawal amount must be positive');
    END IF;

    UPDATE accounts 
    SET balance = balance - p_amount 
    WHERE account_id = p_account_id;

    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, description)
    VALUES (trans_seq.NEXTVAL, p_account_id, 'Withdrawal', p_amount, p_description);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Withdrawal of ' || p_amount || ' successful for Account ' || p_account_id);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006, 'Withdrawal failed: ' || SQLERRM);
END;
/

-- 4. Procedure: Fund Transfer (between two accounts)
CREATE OR REPLACE PROCEDURE fund_transfer(
    p_from_account IN NUMBER,
    p_to_account   IN NUMBER,
    p_amount       IN NUMBER,
    p_description  IN VARCHAR2 DEFAULT 'Fund Transfer'
) IS
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Transfer amount must be positive');
    END IF;

    -- Debit from sender
    UPDATE accounts 
    SET balance = balance - p_amount 
    WHERE account_id = p_from_account;

    -- Credit to receiver
    UPDATE accounts 
    SET balance = balance + p_amount 
    WHERE account_id = p_to_account;

    -- Log both transactions
    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, description, reference_id)
    VALUES (trans_seq.NEXTVAL, p_from_account, 'Transfer', p_amount, p_description, p_to_account);

    INSERT INTO transactions (transaction_id, account_id, transaction_type, amount, description, reference_id)
    VALUES (trans_seq.NEXTVAL, p_to_account, 'Transfer', p_amount, p_description, p_from_account);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Fund Transfer of ' || p_amount || ' from ' || p_from_account || ' to ' || p_to_account || ' successful');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20008, 'Fund Transfer failed: ' || SQLERRM);
END;
/

-- 5. Procedure: Generate Mini Statement
CREATE OR REPLACE PROCEDURE generate_mini_statement(
    p_account_id IN NUMBER
) IS
    CURSOR trans_cursor IS
        SELECT transaction_type, amount, transaction_date, description
        FROM transactions 
        WHERE account_id = p_account_id
        ORDER BY transaction_date DESC
        FETCH FIRST 5 ROWS ONLY;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Mini Statement for Account: ' || p_account_id || ' ===');
    DBMS_OUTPUT.PUT_LINE('Current Balance: ' || get_balance(p_account_id));
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');

    FOR rec IN trans_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(rec.transaction_date || ' | ' || 
                           RPAD(rec.transaction_type, 12) || ' | ' || 
                           LPAD(rec.amount, 10) || ' | ' || 
                           rec.description);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20009, 'Error generating statement: ' || SQLERRM);
END;
/

-- Enable output to see messages
SET SERVEROUTPUT ON;
