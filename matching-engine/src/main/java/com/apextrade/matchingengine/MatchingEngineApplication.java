package com.apextrade.matchingengine; // Must match the folder structure

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class MatchingEngineApplication {
    public static void main(String[] args) {
        SpringApplication.run(MatchingEngineApplication.class, args);
    }
}