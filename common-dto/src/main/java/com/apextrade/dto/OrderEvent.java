package com.apextrade.dto;

import lombok.*;
import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OrderEvent {
    private String orderId;
    private String userId;
    private String symbol;      // e.g., "BTC-USD"
    private String orderSide;   // BUY or SELL
    private Double price;
    private Double quantity;
    private LocalDateTime timestamp;
}