SET search_path TO wallet_schema;

-- 1. Rename the column
ALTER TABLE wallets RENAME COLUMN user_id TO user_name;

-- 2. Drop the old constraint (this automatically drops its backing index)
ALTER TABLE wallets DROP CONSTRAINT unique_user_currency;

-- 3. Recreate the constraint using the new column name
ALTER TABLE wallets ADD CONSTRAINT unique_user_currency UNIQUE (user_name, currency);