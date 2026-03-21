package com.apextrade.matchingengine.service;

import org.springframework.stereotype.Service;

import com.apextrade.dto.kafka.CancelEvent;
import com.apextrade.dto.kafka.OrderEvent;
import com.apextrade.matchingengine.model.EngineEvent;
import com.apextrade.matchingengine.model.EngineEventFactory;
import com.apextrade.matchingengine.producer.TradeProducer;
import com.lmax.disruptor.BlockingWaitStrategy;
import com.lmax.disruptor.RingBuffer;
import com.lmax.disruptor.dsl.Disruptor;
import com.lmax.disruptor.dsl.ProducerType;
import com.lmax.disruptor.util.DaemonThreadFactory;

@Service
public class MatchingEngineService {

    private final Disruptor<EngineEvent> disruptor;
    private final RingBuffer<EngineEvent> ringBuffer;

    public MatchingEngineService(TradeProducer tradeProducer) {
        // 1. Setup the pre-allocated ring
        this.disruptor = new Disruptor<>(
            new EngineEventFactory(),
            1024, // Size must be a power of 2
            DaemonThreadFactory.INSTANCE,
            ProducerType.SINGLE, // Assuming one Kafka consumer thread
            new BlockingWaitStrategy()
        );

        // 2. Connect the handler
        this.disruptor.handleEventsWith(new MatchingHandler(tradeProducer));
        
        // 3. Start the engine
        this.ringBuffer = disruptor.start();
    }

    public void submitOrder(OrderEvent event) {
        // Claim the next slot on the belt
        long sequence = ringBuffer.next(); 
        try {
            System.out.println("Received Order for Matching: " + event.orderId());

            EngineEvent holder = ringBuffer.get(sequence);
            holder.setNewOrder(event); // Fill the slot with the Kafka data
        } finally {
            ringBuffer.publish(sequence); // Tell the MatchingHandler it's ready
        }
    }

    public void cancelOrder(CancelEvent event) {
        // Claim the next slot on the belt
        long sequence = ringBuffer.next(); 
        try {
            System.out.println("Received Cancel Request for Order: " + event.orderId());
            EngineEvent holder = ringBuffer.get(sequence);
            if (holder.getCancelEvent() != null) {
                holder.setCancel(event);
            } else {
                System.out.println("Cancel Failed: No OrderBook found for " + event.symbol());
            }
        } finally {
            ringBuffer.publish(sequence); // Tell the MatchingHandler it's ready
        }
    }
}
