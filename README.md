# BankCoreDB – Oracle PL/SQL Banking System

A complete relational database solution built using **Oracle SQL and PL/SQL** to simulate core banking operations.

### Objective
Developed to demonstrate strong skills in database design, PL/SQL programming, query optimization, and backend data operations — targeted for SQL/PL/SQL Developer roles in banking.

### Key Features
- Normalized database schema for banking domain (Customers, Accounts, Transactions, Loans, Audit Logs)
- PL/SQL Stored Procedures for core banking operations:
  - Account creation
  - Deposit & Withdrawal
  - Fund Transfer
  - Mini Statement generation
- PL/SQL Functions for balance inquiry and interest calculation
- Database Triggers for automatic audit logging and business rule enforcement (e.g., overdraft prevention)
- Proper exception handling and error management
- Performance considerations with indexes and constraints

### Technologies Used
- Oracle Database 21c Express Edition
- SQL & PL/SQL (Procedures, Functions, Triggers, Cursors, Packages, Exceptions)
- SQL Developer

### Repository Structure
BankCoreDB/
├── schema.sql          # Table creation with constraints & indexes
├── sample_data.sql     # Insert statements for demo data
├── procedures.sql      # All stored procedures & functions
├── triggers.sql        # Database triggers
├── main.sql            # Master script to run everything
├── README.md
└── docs/
└── ER_Diagram.txt  # Simple text-based schema diagram


### How to Run
1. Connect to Oracle Database (XE) using SQL Developer
2. Run `schema.sql`
3. Run `sample_data.sql`
4. Run `procedures.sql`
5. Run `triggers.sql`
6. Execute procedures (e.g., `EXEC Deposit(1001, 5000);`)

### Learning Outcomes
- Relational database design & normalization
- Writing efficient PL/SQL code for transactional systems
- Implementing business logic using procedures, functions & triggers
- Error handling and data integrity in banking scenarios

