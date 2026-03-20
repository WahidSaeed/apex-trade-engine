package com.apextrade.orderservice.controller;

import com.apextrade.dto.OrderEvent;
import com.apextrade.orderservice.service.OrderProcessingService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderProcessingService orderProcessingService;

    @PostMapping
    public String placeOrder(@RequestBody OrderEvent orderRequest) {
        orderProcessingService.handleOrder(orderRequest);
        return "Order Received Successfully!";
    }
}