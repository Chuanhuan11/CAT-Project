package com.univent.booking;

import com.univent.model.Event;
import com.univent.model.PaymentMethod;
import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        // --- FETCH SAVED CARDS ---
        List<PaymentMethod> savedCards = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM payment_methods WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                savedCards.add(new PaymentMethod(
                        rs.getInt("id"),
                        rs.getString("card_alias"),
                        rs.getString("card_number"),
                        rs.getString("expiry")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("savedCards", savedCards);

        request.getRequestDispatcher("/booking/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        List<Event> cart = (List<Event>) session.getAttribute("cart");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        // Determine if using saved card or new card
        String paymentChoice = request.getParameter("paymentMethod"); // "new" or ID
        boolean isNewCard = "new".equals(paymentChoice);

        if (isNewCard) {
            // Get Parameters
            String cardNumber = request.getParameter("cardNumber");
            String expiry = request.getParameter("expiry");
            String cvv = request.getParameter("cvv");

            // --- INPUT VALIDATION START ---

            // 1. Basic Empty Check
            if (cardNumber == null || cardNumber.trim().isEmpty() ||
                    expiry == null || expiry.trim().isEmpty() ||
                    cvv == null || cvv.trim().isEmpty()) {
                request.setAttribute("error", "Please fill in all payment fields.");
                doGet(request, response); // Reload page with error
                return;
            }

            // 2. Remove spaces/dashes from card number for validation
            String cleanCardNum = cardNumber.replaceAll("[\\s-]", "");

            // 3. Validate Card Number (Must be 13 to 19 digits)
            if (!cleanCardNum.matches("\\d{13,19}")) {
                request.setAttribute("error", "Invalid Card Number. It must contain only digits (13-19).");
                doGet(request, response);
                return;
            }

            // 4. Validate CVV (Must be 3 or 4 digits)
            if (!cvv.matches("\\d{3,4}")) {
                request.setAttribute("error", "Invalid CVV. It must be 3 or 4 digits.");
                doGet(request, response);
                return;
            }

            // 5. Validate Expiry Format (MM/YY)
            if (!expiry.matches("(0[1-9]|1[0-2])/\\d{2}")) {
                request.setAttribute("error", "Invalid Expiry format. Use MM/YY (e.g., 12/26).");
                doGet(request, response);
                return;
            }

            // 6. Validate Card is Not Expired
            try {
                String[] parts = expiry.split("/");
                int expMonth = Integer.parseInt(parts[0]);
                int expYear = 2000 + Integer.parseInt(parts[1]); // Convert "26" to 2026

                YearMonth expDate = YearMonth.of(expYear, expMonth);
                YearMonth now = YearMonth.now();

                if (expDate.isBefore(now)) {
                    request.setAttribute("error", "Card has expired.");
                    doGet(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Invalid Expiry Date logic.");
                doGet(request, response);
                return;
            }
            // --- INPUT VALIDATION END ---

            // Save Card Logic (Only if validation passes)
            String saveCard = request.getParameter("saveCard");
            if ("on".equals(saveCard)) {
                savePaymentMethod(userId, cleanCardNum, expiry);
            }
        }

        // Process Payment (Dummy Logic)
        if (cart != null && !cart.isEmpty()) {
            boolean success = saveBookings(userId, cart);
            if (success) {
                clearDatabaseCart(userId);
                session.removeAttribute("cart");
                request.setAttribute("message", "Payment Successful! Tickets sent to your email.");
                request.getRequestDispatcher("/booking/checkout.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Booking failed. Some items may be sold out.");
                doGet(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
        }
    }

    // --- HELPER TO SAVE CARD ---
    private void savePaymentMethod(int userId, String number, String expiry) {
        // Create an Alias like "Visa ending 1234"
        String last4 = number.length() > 4 ? number.substring(number.length() - 4) : number;
        String alias = "Card ending " + last4;

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO payment_methods (user_id, card_alias, card_number, expiry) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, alias);
            ps.setString(3, number); // In real app, encrypt this!
            ps.setString(4, expiry);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- EXISTING METHODS (Bookings & Cart) ---
    private boolean saveBookings(int userId, List<Event> cart) {
        String bookingSql = "INSERT INTO bookings (user_id, event_id, booking_date, status) VALUES (?, ?, ?, ?)";
        String updateSeatSql = "UPDATE events SET available_seats = available_seats - 1 WHERE id = ? AND available_seats > 0";
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start Transaction

            try (PreparedStatement psBooking = con.prepareStatement(bookingSql);
                 PreparedStatement psUpdate = con.prepareStatement(updateSeatSql)) {
                String date = LocalDate.now().toString();

                for (Event event : cart) {
                    // Add Booking
                    psBooking.setInt(1, userId);
                    psBooking.setInt(2, event.getId());
                    psBooking.setString(3, date);
                    psBooking.setString(4, "CONFIRMED");
                    psBooking.addBatch();

                    // Decrease Seats
                    psUpdate.setInt(1, event.getId());
                    psUpdate.addBatch();
                }

                psBooking.executeBatch();
                int[] updates = psUpdate.executeBatch();

                // Check if any update failed (returned 0 rows updated)
                for (int u : updates) {
                    if (u == 0) throw new SQLException("Sold out");
                }

                con.commit();
                return true;

            } catch (Exception e) {
                con.rollback();
                return false;
            }
        } catch (Exception e) {
            return false;
        } finally {
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
    }

    private void clearDatabaseCart(int userId) {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM cart WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}