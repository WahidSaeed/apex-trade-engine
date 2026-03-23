ALTER TABLE order_schema.trades 
    ADD CONSTRAINT fk_buy_order 
    FOREIGN KEY (buy_order_id) REFERENCES order_schema.orders(id);

ALTER TABLE order_schema.trades 
    ADD CONSTRAINT fk_sell_order 
    FOREIGN KEY (sell_order_id) REFERENCES order_schema.orders(id);

-- 2. Add indices for high-speed matching engine lookups
CREATE INDEX IF NOT EXISTS idx_trades_buy_order_id ON order_schema.trades(buy_order_id);
CREATE INDEX IF NOT EXISTS idx_trades_sell_order_id ON order_schema.trades(sell_order_id);