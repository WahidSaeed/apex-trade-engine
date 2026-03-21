package com.apextrade.orderservice.consumer;

import com.apextrade.dto.kafka.TradeEvent;
import com.apextrade.orderservice.model.Trade;
import com.apextrade.orderservice.repository.OrderRepository;
import com.apextrade.orderservice.repository.TradeRepository;
import com.apextrade.dto.enums.OrderStatus;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TradeConsumer {

    private final OrderRepository orderRepository;
    private final TradeRepository tradeRepository;

    private final String TOPIC = "trade-executions";
    private final String GROUP = "order-service-group";

    public TradeConsumer(OrderRepository orderRepository, TradeRepository tradeRepository) {
        this.orderRepository = orderRepository;
        this.tradeRepository = tradeRepository;
    }

    @Transactional
    @KafkaListener(topics = TOPIC, groupId = GROUP)
    public void handleTradeExecution(TradeEvent tradeEvent) {
        System.out.println("Updating Order Status for Trade: " + tradeEvent.tradeId());

        Trade trade = new Trade(
            Long.parseLong(tradeEvent.buyOrderId()),
            Long.parseLong(tradeEvent.sellOrderId()),
            tradeEvent.symbol(),
            tradeEvent.price(),
            tradeEvent.quantity()
        );
        tradeRepository.save(trade);
        
        updateOrderStatus(tradeEvent.buyOrderId(), OrderStatus.FILLED);
        updateOrderStatus(tradeEvent.sellOrderId(), OrderStatus.FILLED);
    }

    private void updateOrderStatus(String orderId, OrderStatus status) {
        orderRepository.findById(Long.parseLong(orderId)).ifPresent(order -> {
            order.setStatus(status);
            orderRepository.save(order);
            System.out.println("Order " + orderId + " updated to " + status);
        });
    }
}