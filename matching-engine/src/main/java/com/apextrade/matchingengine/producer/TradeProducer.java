package com.apextrade.matchingengine.producer;

import org.springframework.stereotype.Service;

import com.apextrade.dto.kafka.TradeEvent;

import org.springframework.kafka.core.KafkaTemplate;

@Service
public class TradeProducer {
    private final KafkaTemplate<String, TradeEvent> kafkaTemplate;
    private final String TOPIC = "trade-executions";

    public TradeProducer(KafkaTemplate<String, TradeEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void sendTrade(TradeEvent event) {
        // Use symbol as key to keep trade history for an asset in order
        this.kafkaTemplate.send(TOPIC, event.symbol(), event);
        System.out.println("Trade Event Emitted: " + event.tradeId());
    }
}