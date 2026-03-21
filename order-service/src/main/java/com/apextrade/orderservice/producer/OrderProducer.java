package com.apextrade.orderservice.producer;

import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import com.apextrade.dto.kafka.CancelEvent;
import com.apextrade.dto.kafka.OrderEvent;
import com.apextrade.orderservice.model.Order;

@Service
public class OrderProducer {
    private final KafkaTemplate<String, OrderEvent> kafkaTemplateNewOrder;
    private final KafkaTemplate<String, CancelEvent> kafkaTemplateCancelOrder;
    private static final String TOPIC_REQUEST = "order-requests";
    private static final String TOPIC_CANCEL = "order-cancellations";

    // Manual constructor replaces @RequiredArgsConstructor
    public OrderProducer(
        KafkaTemplate<String, OrderEvent> kafkaTemplateNewOrder,
        KafkaTemplate<String, CancelEvent> kafkaTemplateCancelOrder
    ) {
        this.kafkaTemplateNewOrder = kafkaTemplateNewOrder;
        this.kafkaTemplateCancelOrder = kafkaTemplateCancelOrder;
    }

    public void sendNewOrderMessage(OrderEvent event) {
        kafkaTemplateNewOrder.send(TOPIC_REQUEST, event.symbol(), event);
    }

    public void sendOrderCancelMessage(Order order) {
        CancelEvent cancelEvent = new CancelEvent(order.getId().toString(), order.getSymbol(), order.getSide());
        this.kafkaTemplateCancelOrder.send(TOPIC_CANCEL, order.getSymbol(), cancelEvent);
    }
}