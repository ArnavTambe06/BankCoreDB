-- =============================================
-- triggers.sql - Database Triggers for BankCoreDB
-- Automatic Audit Logging + Business Rule Enforcement
-- Author: Arnav Tambe
-- =============================================

-- Trigger 1: Audit Log Trigger - Logs every balance change
CREATE OR REPLACE TRIGGER audit_transaction_trigger
AFTER UPDATE OF balance ON accounts
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (
        log_id, 
        account_id, 
        action, 
        old_balance, 
        new_balance, 
        amount,
        description
    ) VALUES (
        audit_seq.NEXTVAL,
        :NEW.account_id,
        'Balance Updated',
        :OLD.balance,
        :NEW.balance,
        (:NEW.balance - :OLD.balance),
        'Automatic audit after transaction'
    );
END;
/

-- Trigger 2: Prevent Overdraft Trigger (Critical for banks)
CREATE OR REPLACE TRIGGER prevent_overdraft_trigger
BEFORE UPDATE OF balance ON accounts
FOR EACH ROW
WHEN (NEW.balance < 0)
BEGIN
    RAISE_APPLICATION_ERROR(-20010, 'Overdraft not allowed. Transaction rejected. Insufficient balance.');
END;
/

-- Trigger 3: Auto Update Last Transaction Date (optional but good)
CREATE OR REPLACE TRIGGER update_last_transaction_date
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE accounts 
    SET opening_date = SYSDATE   -- We can rename column later if needed, using opening_date as last_txn_date for simplicity
    WHERE account_id = :NEW.account_id;
END;
/

COMMIT;

-- Verify triggers
SELECT trigger_name, trigger_type, triggering_event, table_name 
FROM user_triggers 
WHERE table_name IN ('ACCOUNTS', 'TRANSACTIONS');-- =============================================
-- triggers.sql - Database Triggers for BankCoreDB
-- Automatic Audit Logging + Business Rule Enforcement
-- =============================================

-- Trigger 1: Audit Log Trigger - Logs every balance change
CREATE OR REPLACE TRIGGER audit_transaction_trigger
AFTER UPDATE OF balance ON accounts
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (
        log_id, 
        account_id, 
        action, 
        old_balance, 
        new_balance, 
        amount,
        description
    ) VALUES (
        audit_seq.NEXTVAL,
        :NEW.account_id,
        'Balance Updated',
        :OLD.balance,
        :NEW.balance,
        (:NEW.balance - :OLD.balance),
        'Automatic audit after transaction'
    );
END;
/

-- Trigger 2: Prevent Overdraft Trigger (Critical for banks)
CREATE OR REPLACE TRIGGER prevent_overdraft_trigger
BEFORE UPDATE OF balance ON accounts
FOR EACH ROW
WHEN (NEW.balance < 0)
BEGIN
    RAISE_APPLICATION_ERROR(-20010, 'Overdraft not allowed. Transaction rejected. Insufficient balance.');
END;
/

-- Trigger 3: Auto Update Last Transaction Date (optional but good)
CREATE OR REPLACE TRIGGER update_last_transaction_date
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE accounts 
    SET opening_date = SYSDATE   -- We can rename column later if needed, using opening_date as last_txn_date for simplicity
    WHERE account_id = :NEW.account_id;
END;
/

COMMIT;

-- Verify triggers
SELECT trigger_name, trigger_type, triggering_event, table_name 
FROM user_triggers 
WHERE table_name IN ('ACCOUNTS', 'TRANSACTIONS');
