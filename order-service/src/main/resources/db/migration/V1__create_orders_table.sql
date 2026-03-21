CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    symbol VARCHAR(20) NOT NULL,      -- e.g., 'BTC-USD'
    side VARCHAR(10) NOT NULL,        -- 'BUY' or 'SELL'
    price DECIMAL(18, 8) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'FILLED', 'CANCELLED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for fast lookups by user (Berlin exchange style)
CREATE INDEX idx_orders_user_id ON orders(user_id);