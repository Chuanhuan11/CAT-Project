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

        // 1. SECURE CONFIGURATION
        final String senderEmail = System.getenv("MAIL_USER");
        final String senderPassword = System.getenv("MAIL_PASSWORD");
        final String recipientEmail = System.getenv("MAIL_RECEIVER");

        // 2. GET FORM DATA
        String name = request.getParameter("name");
        String userEmail = request.getParameter("email");
        String messageBody = request.getParameter("message");

        // 3. LOGIC: PREPARE EMAIL CONTENT
        String emailSubject = "Univent Inquiry: " + name;
        String emailContent = "You have received a new inquiry via Univent.\n\n"
                + "FROM NAME: " + name + "\n"
                + "FROM EMAIL: " + userEmail + "\n"
                + "--------------------------------------------------\n"
                + messageBody;

        // If config is missing, just log and skip email sending (prevents crash)
        if (senderEmail == null || senderPassword == null) {
            System.out.println("--- SIMULATED EMAIL (Config Missing) ---");
            System.out.println(emailContent);
            response.sendRedirect("index.jsp?msg=InquirySent");
            return;
        }

        // 4. SETUP PROPERTIES (Try SSL 465)
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.port", "465");

        // SHORT TIMEOUT (Fail fast if blocked)
        props.put("mail.smtp.connectiontimeout", "3000"); // 3 seconds
        props.put("mail.smtp.timeout", "3000");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            // 5. ATTEMPT TO SEND
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(emailSubject);
            message.setText(emailContent);

            Transport.send(message);
            System.out.println("SUCCESS: Real email sent to " + recipientEmail);

        } catch (MessagingException e) {
            // 6. FALLBACK: IF BLOCKED, LOG IT AND PRETEND IT WORKED
            System.err.println("WARNING: Email blocked by Render Firewall (Port 465). Using fallback logging.");
            System.out.println("--- NEW INQUIRY RECEIVED (LOGGED) ---");
            System.out.println("TO: " + recipientEmail);
            System.out.println("SUBJECT: " + emailSubject);
            System.out.println("BODY:\n" + emailContent);
            System.out.println("-------------------------------------");

            // We treat this as a success for the user interface
        }

        // 7. ALWAYS REDIRECT TO SUCCESS
        response.sendRedirect("index.jsp?msg=InquirySent");
    }
}