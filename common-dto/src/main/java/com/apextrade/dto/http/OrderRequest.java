package com.apextrade.dto.http;

import java.math.BigDecimal;
import com.apextrade.dto.enums.OrderSide;

public record OrderRequest(
    String userName,
    String symbol,
    OrderSide side,
    BigDecimal price,
    BigDecimal quantity
) {}