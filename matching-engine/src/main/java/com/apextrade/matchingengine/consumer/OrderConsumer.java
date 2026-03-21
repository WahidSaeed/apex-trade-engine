package com.apextrade.matchingengine.consumer;

import com.apextrade.dto.kafka.CancelEvent;
import com.apextrade.dto.kafka.OrderEvent;
import com.apextrade.matchingengine.model.OrderBook;
import com.apextrade.matchingengine.producer.TradeProducer;
import com.apextrade.matchingengine.service.MatchingEngineService;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
public class OrderConsumer {

    private final MatchingEngineService matchingEngineService;

    private final String TOPIC_REQUEST = "order-requests";
    private final String TOPIC_CANCEL = "order-requests";
    private final String GROUP = "matching-engine-group";

    public OrderConsumer(MatchingEngineService matchingEngineService) {
        this.matchingEngineService = matchingEngineService;
    }

    @KafkaListener(topics = TOPIC_REQUEST, groupId = GROUP)
    public void handleNewOrder(OrderEvent event) {
        matchingEngineService.submitOrder(event);
    }

    @KafkaListener(topics = TOPIC_CANCEL, groupId = GROUP)
    public void handleCancellation(CancelEvent event) {

        
        matchingEngineService.cancelOrder(event);

        // this.engineThread.submit(() -> {
        //     System.out.println("Received Cancel Request for Order: " + event.orderId());
        //     OrderBook book = orderBooks.get(event.symbol());
        //     if (book != null) {
        //         book.cancelOrder(event);
        //     } else {
        //         System.out.println("Cancel Failed: No OrderBook found for " + event.symbol());
        //     }
        // });
    }
}