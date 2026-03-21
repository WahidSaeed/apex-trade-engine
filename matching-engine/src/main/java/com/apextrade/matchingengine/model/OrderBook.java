package com.apextrade.matchingengine.model;

import com.apextrade.dto.enums.*;
import com.apextrade.dto.kafka.*;
import com.apextrade.matchingengine.producer.TradeProducer;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

public class OrderBook {
    private final TreeMap<BigDecimal, List<OrderEvent>> bids = new TreeMap<>(Collections.reverseOrder());
    private final TreeMap<BigDecimal, List<OrderEvent>> asks = new TreeMap<>();

    private final TradeProducer tradeProducer;

    public OrderBook(TradeProducer tradeProducer) {
        this.tradeProducer = tradeProducer;
    }

    public void addOrder(OrderEvent order) {
        if (order.orderSide() == OrderSide.BUY) {
            processBuyOrder(order);
        } else {
            processSellOrder(order);
        }
    }

    private void processBuyOrder(OrderEvent buyOrder) {
        BigDecimal remainingBuyQty = buyOrder.quantity();

        while (remainingBuyQty.compareTo(BigDecimal.ZERO) > 0 && !asks.isEmpty()) {
            BigDecimal bestAskPrice = asks.firstKey();
            
            // If the cheapest seller is more expensive than the buyer's limit, stop matching.
            if (bestAskPrice.compareTo(buyOrder.price()) > 0) break;

            List<OrderEvent> ordersAtPrice = asks.get(bestAskPrice);
            Iterator<OrderEvent> it = ordersAtPrice.iterator();

            while (it.hasNext() && remainingBuyQty.compareTo(BigDecimal.ZERO) > 0) {
                OrderEvent sellOrder = it.next();
                BigDecimal sellQty = sellOrder.quantity();

                // Calculate how much we can match
                BigDecimal matchedQty = remainingBuyQty.min(sellQty);
                
                // UPDATE: In a real system, you'd emit a TradeEvent to Kafka here!
                System.out.println("TRADE EXECUTED: " + buyOrder.symbol() + " @ " + bestAskPrice + " Vol: " + matchedQty);
                String tradeId = UUID.randomUUID().toString();
                TradeEvent trade = new TradeEvent(
                    tradeId,
                    buyOrder.orderId(),
                    sellOrder.orderId(),
                    buyOrder.userId(),
                    sellOrder.userId(),
                    buyOrder.symbol(),
                    bestAskPrice, // Execution Price
                    matchedQty,
                    LocalDateTime.now()
                );

                // Call the producer (you'll need to pass this reference in)
                this.tradeProducer.sendTrade(trade);
                
                // Update remaining quantities
                remainingBuyQty = remainingBuyQty.subtract(matchedQty);
                
                if (matchedQty.compareTo(sellQty) >= 0) {
                    it.remove(); // Seller fully filled, remove from list
                } else {
                    // Seller partially filled - Replace the record in the list
                    BigDecimal remainingSellQty = sellQty.subtract(matchedQty);
                    OrderEvent updatedSellOrder = new OrderEvent(
                        sellOrder.orderId(), sellOrder.userId(), sellOrder.symbol(), 
                        sellOrder.orderSide(), sellOrder.price(), remainingSellQty, sellOrder.timestamp()
                    );
                    
                    // Update the specific index in the list
                    int index = ordersAtPrice.indexOf(sellOrder);
                    ordersAtPrice.set(index, updatedSellOrder);
                }
            }

            if (ordersAtPrice.isEmpty()) asks.remove(bestAskPrice);
        }

        // If still have quantity, add the remainder to the Bids TreeMap
        if (remainingBuyQty.compareTo(BigDecimal.ZERO) > 0) {
            // Create a new record with the remaining qty to store in the book
            OrderEvent remainder = new OrderEvent(buyOrder.orderId(), buyOrder.userId(), 
                                                buyOrder.symbol(), buyOrder.orderSide(), 
                                                buyOrder.price(), remainingBuyQty, buyOrder.timestamp());
            bids.computeIfAbsent(buyOrder.price(), k -> new ArrayList<>()).add(remainder);
        }
    }

    private void processSellOrder(OrderEvent sellOrder) {
        BigDecimal remainingSellQty = sellOrder.quantity();

        // While there's quantity to sell AND there are buyers (bids)
        while (remainingSellQty.compareTo(BigDecimal.ZERO) > 0 && !bids.isEmpty()) {
            BigDecimal bestBidPrice = bids.firstKey(); // Highest buyer

            // If the highest buyer is offering less than our sell limit, stop matching.
            if (bestBidPrice.compareTo(sellOrder.price()) < 0) break;

            List<OrderEvent> ordersAtPrice = bids.get(bestBidPrice);
            Iterator<OrderEvent> it = ordersAtPrice.iterator();

            while (it.hasNext() && remainingSellQty.compareTo(BigDecimal.ZERO) > 0) {
                OrderEvent buyOrder = it.next();
                BigDecimal buyQty = buyOrder.quantity();

                // Calculate how much we can match
                BigDecimal matchedQty = remainingSellQty.min(buyQty);

                // Emit the Trade
                String tradeId = UUID.randomUUID().toString();
                TradeEvent trade = new TradeEvent(
                    tradeId,
                    buyOrder.orderId(),
                    sellOrder.orderId(),
                    buyOrder.userId(),
                    sellOrder.userId(),
                    sellOrder.symbol(),
                    bestBidPrice, // Execution happens at the Bid price (the sitting order)
                    matchedQty,
                    LocalDateTime.now()
                );
                this.tradeProducer.sendTrade(trade);

                // Update remaining sell quantity
                remainingSellQty = remainingSellQty.subtract(matchedQty);

                // Handle Buy Order (the sitting order) Partial/Full Fill
                if (matchedQty.compareTo(buyQty) >= 0) {
                    it.remove(); // Buyer fully filled
                } else {
                    // Buyer partially filled - Replace with updated record
                    BigDecimal remainingBuyQty = buyQty.subtract(matchedQty);
                    OrderEvent updatedBuyOrder = new OrderEvent(
                        buyOrder.orderId(), buyOrder.userId(), buyOrder.symbol(),
                        buyOrder.orderSide(), buyOrder.price(), remainingBuyQty, buyOrder.timestamp()
                    );
                    int index = ordersAtPrice.indexOf(buyOrder);
                    ordersAtPrice.set(index, updatedBuyOrder);
                }
            }

            if (ordersAtPrice.isEmpty()) bids.remove(bestBidPrice);
        }

        // If still have quantity, add the remainder to the Asks (Sellers) TreeMap
        if (remainingSellQty.compareTo(BigDecimal.ZERO) > 0) {
            OrderEvent remainder = new OrderEvent(
                sellOrder.orderId(), sellOrder.userId(), sellOrder.symbol(),
                sellOrder.orderSide(), sellOrder.price(), remainingSellQty, sellOrder.timestamp()
            );
            asks.computeIfAbsent(sellOrder.price(), k -> new ArrayList<>()).add(remainder);
        }
    }

    public void cancelOrder(CancelEvent event) {
        TreeMap<BigDecimal, List<OrderEvent>> targetMap = 
            (event.side() == OrderSide.BUY) ? bids : asks;
            
        for (List<OrderEvent> orders : targetMap.values()) {
            boolean removed = orders.removeIf(o -> o.orderId().equals(event.orderId()));
            if (removed) {
                System.out.println("SUCCESS: Order " + event.orderId() + " purged from memory.");
                return;
            }
        }
        System.out.println("CANCEL FAIL: Order " + event.orderId() + " not found (likely already matched).");
    }
}