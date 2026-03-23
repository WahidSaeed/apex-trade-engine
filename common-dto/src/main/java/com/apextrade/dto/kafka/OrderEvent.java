package com.apextrade.dto.kafka;

import com.apextrade.dto.enums.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public record OrderEvent(
    String orderId,
    String userName,
    String symbol,
    OrderSide orderSide,
    BigDecimal price,
    BigDecimal quantity,
    LocalDateTime timestamp
) {}