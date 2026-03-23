package com.apextrade.walletservice.service;

import com.apextrade.dto.kafka.TradeEvent;
import com.apextrade.walletservice.model.Wallet;
import com.apextrade.walletservice.repository.WalletRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class WalletService {

    private final WalletRepository walletRepository;

    public WalletService(WalletRepository walletRepository) {
        this.walletRepository = walletRepository;
    }

    public List<Wallet> getWalletsByUserName(String userName) {
        return walletRepository.findByUserName(userName);
    }

    public BigDecimal getWalletsByUserNameAndCurrency(String userName, String currency) {
        return walletRepository.findByUserNameAndCurrency(userName, currency)
                .map(Wallet::getBalance)
                .orElse(BigDecimal.ZERO);
    }

    @Transactional
    public void executeTradeBalances(TradeEvent trade) {
        // 1. Debit Buyer USD, Credit Buyer BTC
        updateBalance(trade.buyerId(), "USD", trade.price().multiply(trade.quantity()).negate());
        updateBalance(trade.buyerId(), trade.symbol().split("-")[0], trade.quantity());

        // 2. Credit Seller USD, Debit Seller BTC
        updateBalance(trade.sellerId(), "USD", trade.price().multiply(trade.quantity()));
        updateBalance(trade.sellerId(), trade.symbol().split("-")[0], trade.quantity().negate());
    }

    private void updateBalance(String userName, String currency, BigDecimal amount) {
        Wallet wallet = walletRepository.findByUserNameAndCurrency(userName, currency)
            .orElseThrow(() -> new RuntimeException("Wallet not found for " + userName));
        
        wallet.setBalance(wallet.getBalance().add(amount));
        walletRepository.save(wallet);
    }
}