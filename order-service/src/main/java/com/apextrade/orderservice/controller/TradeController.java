package com.apextrade.orderservice.controller;

import com.apextrade.orderservice.model.Trade;
import com.apextrade.orderservice.repository.TradeRepository;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/trades")
public class TradeController {

    private final TradeRepository tradeRepository;

    public TradeController(TradeRepository tradeRepository) {
        this.tradeRepository = tradeRepository;
    }

    @GetMapping("/{symbol}")
    public ResponseEntity<List<Trade>> getTradeHistory(@PathVariable String symbol) {
        return ResponseEntity.ok(tradeRepository.findBySymbolOrderByExecutedAtDesc(symbol));
    }
}