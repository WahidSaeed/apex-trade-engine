package com.apextrade.dto.http;

import lombok.*;

@Getter @Setter 
@NoArgsConstructor @AllArgsConstructor
@Builder
public class ApiResponse<T> {
    private String status;
    private T returnValue;
    private String error;
}