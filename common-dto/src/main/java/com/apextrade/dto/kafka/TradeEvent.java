package com.apextrade.dto.kafka;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record TradeEvent(
    String tradeId,
    String buyOrderId,
    String sellOrderId,
    String buyerId,
    String sellerId,
    String symbol,
    BigDecimal price,
    BigDecimal quantity,
    LocalDateTime timestamp
) {}