<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rules & Regulations - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        /* --- STANDARD UNIVENT THEME --- */
        body {
            background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            /* Removed flex centering so the page scrolls naturally */
        }
        .navbar { box-shadow: 0 4px 10px rgba(0,0,0,0.3); }

        /* PURPLE HERO BANNER */
        .hero-section {
            background-color: rgba(50, 13, 70, 0.9);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

        /* GLASS CONTENT BOX */
        .content-box {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 15px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }

        /* RULE ITEMS */
        .rule-item {
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }
        .rule-item:last-child { border-bottom: none; }

        .rule-title {
            color: #2c1a4d;
            font-weight: bold;
            font-size: 1.1rem;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>

<%-- 1. NAVBAR --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="me-2 rounded-circle">
            Univent
        </a>
        <div class="ms-auto">
            <a href="${pageContext.request.contextPath}/user/register.jsp" class="btn btn-outline-light btn-sm rounded-pill px-3">Back to Sign Up</a>
        </div>
    </div>
</nav>

<%-- 2. HERO BANNER --%>
<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">Rules & Regulations</h2>
        <p class="mb-0">Please read carefully before joining Univent</p>
    </div>
</div>

<%-- 3. MAIN CONTENT --%>
<div class="container">
    <div class="content-box mx-auto" style="max-width: 900px;">

        <div class="rule-item">
            <div class="rule-title">1. Student Identity Verification</div>
            <p class="text-muted mb-0">Only current USM students with a valid student email address (ending in .usm.my) are allowed to register. False identity usage may lead to account suspension.</p>
        </div>

        <div class="rule-item">
            <div class="rule-title">2. Event Registration & Attendance</div>
            <p class="text-muted mb-0">Students should only register for events they intend to attend. Repeated "no-shows" (booking but not attending) may lead to restrictions on future bookings.</p>
        </div>

        <div class="rule-item">
            <div class="rule-title">3. Payment Policy</div>
            <p class="text-muted mb-0">All payments made on this platform are simulated for project demonstration purposes. No actual real-world money transactions will occur.</p>
        </div>

        <div class="rule-item">
            <div class="rule-title">4. Respectful Conduct</div>
            <p class="text-muted mb-0">Harassment, hate speech, or abusive behavior towards event organizers or other participants is strictly prohibited.</p>
        </div>

        <div class="rule-item">
            <div class="rule-title">5. Cancellation Policy</div>
            <p class="text-muted mb-0">If you cannot attend an event, please cancel your registration at least 24 hours in advance to allow other students to join.</p>
        </div>

        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/user/register.jsp" class="btn btn-primary btn-lg rounded-pill px-5" style="background-color: #2c1a4d; border: none;">
                I Understand & Agree
            </a>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>