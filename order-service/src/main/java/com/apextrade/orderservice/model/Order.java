package com.apextrade.orderservice.model;

import com.apextrade.dto.enums.*;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders", schema = "order_schema")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_name", nullable = false)
    private String userName;

    private String symbol;

    @Enumerated(EnumType.STRING)
    @Column(name = "side", nullable = false)
    private OrderSide side;

    @Enumerated(EnumType.STRING)
    private OrderStatus status;

    @Column(precision = 18, scale = 8)
    private BigDecimal price;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public Order() {}

    public Order(String userName, String symbol, OrderSide side, BigDecimal price) {
        this.userName = userName;
        this.symbol = symbol;
        this.side = side;
        this.price = price;
        this.status = OrderStatus.PENDING;
        this.createdAt = LocalDateTime.now();
    }

    // Getters
    public Long getId() { return id; }
    public OrderSide getSide() { return side; }
    public OrderStatus getStatus() { return status; }
    public String getUserName() { return userName; }
    public String getSymbol() { return symbol; }
    public BigDecimal getPrice() { return price; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    // Setters
    public void setStatus(OrderStatus status) { this.status = status; }
}