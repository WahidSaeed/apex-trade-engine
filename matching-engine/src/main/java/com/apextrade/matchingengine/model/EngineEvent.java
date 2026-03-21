package com.apextrade.matchingengine.model;

import com.apextrade.dto.kafka.CancelEvent;
import com.apextrade.dto.kafka.OrderEvent;

public class EngineEvent {
    public enum Type { NEW_ORDER, CANCEL_ORDER }
    
    private Type type;
    private OrderEvent orderEvent;
    private CancelEvent cancelEvent;

    // Standard Getters and Setters
    public void setNewOrder(OrderEvent event) {
        this.type = Type.NEW_ORDER;
        this.orderEvent = event;
    }

    public void setCancel(CancelEvent event) {
        this.type = Type.CANCEL_ORDER;
        this.cancelEvent = event;
    }
    
    public Type getType() { return type; }
    public OrderEvent getOrderEvent() { return orderEvent; }
    public CancelEvent getCancelEvent() { return cancelEvent; }
}