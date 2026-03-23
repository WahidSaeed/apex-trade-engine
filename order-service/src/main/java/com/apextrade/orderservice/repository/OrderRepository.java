package com.apextrade.orderservice.repository;

import com.apextrade.orderservice.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Long> {
    Optional<Order> findByUserNameAndSymbol(String userName, String symbol);
    List<Order> findByUserName(String userName);
}