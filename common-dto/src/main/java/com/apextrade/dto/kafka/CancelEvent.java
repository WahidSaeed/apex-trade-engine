package com.apextrade.dto.kafka;

import com.apextrade.dto.enums.OrderSide;

public record CancelEvent(
    String orderId,
    String symbol,
    OrderSide side
) {}