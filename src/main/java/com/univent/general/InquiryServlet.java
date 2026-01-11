package com.univent.general;

import java.io.IOException;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/InquiryServlet")
public class InquiryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // --- 1. SECURE CONFIGURATION ---
        final String senderEmail = System.getenv("MAIL_USER");
        final String senderPassword = System.getenv("MAIL_PASSWORD");

        final String recipientEmail = System.getenv("MAIL_RECEIVER");

        // Safety Check: If config is missing, log error and skip email
        if (senderEmail == null || senderPassword == null) {
            System.err.println("CRITICAL ERROR: MAIL_USER or MAIL_PASSWORD environment variables are missing!");
            response.sendRedirect("index.jsp?msg=SystemError");
            return;
        }

        // --- 2. GET FORM DATA ---
        String name = request.getParameter("name");
        String userEmail = request.getParameter("email");
        String messageBody = request.getParameter("message");

        // --- 3. SETUP GMAIL PROPERTIES ---
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // --- 4. AUTHENTICATE ---
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            // --- 5. COMPOSE EMAIL ---
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));

            message.setSubject("Univent Inquiry: " + name);

            String emailContent = "You have received a new inquiry via Univent.\n\n"
                    + "FROM NAME: " + name + "\n"
                    + "FROM EMAIL: " + userEmail + "\n"
                    + "--------------------------------------------------\n"
                    + messageBody;

            message.setText(emailContent);

            // --- 6. SEND EMAIL ---
            Transport.send(message);
            System.out.println("SUCCESS: Inquiry email sent to " + recipientEmail);

            // --- 7. REDIRECT USER ---
            response.sendRedirect("index.jsp?msg=InquirySent");

        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("ERROR: Failed to send email. Check App Password or Network.");
            response.sendRedirect("index.jsp?msg=ErrorSending");
        }
    }
}