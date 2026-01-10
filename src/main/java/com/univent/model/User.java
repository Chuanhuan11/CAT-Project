package com.univent.model;

import java.io.Serializable;

public class User implements Serializable {
    private int id;
    private String username;
    private String email;
    private String password;
    private String role;
    private String roleRequest; // <--- NEW FIELD

    public User() {}

    public User(int id, String username, String email, String password, String role) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    // --- NEW GETTER & SETTER ---
    public String getRoleRequest() { return roleRequest; }
    public void setRoleRequest(String roleRequest) { this.roleRequest = roleRequest; }
}