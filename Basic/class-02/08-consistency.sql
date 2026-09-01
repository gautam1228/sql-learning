-- ====================================================
-- ACID PROPERTIES: C - CONSISTENCY (Rules are rules)
-- ====================================================

-- Consistency ensures that a transaction can only bring the database from one 
-- *valid* state to another *valid* state. 
-- Any rules, constraints, cascades, and triggers defined on the database 
-- MUST be successfully applied. If a transaction tries to break a rule, 
-- it gets immediately rejected.

-- (Assumes `accounts` table from 06-transactions.sql exists)
-- Remember our setup constraint: balance INT CHECK (balance >= 0)

-- Let's assume Gautam has 1000, and Cooper has 1000.

-- Scenario: Gautam tries to transfer 5000 to Cooper.
BEGIN;

    -- Step 1: Trying to deduct 5000 from Gautam.
    -- His balance would become 1000 - 5000 = -4000.
    -- This violates the CHECK (balance >= 0) constraint!
    
    -- The database immediately throws an error:
    -- ERROR: new row for relation "accounts" violates check constraint "accounts_balance_check"
    UPDATE accounts SET balance = balance - 5000 WHERE owner = 'Gautam';
    
    -- Because the database refused the inconsistent state, this statement fails.
    -- In PostgreSQL, once an error happens in a transaction block, subsequent operations are ignored
    -- and you MUST ROLLBACK.
    
    UPDATE accounts SET balance = balance + 5000 WHERE owner = 'Cooper'; -- This won't have any effect.

ROLLBACK;

-- Result due to Consistency:
-- The database refused to allow an invalid state (negative balance). 
-- Therefore, the balances remain unchanged (1000 each) and the consistency rule is maintained.
SELECT * FROM accounts;
