<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>My Tickets - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        /* --- THEME SETUP --- */
        body {
            background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
        }
        .navbar { box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
        .hero-section {
            background-color: rgba(50, 13, 70, 0.9);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }
        .content-box {
            background-color: rgba(255, 255, 255, 0.96);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }

        /* --- TICKET STYLING --- */
        .ticket-row {
            transition: all 0.2s;
            border-left: 4px solid transparent;
        }
        .ticket-row:hover {
            background-color: rgba(44, 26, 77, 0.05);
            border-left: 4px solid #2c1a4d;
        }

        /* DIGITAL TICKET MODAL DESIGN */
        .digital-ticket {
            border: 2px dashed #2c1a4d;
            border-radius: 20px;
            overflow: hidden;
            background: white;
            position: relative;
        }
        .ticket-header {
            background-color: #2c1a4d;
            color: white;
            padding: 20px;
            text-align: center;
        }
        .ticket-body {
            padding: 30px;
            text-align: center;
        }

        .qr-container {
            margin: 20px auto;
            border: 1px solid #eee;
            padding: 15px;
            background: white;
            border-radius: 15px;
            width: fit-content;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .ticket-footer {
            background-color: #f8f9fa;
            padding: 15px;
            text-align: center;
            font-size: 0.8rem;
            color: #666;
            border-top: 1px dashed #ccc;
        }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="d-inline-block align-text-top me-2 rounded-circle">
            Univent
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/EventListServlet">Catalog</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/CartServlet">My Cart</a></li>
            </ul>
            <div class="d-flex align-items-center">
                <div class="dropdown">
                    <button class="btn btn-outline-light btn-sm dropdown-toggle fw-bold" type="button" id="userMenu" data-bs-toggle="dropdown">
                        Hello, ${sessionScope.username}
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ORGANIZER'}">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">Dashboard</a></li>
                            <li><hr class="dropdown-divider"></li>
                        </c:if>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>

<%-- HERO HEADER --%>
<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">My Tickets</h2>
        <p class="mb-0">Track your bookings and view digital passes</p>
    </div>
</div>

<%-- MAIN CONTENT --%>
<div class="container">
    <div class="content-box">

        <c:if test="${empty ticketList}">
            <div class="text-center py-5">
                <h3 class="text-muted">No tickets found.</h3>
                <p class="text-muted">You haven't booked any events yet.</p>
                <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-primary rounded-pill mt-3">Browse Events</a>
            </div>
        </c:if>

        <c:if test="${not empty ticketList}">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Booking ID</th>
                        <th>Event Details</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th class="text-end">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="ticket" items="${ticketList}">
                        <tr class="ticket-row">
                            <td class="fw-bold text-muted">#${ticket.bookingId}</td>
                            <td>
                                <strong style="color: #2c1a4d;">${ticket.eventTitle}</strong><br>
                                <small class="text-muted">${ticket.location}</small>
                            </td>
                            <td>${ticket.eventDate}</td>
                            <td>
                                <span class="badge rounded-pill bg-success">Confirmed</span>
                            </td>
                            <td class="text-end">
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3"
                                        data-bs-toggle="modal"
                                        data-bs-target="#ticketModal"
                                        onclick="loadTicket('${ticket.bookingId}', '${ticket.eventTitle}', '${ticket.eventDate}', '${ticket.location}', '${sessionScope.username}')">
                                    View Ticket
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
</div>

<%-- TICKET MODAL --%>
<div class="modal fade" id="ticketModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 bg-transparent">

            <div class="digital-ticket shadow-lg">
                <div class="ticket-header">
                    <h4 class="mb-0 fw-bold">UNIVENT PASS</h4>
                    <small>Official Digital Ticket</small>
                </div>

                <div class="ticket-body">
                    <h3 id="modalEventTitle" class="fw-bold mb-1" style="color: #2c1a4d;">Event Name</h3>
                    <p class="text-muted mb-3">
                        <span id="modalEventDate">Date</span> | <span id="modalEventLoc">Location</span>
                    </p>

                    <%-- QR CODE IMAGE --%>
                    <div class="qr-container">
                        <%-- This Image source is set dynamically by JavaScript --%>
                        <img id="modalQrCode" src="" alt="Scanning..." width="180" height="180">
                    </div>

                    <p class="small text-muted mt-2">Scan for details</p>

                    <div class="mt-3">
                        <span class="badge bg-light text-dark border p-2">Attendee: <strong id="modalUser">User</strong></span>
                        <span class="badge bg-light text-dark border p-2">Order #: <strong id="modalBookingId">000</strong></span>
                    </div>
                </div>

                <div class="ticket-footer">
                    &copy; Univent Inc. • valid for one entry only
                </div>
            </div>

            <div class="text-center mt-3">
                <button type="button" class="btn btn-light rounded-pill px-4 shadow-sm" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
    function loadTicket(id, title, date, loc, user) {
        // 1. Update Text Fields
        document.getElementById('modalEventTitle').innerText = title;
        document.getElementById('modalEventDate').innerText = date;
        document.getElementById('modalEventLoc').innerText = loc;
        document.getElementById('modalUser').innerText = user;
        document.getElementById('modalBookingId').innerText = id;

        // 2. Generate Rich Text Data for QR Code
        // Use \n (newline) to format the text nicely when scanned
        let textData = "UNIVENT TICKET DETAILS\n" +
            "----------------------\n" +
            "Event: " + title + "\n" +
            "Date:  " + date + "\n" +
            "Loc:   " + loc + "\n" +
            "User:  " + user + "\n" +
            "ID:    #" + id + "\n" +
            "----------------------\n" +
            "Status: VALID";

        // 3. Encode into API URL
        let qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=" + encodeURIComponent(textData);

        // 4. Update Image Source
        document.getElementById('modalQrCode').src = qrUrl;
    }
</script>

</body>
</html>