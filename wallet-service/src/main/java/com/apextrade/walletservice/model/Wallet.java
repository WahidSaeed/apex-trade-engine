package com.apextrade.walletservice.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "wallets", schema = "wallet_schema")
public class Wallet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name")
    private String userName;
    private String currency; // e.g., "USD" or "BTC"
    
    @Column(precision = 18, scale = 8)
    private BigDecimal balance;
    
    public Wallet() {}

    public Wallet(String userName, String currency, BigDecimal balance) {
        this.userName = userName;
        this.currency = currency;
        this.balance = balance;
    }

    // Getters
    public Long getId() { return id; }
    public String getUserName() { return userName; }
    public String getCurrency() { return currency; }
    public BigDecimal getBalance() { return balance; }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }
}