-- =============================================
-- main.sql - Master Script for BankCoreDB
-- Run this file to setup the entire project
-- Author: Arnav Tambe
-- =============================================


PROMPT =============================================
PROMPT Starting BankCoreDB Setup...
PROMPT =============================================

-- Run schema
@@schema.sql
PROMPT Schema created successfully.

-- Run sample data
@@sample_data.sql
PROMPT Sample data inserted.

-- Run procedures
@@procedures.sql
PROMPT Procedures and functions created.

-- Run triggers
@@triggers.sql
PROMPT Triggers created.

PROMPT =============================================
PROMPT BankCoreDB Setup Completed Successfully!
PROMPT =============================================

PROMPT Test Commands:
PROMPT 1. EXEC deposit(500001, 5000, 'Test Deposit');
PROMPT 2. EXEC generate_mini_statement(500001);
PROMPT 3. SELECT get_balance(500001) FROM dual;
PROMPT 
PROMPT Note: Overdraft prevention trigger is active.
