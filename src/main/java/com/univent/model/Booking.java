package com.univent.model;

import java.io.Serializable;

public class Booking implements Serializable {

    // --- FIELDS ---
    private int id;
    private int userId;
    private int eventId;
    private String bookingDate;
    private String status;
    private String attendeeName;
    private String attendeeEmail;
    // --------------

    // --- CONSTRUCTORS ---
    public Booking() {}

    public Booking(int id, int userId, int eventId, String bookingDate, String status) {
        this.id = id;
        this.userId = userId;
        this.eventId = eventId;
        this.bookingDate = bookingDate;
        this.status = status;
    }
    // --------------------

    // --- GETTERS AND SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAttendeeName() { return attendeeName; }
    public void setAttendeeName(String attendeeName) { this.attendeeName = attendeeName; }

    public String getAttendeeEmail() { return attendeeEmail; }
    public void setAttendeeEmail(String attendeeEmail) { this.attendeeEmail = attendeeEmail; }
    // ---------------------------
}