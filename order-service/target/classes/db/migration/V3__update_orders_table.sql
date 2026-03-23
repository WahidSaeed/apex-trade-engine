-- 1. Rename the column
ALTER TABLE orders RENAME COLUMN user_id TO user_name;

-- 2. Rename the index
ALTER INDEX idx_orders_user_name RENAME TO idx_orders_user_name_old;
DROP INDEX IF EXISTS idx_orders_user_name_old;
CREATE INDEX idx_orders_user_name ON orders(user_name);