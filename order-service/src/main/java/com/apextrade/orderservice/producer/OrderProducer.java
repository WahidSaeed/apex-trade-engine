package com.apextrade.orderservice.producer;

import com.apextrade.dto.OrderEvent;
import lombok.RequiredArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrderProducer {

    private final KafkaTemplate<String, OrderEvent> kafkaTemplate;
    private static final String TOPIC = "order-requests";

    public void sendMessage(OrderEvent event) {
        // We use the Symbol (e.g., BTC) as the key so all 
        // orders for the same coin go to the same partition
        kafkaTemplate.send(TOPIC, event.getSymbol(), event);
    }
}