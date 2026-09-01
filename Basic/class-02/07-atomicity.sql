-- ====================================================
-- ACID PROPERTIES: A - ATOMICITY (All or Nothing)
-- ====================================================

-- Atomicity guarantees that a transaction is treated as a single, indivisible unit of work.
-- Either ALL operations in the transaction complete successfully, or NONE of them do.
-- If any part of the transaction fails, the entire transaction fails, and the database 
-- is left unchanged (Rolled back).

-- (Assumes `accounts` table from 06-transactions.sql exists)
-- Let's assume Gautam has 1000, and Cooper has 1000.

-- Scenario: We want to transfer 200 from Gautam to Cooper.
-- This involves TWO steps: 
-- 1. Deduct 200 from Gautam.
-- 2. Add 200 to Cooper.

BEGIN;

    -- Step 1 succeeds.
    UPDATE accounts SET balance = balance - 200 WHERE owner = 'Gautam';
    
    -- Let's simulate a crash or a severe error occurring right here!
    -- Since the next instruction crashes or the database server falls over,
    -- Step 2 never completes.
    
    -- In PostgreSQL, if we forcefully try to do something illegal, 
    -- the transaction will abort.
    -- Let's simulate an error (like Division by Zero):
    SELECT 1 / 0; 
    
    -- Because of the error, Step 2 will not be executed.
    -- UPDATE accounts SET balance = balance + 200 WHERE owner = 'Cooper';
    
-- When the database realizes an error occurred in an uncommitted transaction,
-- it forces a ROLLBACK.
ROLLBACK; 
-- Or if the DB crashed entirely, it automatically rolls back on restart.

-- Result due to Atomicity: 
-- Even though Step 1 "succeeded" initially, it is undone because the whole transaction failed.
-- Gautam's balance remains 1000, not 800. The money didn't magically disappear!
SELECT * FROM accounts;
