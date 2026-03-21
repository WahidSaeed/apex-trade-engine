package com.apextrade.orderservice.controller;

import com.apextrade.dto.http.OrderRequest;
import com.apextrade.orderservice.service.OrderProcessingService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {

    private final OrderProcessingService orderProcessingService;

    public OrderController(OrderProcessingService orderProcessingService) {
        this.orderProcessingService = orderProcessingService;
    }

    @PostMapping
    public ResponseEntity<String> placeOrder(@RequestBody OrderRequest request) {
        String orderId = orderProcessingService.handleOrder(request);
        return ResponseEntity.ok("Order Received Successfully! ID: " + orderId);
    }

    @DeleteMapping("/{orderId}")
    public ResponseEntity<String> cancelOrder(@PathVariable Long orderId) {
        orderProcessingService.cancelOrder(orderId);
        return ResponseEntity.ok("Cancellation request submitted for Order: " + orderId);
    }
}