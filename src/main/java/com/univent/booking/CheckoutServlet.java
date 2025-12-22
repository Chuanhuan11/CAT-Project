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

        // --- NEW: FETCH SAVED CARDS ---
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
        // ------------------------------

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
            // Validate New Card Fields
            String cardNumber = request.getParameter("cardNumber");
            String expiry = request.getParameter("expiry");
            String cvv = request.getParameter("cvv");

            if (cardNumber == null || cardNumber.trim().isEmpty() ||
                    expiry == null || expiry.trim().isEmpty() ||
                    cvv == null || cvv.trim().isEmpty()) {
                request.setAttribute("error", "Please fill in all payment fields.");
                doGet(request, response); // Reload page with saved cards
                return;
            }

            // --- NEW: SAVE CARD LOGIC ---
            String saveCard = request.getParameter("saveCard"); // "on" if checked
            if ("on".equals(saveCard)) {
                savePaymentMethod(userId, cardNumber, expiry);
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
                request.setAttribute("error", "Booking failed. Please try again.");
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
        // ... (Keep your existing booking transaction logic here)
        // For brevity, using the simplified version, but make sure to use the Transaction version I gave you earlier!
        String bookingSql = "INSERT INTO bookings (user_id, event_id, booking_date, status) VALUES (?, ?, ?, ?)";
        String updateSeatSql = "UPDATE events SET available_seats = available_seats - 1 WHERE id = ? AND available_seats > 0";
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            try (PreparedStatement psBooking = con.prepareStatement(bookingSql);
                 PreparedStatement psUpdate = con.prepareStatement(updateSeatSql)) {
                String date = LocalDate.now().toString();
                for (Event event : cart) {
                    psBooking.setInt(1, userId); psBooking.setInt(2, event.getId()); psBooking.setString(3, date); psBooking.setString(4, "CONFIRMED"); psBooking.addBatch();
                    psUpdate.setInt(1, event.getId()); psUpdate.addBatch();
                }
                psBooking.executeBatch();
                int[] updates = psUpdate.executeBatch();
                for(int u : updates) if(u==0) throw new SQLException("Sold out");
                con.commit();
                return true;
            } catch (Exception e) { con.rollback(); return false; }
        } catch (Exception e) { return false; } finally { if(con!=null) try{con.close();}catch(Exception e){} }
    }

    private void clearDatabaseCart(int userId) {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM cart WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}