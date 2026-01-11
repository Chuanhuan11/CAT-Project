<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Terms of Service - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        /* --- THEME SETUP --- */
        body {
            background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .navbar { box-shadow: 0 4px 10px rgba(0,0,0,0.3); }

        /* HERO BANNER */
        .hero-section {
            background-color: rgba(50, 13, 70, 0.95);
            color: white;
            padding: 50px 0 40px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

        /* GLASS CONTENT BOX */
        .content-box {
            background-color: rgba(255, 255, 255, 0.96);
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.15);
            border: 1px solid rgba(255, 255, 255, 0.5);
        }

        /* RULE STYLING */
        .rule-item {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px dashed #ddd;
        }
        .rule-item:last-child { border-bottom: none; margin-bottom: 0; }

        .rule-header {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }

        .rule-number {
            background-color: #2c1a4d;
            color: white;
            font-weight: bold;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            margin-right: 12px;
            flex-shrink: 0;
        }

        .rule-title {
            color: #2c1a4d;
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0;
        }

        .rule-text {
            color: #555;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-left: 40px; /* Align with title */
            text-align: justify;
        }

        /* DISCLAIMER BOX */
        .disclaimer-box {
            background-color: #fff3cd;
            border: 1px solid #ffecb5;
            color: #856404;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
            font-size: 0.9rem;
            text-align: center;
        }

        /* --- MOBILE OPTIMIZATION --- */
        @media (max-width: 576px) {
            .hero-section { padding: 30px 0; }
            .content-box {
                padding: 25px 20px; /* Tighter padding for mobile */
                border-radius: 15px;
                margin-top: -20px; /* Slight overlap for modern look */
            }
            .rule-text {
                margin-left: 0; /* Remove indent on small screens */
                text-align: left;
                font-size: 0.9rem;
            }
            .rule-header { margin-bottom: 5px; }
            .rule-title { font-size: 1rem; }
            .navbar-brand { font-size: 1.1rem; }
            h2.fw-bold { font-size: 1.5rem; }
        }
    </style>
</head>
<body>

<%-- --- NAVBAR --- --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="me-2 rounded-circle border border-white">
            <span class="ms-2">Univent</span>
        </a>
        <div class="ms-auto">
            <a href="${pageContext.request.contextPath}/user/register.jsp" class="btn btn-outline-light btn-sm rounded-pill px-3">Close</a>
        </div>
    </div>
</nav>
<%-- -------------- --%>

<%-- --- HERO BANNER --- --%>
<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">Terms of Service</h2>
        <p class="mb-0 small opacity-75">Usage Policy & Guidelines</p>
    </div>
</div>
<%-- ------------------- --%>

<%-- --- MAIN CONTENT --- --%>
<div class="container">
    <div class="content-box mx-auto" style="max-width: 850px;">

        <%-- Project Disclaimer --%>
        <div class="disclaimer-box">
            <strong>Project Disclaimer:</strong> This platform is a prototype developed for educational purposes at Universiti Sains Malaysia (USM). No actual financial transactions take place.
        </div>

        <%-- Rule 1: Eligibility --%>
        <div class="rule-item">
            <div class="rule-header">
                <div class="rule-number">1</div>
                <h5 class="rule-title">Account Eligibility</h5>
            </div>
            <p class="rule-text">
                Access is strictly restricted to current USM students. Registration requires a valid university email address ending in <strong>.usm.my</strong>. Accounts created with personal email addresses (e.g., Gmail, Yahoo) will be automatically rejected by the system validation logic.
            </p>
        </div>

        <%-- Rule 2: Organizer Role --%>
        <div class="rule-item">
            <div class="rule-header">
                <div class="rule-number">2</div>
                <h5 class="rule-title">Event Organizer Responsibilities</h5>
            </div>
            <p class="rule-text">
                Users applying for "Organizer" status are subject to Administrative approval. Organizers are responsible for the accuracy of event details (Date, Venue, Pricing). All uploaded media (posters/images) must comply with the university's code of conduct.
            </p>
        </div>

        <%-- Rule 3: Content Approval --%>
        <div class="rule-item">
            <div class="rule-header">
                <div class="rule-number">3</div>
                <h5 class="rule-title">Event Approval Process</h5>
            </div>
            <p class="rule-text">
                To ensure quality assurance, all events created by Organizers are initially set to a <strong>"Pending"</strong> status. They will not appear in the public catalog until reviewed and approved by a System Administrator. The Administration reserves the right to reject proposals that violate guidelines.
            </p>
        </div>

        <%-- Rule 4: Ticketing --%>
        <div class="rule-item">
            <div class="rule-header">
                <div class="rule-number">4</div>
                <h5 class="rule-title">Digital Ticketing & Attendance</h5>
            </div>
            <p class="rule-text">
                Upon successful checkout, a unique <strong>QR Code Digital Ticket</strong> is generated for each booking. This code serves as the official entry pass. Attendees must present this QR code via the "My Tickets" dashboard for verification at the event venue.
            </p>
        </div>

        <%-- Rule 5: Payments --%>
        <div class="rule-item">
            <div class="rule-header">
                <div class="rule-number">5</div>
                <h5 class="rule-title">Simulated Transactions</h5>
            </div>
            <p class="rule-text">
                All pricing displayed (RM) and checkout processes are <strong>simulated</strong>. No real banking credentials should be entered, and no actual funds will be deducted. "Sold Out" statuses reflect the system's capacity tracking logic, not financial revenue.
            </p>
        </div>

        <%-- Action Button --%>
        <div class="text-center mt-5">
            <a href="${pageContext.request.contextPath}/user/register.jsp?agree=true" class="btn btn-primary btn-lg rounded-pill px-5 shadow fw-bold" style="background-color: #2c1a4d; border: none; width: 100%; max-width: 300px;">
                I Understand & Agree
            </a>
            <div class="mt-2 text-muted small">By clicking above, you return to the registration page.</div>
        </div>

    </div>
</div>
<%-- -------------------- --%>

<jsp:include page="../footer.jsp" />
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

</body>
</html>