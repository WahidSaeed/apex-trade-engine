package com.apextrade.orderservice.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "trades", schema = "order_schema")
public class Trade {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long buyOrderId;
    private Long sellOrderId;
    private String symbol;
    private BigDecimal price;
    private BigDecimal quantity;
    private LocalDateTime executedAt;

    // Default constructor for JPA
    public Trade() {}

    public Trade(Long buyOrderId, Long sellOrderId, String symbol, BigDecimal price, BigDecimal quantity) {
        this.buyOrderId = buyOrderId;
        this.sellOrderId = sellOrderId;
        this.symbol = symbol;
        this.price = price;
        this.quantity = quantity;
        this.executedAt = LocalDateTime.now();
    }
    
    // Getters
    public Long getBuyOrderId() { return buyOrderId; }
    public Long getSellOrderId() { return sellOrderId; }
    public String getSymbol() { return symbol; }
    public BigDecimal getPrice() { return price; }
    public BigDecimal getQuantity() { return quantity; }
    public LocalDateTime getExecutedAt() { return executedAt; }
}