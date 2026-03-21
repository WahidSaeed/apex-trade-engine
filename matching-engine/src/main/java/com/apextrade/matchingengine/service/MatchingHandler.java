package com.apextrade.matchingengine.service;

import java.util.HashMap;
import java.util.Map;

import com.apextrade.dto.kafka.OrderEvent;
import com.apextrade.matchingengine.model.EngineEvent;
import com.apextrade.matchingengine.model.OrderBook;
import com.apextrade.matchingengine.producer.TradeProducer;
import com.lmax.disruptor.EventHandler;

public class MatchingHandler implements EventHandler<EngineEvent> {
    private final Map<String, OrderBook> orderBooks = new HashMap<>();
    private final TradeProducer tradeProducer;

    public MatchingHandler(TradeProducer tradeProducer) {
        this.tradeProducer = tradeProducer;
    }

    @Override
    public void onEvent(EngineEvent event, long sequence, boolean endOfBatch) {
        OrderBook book = orderBooks.computeIfAbsent(
            getSymbol(event), 
            k -> new OrderBook(tradeProducer)
        );

        if (event.getType() == EngineEvent.Type.NEW_ORDER) {
            book.addOrder(event.getOrderEvent());
        } else if (event.getType() == EngineEvent.Type.CANCEL_ORDER) {
            book.cancelOrder(event.getCancelEvent());
        }
    }

    private String getSymbol(EngineEvent event) {
        return event.getType() == EngineEvent.Type.NEW_ORDER ? 
            event.getOrderEvent().symbol() : event.getCancelEvent().symbol();
    }
}
