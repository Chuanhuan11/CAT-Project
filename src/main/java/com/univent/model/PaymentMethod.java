package com.univent.model;

public class PaymentMethod {

    // --- ATTRIBUTES ---
    private int id;
    private String cardAlias;
    private String cardNumber;
    private String expiry;
    // ------------------

    // --- CONSTRUCTORS ---
    public PaymentMethod() {}

    public PaymentMethod(int id, String cardAlias, String cardNumber, String expiry) {
        this.id = id;
        this.cardAlias = cardAlias;
        this.cardNumber = cardNumber;
        this.expiry = expiry;
    }
    // --------------------

    // --- GETTERS AND SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCardAlias() { return cardAlias; }
    public void setCardAlias(String cardAlias) { this.cardAlias = cardAlias; }

    public String getCardNumber() { return cardNumber; }
    public void setCardNumber(String cardNumber) { this.cardNumber = cardNumber; }

    public String getExpiry() { return expiry; }
    public void setExpiry(String expiry) { this.expiry = expiry; }
    // ---------------------------
}