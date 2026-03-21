package com.apextrade.orderservice.service;

import com.apextrade.dto.enums.OrderStatus;
import com.apextrade.dto.http.OrderRequest;
import com.apextrade.dto.kafka.*;
import com.apextrade.orderservice.client.WalletClient;
import com.apextrade.orderservice.model.Order;
import com.apextrade.orderservice.producer.OrderProducer;
import com.apextrade.orderservice.repository.OrderRepository;

import java.math.BigDecimal;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OrderProcessingService {

    private final OrderProducer orderProducer;
    private final OrderRepository orderRepository;
    private final WalletClient walletClient;

    
    public OrderProcessingService (
        OrderProducer orderProducer, 
        OrderRepository orderRepository, 
        WalletClient walletClient
    ) {
        this.orderProducer = orderProducer;
        this.orderRepository = orderRepository;
        this.walletClient = walletClient;
    }

    @Transactional
    public String handleOrder(OrderRequest request) {

        BigDecimal totalCost = request.price().multiply(request.quantity());
        BigDecimal currentBalance = walletClient.getUserWalletBalanceByCurrency(request.userId(), "USD");

        if (currentBalance.compareTo(totalCost) < 0) {
            throw new RuntimeException("Insufficient Funds: You need " + totalCost + " USD");
        }

        Order order = new Order(
            request.userId(), 
            request.symbol(), 
            request.side(), 
            request.price());
        Order savedOrder = orderRepository.save(order);

        String orderId = savedOrder.getId().toString();
        OrderEvent finalOrder = new OrderEvent(
            orderId,
            savedOrder.getUserId(),
            savedOrder.getSymbol(),
            savedOrder.getSide(),
            savedOrder.getPrice(),
            request.quantity(),
            savedOrder.getCreatedAt()
        );

        orderProducer.sendNewOrderMessage(finalOrder);
        System.out.println("Order dispatched to Kafka: " + finalOrder.orderId());
        return orderId;
    }

    @Transactional
    public void cancelOrder(Long orderId) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -> new RuntimeException("Order not found"));

        if (order.getStatus() != OrderStatus.PENDING) {
            throw new RuntimeException("Only PENDING orders can be cancelled");
        }

        order.setStatus(OrderStatus.CANCELLED);
        orderRepository.save(order);

        orderProducer.sendOrderCancelMessage(order);
        System.out.println("Cancel Order dispatched to Kafka: " + order.getId());
    }
}