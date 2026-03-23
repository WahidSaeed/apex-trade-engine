package com.apextrade.apigateway.filter;

import com.apextrade.apigateway.service.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

@Component
public class AuthenticationFilter extends AbstractGatewayFilterFactory<AuthenticationFilter.Config> {

    @Autowired
    private RouteValidator validator; // To skip auth for login/register

    @Autowired
    private JwtService jwtService;

    public AuthenticationFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return ((exchange, chain) -> {
            // 1. Check if the route is secured
            if (validator.isSecured.test(exchange.getRequest())) {
                
                // 2. Check for Authorization Header
                if (!exchange.getRequest().getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                    throw new RuntimeException("Missing Authorization Header");
                }

                String authHeader = exchange.getRequest().getHeaders().get(HttpHeaders.AUTHORIZATION).get(0);
                if (authHeader != null && authHeader.startsWith("Bearer ")) {
                    authHeader = authHeader.substring(7);
                }

                try {
                    String username = jwtService.getUserName(authHeader);
                    
                    // 4. Mutate request to pass username to Order/Wallet services
                    exchange.getRequest().mutate()
                            .header("loggedInUser", username)
                            .build();

                } catch (Exception e) {
                    throw new RuntimeException("Unauthorized access to the exchange");
                }
            }
            return chain.filter(exchange);
        });
    }

    public static class Config {}
}