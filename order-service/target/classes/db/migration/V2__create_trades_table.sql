SET search_path TO order_schema;

CREATE TABLE trades (
    id BIGSERIAL PRIMARY KEY,
    buy_order_id BIGINT NOT NULL,
    sell_order_id BIGINT NOT NULL,
    symbol VARCHAR(20) NOT NULL,
    price DECIMAL(18, 8) NOT NULL,
    quantity DECIMAL(18, 8) NOT NULL,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);