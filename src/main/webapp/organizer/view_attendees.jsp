<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Attendees - ${eventTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
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
            background-color: rgba(255, 255, 255, 0.98);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }

        /* TABLE STYLES */
        .custom-table thead { background-color: #2c1a4d; color: white; border-bottom: 4px solid #ffc107; }
        .custom-table th { padding: 15px; border: none; text-transform: uppercase; font-size: 0.85rem; }
        .custom-table td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #eee; }
        .custom-table tbody tr:hover { background-color: rgba(255, 193, 7, 0.1); border-left: 4px solid #ffc107; }

        /* Typography for Table */
        .col-id { color: #888; font-weight: bold; font-size: 0.9rem; }
        .col-name { font-weight: 600; color: #2c1a4d; font-size: 1.05rem; }
        .col-email { color: #555; font-style: italic; }

        /* --- AVATAR STYLES --- */
        .user-avatar-btn {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.5);
            border-radius: 50%;
            padding: 0;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .user-avatar-btn:hover, .user-avatar-btn.show {
            background: rgba(255,255,255,0.2);
            border-color: #fff;
        }
        .user-avatar-svg {
            fill: white;
            width: 24px;
            height: 24px;
        }
        /* Hide the default dropdown arrow */
        .dropdown-toggle::after {
            display: none !important;
        }

        /* --- MOBILE RESPONSIVENESS --- */
        @media (max-width: 768px) {
            /* 1. HEADER FIX (Stack vertically) */
            .dashboard-header {
                flex-direction: column !important;
                align-items: flex-start !important;
                gap: 15px;
            }
            .dashboard-header > div { width: 100% !important; }
            .dashboard-header .button-group { display: flex; width: 100%; }
            .dashboard-header .btn {
                flex: 1;
                width: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .dashboard-header .text-container { margin-bottom: 0 !important; }

            /* 2. TABLE OVERFLOW FIX (Hide ID and Email columns) */
            /* Hide the cells */
            .col-id { display: none; }

            /* Hide the headers (1=ID, 3=Email) */
            .custom-table th:nth-child(1) { display: none; }

            /* Adjust name font size */
            .col-name { font-size: 0.95rem; }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="me-2 rounded-circle">
            Univent Organizer
        </a>
        <div class="d-flex align-items-center ms-auto">
            <div class="dropdown">
                <%-- REPLACED TEXT WITH AVATAR --%>
                <button class="user-avatar-btn dropdown-toggle" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    <svg class="user-avatar-svg" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </button>
                <ul class="dropdown-menu dropdown-menu-end mt-2" aria-labelledby="userMenu">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/EventListServlet">Home Page</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">Attendees List</h2>
        <p class="mb-0">Managing: <strong style="color: #ffc107;"><c:out value="${eventTitle}"/></strong></p>
    </div>
</div>

<div class="container">
    <div class="content-box">
        <div class="d-flex justify-content-between align-items-center mb-4 dashboard-header">
            <div class="text-container">
                <h3 class="fw-bold text-dark mb-0">Registered Tickets</h3>
            </div>
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/OrganiserDashboardServlet" class="btn btn-outline-secondary rounded-pill">Back to Dashboard</a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table custom-table mb-0">
                <thead>
                <tr>
                    <th style="width: 15%;">Ticket ID</th>
                    <th style="width: 30%;">User Name</th>
                    <th style="width: 40%;">Email</th>
                    <th style="width: 15%;" class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="booking" items="${attendees}">
                    <tr>
                        <td class="col-id">#${booking.id}</td>
                        <td class="col-name">${booking.attendeeName}</td>
                        <td class="col-email">${booking.attendeeEmail}</td>
                        <td class="text-end">
                            <a href="${pageContext.request.contextPath}/DeleteBookingServlet?eventId=${eventId}&bookingId=${booking.id}"
                               class="btn btn-outline-danger btn-sm rounded-pill px-3"
                               onclick="return confirm('Cancel Ticket #${booking.id}?');">
                                Remove
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty attendees}">
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted">
                            <h5>No tickets sold for this event yet.</h5>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>