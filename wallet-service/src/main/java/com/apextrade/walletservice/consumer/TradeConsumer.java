package com.apextrade.walletservice.consumer;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import com.apextrade.dto.kafka.TradeEvent;
import com.apextrade.walletservice.service.WalletService;

@Service
public class TradeConsumer {

    private final WalletService walletService;
    private final String TOPIC = "trade-executions";
    private final String GROUP = "wallet-group";

    public TradeConsumer(WalletService walletService) {
        this.walletService = walletService;
    }

    @KafkaListener(topics = TOPIC, groupId = GROUP)
    public void handleTrade(TradeEvent trade) {
        System.out.println("Processing Trade Balance Update: " + trade.tradeId());
        walletService.executeTradeBalances(trade);
    }
}
