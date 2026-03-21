CREATE TABLE wallets (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    balance DECIMAL(18, 8) DEFAULT 0.0,
    CONSTRAINT unique_user_currency UNIQUE (user_id, currency)
);

INSERT INTO wallets (user_id, currency, balance) VALUES ('user-123', 'USD', 10000.00);
INSERT INTO wallets (user_id, currency, balance) VALUES ('user-123', 'BTC', 0.5);