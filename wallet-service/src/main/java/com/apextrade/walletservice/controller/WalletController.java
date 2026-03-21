package com.apextrade.walletservice.controller;

import com.apextrade.walletservice.model.Wallet;
import com.apextrade.walletservice.service.WalletService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/v1/wallets")
public class WalletController {

    private final WalletService walletService;

    public WalletController(WalletService walletService) {
        this.walletService = walletService;
    }

    @GetMapping("/{userId}/balance")
    public ResponseEntity<List<Wallet>> getUserBalances(@PathVariable String userId) {
        return ResponseEntity.ok(walletService.getWalletsByUserId(userId));
    }

    @GetMapping("/{userId}/{currency}/balance")
    public ResponseEntity<BigDecimal> getUserWalletBalanceByCurrency(@PathVariable String userId, @PathVariable String currency) {
        return ResponseEntity.ok(walletService.getWalletsByUserIdAndCurrency(userId, currency));
    }
}