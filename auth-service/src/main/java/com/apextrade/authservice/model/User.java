package com.apextrade.authservice.model;

import jakarta.persistence.*;

@Entity @Table(name = "users", schema = "auth_schema")
public class User {
    
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String userName;

    private String password;
    

    public User() { }

    public User(String userName, String password) {
        this.userName = userName;
        this.password = password;
    }

    // Getter
    public Long getId() { return id; }
    public String getUserName() { return userName; }
    public String getPassword() { return password; }

    // Setter
    public void setUserName(String userName) { this.userName = userName; }
    public void setPassword(String password) { this.password = password; }
}