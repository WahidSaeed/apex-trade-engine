package com.apextrade.orderservice.repository;

import com.apextrade.orderservice.model.Trade;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface TradeRepository extends JpaRepository<Trade, Long> {
    List<Trade> findBySymbolOrderByExecutedAtDesc(String symbol);
}