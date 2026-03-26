package com.apextrade.orderservice.service;

import com.apextrade.dto.enums.OrderStatus;
import com.apextrade.dto.http.OrderRequest;
import com.apextrade.dto.kafka.*;
import com.apextrade.orderservice.client.WalletClient;
import com.apextrade.orderservice.exception.InsufficientFundsException;
import com.apextrade.orderservice.model.Order;
import com.apextrade.orderservice.producer.OrderProducer;
import com.apextrade.orderservice.repository.OrderRepository;

import java.math.BigDecimal;
import java.util.List;

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
        
        String currencyToCheck = (request.side() == com.apextrade.dto.enums.OrderSide.BUY) ? request.symbol().split("-")[1] : request.symbol().split("-")[0];
        BigDecimal currentBalance = walletClient.getUserWalletBalanceByCurrency(request.userName(), currencyToCheck);

        if (currentBalance.compareTo(request.quantity()) < 0) {
            throw new InsufficientFundsException("Insufficient " + request.symbol() + " balance.");
        }

        Order order = new Order(
            request.userName(), 
            request.symbol(), 
            request.side(), 
            request.price());
        Order savedOrder = orderRepository.save(order);

        String orderId = savedOrder.getId().toString();
        OrderEvent finalOrder = new OrderEvent(
            orderId,
            savedOrder.getUserName(),
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

    public List<Order> getUserOrders(String userName) {
        return orderRepository.findByUserName(userName);
    }
}