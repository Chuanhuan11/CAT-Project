package com.univent.model;

import java.io.Serializable;
import java.sql.Date;

public class Event implements Serializable {
    private int id;
    private String title;
    private String description;
    private Date eventDate;
    private String location;
    private double price;
    private String imageUrl;
    private int totalSeats;
    private int availableSeats;
    private int organizerId;

    public Event() {}

    public Event(int id, String title, String description, Date eventDate, String location, double price, String imageUrl, int totalSeats, int availableSeats, int organizerId) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.eventDate = eventDate;
        this.location = location;
        this.price = price;
        this.imageUrl = imageUrl;
        this.totalSeats = totalSeats;
        this.availableSeats = availableSeats;
        this.organizerId = organizerId;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getEventDate() { return eventDate; } // Return type is Date
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; } // Parameter is Date

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }

    public int getOrganizerId() { return organizerId; }
    public void setOrganizerId(int organizerId) { this.organizerId = organizerId; }
}