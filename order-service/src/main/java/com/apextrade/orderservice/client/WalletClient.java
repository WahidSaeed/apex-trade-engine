package com.apextrade.orderservice.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import java.math.BigDecimal;

@FeignClient(name = "wallet-service", url = "http://localhost:8083")
public interface WalletClient {

    @GetMapping("/api/v1/wallets/{userId}/{currency}/balance")
    BigDecimal getUserWalletBalanceByCurrency(@PathVariable String userId, @PathVariable String currency);
}