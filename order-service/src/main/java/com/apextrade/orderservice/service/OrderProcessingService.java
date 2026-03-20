package com.apextrade.orderservice.service;

import com.apextrade.dto.OrderEvent;
import com.apextrade.orderservice.producer.OrderProducer;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OrderProcessingService {

    private final OrderProducer orderProducer;

    public void handleOrder(OrderEvent event) {
        // 1. Assign a unique Order ID
        event.setOrderId(UUID.randomUUID().toString());
        event.setTimestamp(LocalDateTime.now());

        // 2. Publish to Kafka
        orderProducer.sendMessage(event);
        
        System.out.println("Order pushed to Kafka: " + event.getOrderId());
    }
}