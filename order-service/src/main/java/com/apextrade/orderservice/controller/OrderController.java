package com.apextrade.orderservice.controller;

import com.apextrade.dto.http.OrderRequest;
import com.apextrade.orderservice.service.OrderProcessingService;
import com.apextrade.orderservice.model.Order;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;



@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {

    private final OrderProcessingService orderProcessingService;

    public OrderController(OrderProcessingService orderProcessingService) {
        this.orderProcessingService = orderProcessingService;
    }

    @GetMapping("/my-orders")
    public List<Order> getMyOrders(@RequestHeader("loggedInUser") String userId) {
        return orderProcessingService.getUserOrders(userId);
    }

    @PostMapping("/placeOrder")
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