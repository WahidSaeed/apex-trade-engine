package com.apextrade.walletservice.repository;

import com.apextrade.walletservice.model.Wallet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WalletRepository extends JpaRepository<Wallet, Long> {
    Optional<Wallet> findByUserNameAndCurrency(String userName, String currency);
    List<Wallet> findByUserName(String userName);
}