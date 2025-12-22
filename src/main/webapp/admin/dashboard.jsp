<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Dashboard - Univent</title>
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
            background-color: rgba(50, 13, 70, 0.9); /* Brand Purple */
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

        /* --- TABLE STYLING --- */
        .table-container {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #ddd;
        }

        /* FEATURE ROW (HEADER) COLORING */
        .custom-table thead {
            background-color: #2c1a4d; /* Brand Purple */
            color: white;
            border-bottom: 4px solid #ffc107; /* GOLD ACCENT LINE */
        }

        .custom-table th {
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85rem;
            padding: 18px 15px;
            border: none;
            letter-spacing: 0.5px;
        }

        .custom-table td {
            padding: 18px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #eee;
            color: #444;
        }

        /* ZEBRA STRIPING */
        .custom-table tbody tr:nth-of-type(even) {
            background-color: rgba(44, 26, 77, 0.04); /* Light Purple Tint */
        }
        .custom-table tbody tr:nth-of-type(odd) {
            background-color: #ffffff;
        }

        /* HOVER EFFECT */
        .custom-table tbody tr {
            transition: all 0.2s ease;
            border-left: 4px solid transparent;
        }

        .custom-table tbody tr:hover {
            background-color: rgba(255, 193, 7, 0.1); /* Gold Tint on Hover */
            border-left: 4px solid #ffc107; /* Gold Left Border */
        }

        /* Typography */
        .col-id { color: #888; font-weight: bold; font-size: 0.9rem; }
        .col-title { font-size: 1.05rem; color: #000; }
        .col-price { font-family: 'Segoe UI', sans-serif; font-size: 1.1rem; }
        .col-date { font-weight: 500; color: #555; }
        .col-venue { color: #666; font-style: italic; }

    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="me-2 rounded-circle">
            Univent ${sessionScope.role == 'ADMIN' ? 'Admin' : 'Organizer'}
        </a>
        <div class="d-flex align-items-center ms-auto">
            <div class="dropdown">
                <button class="btn btn-outline-light btn-sm dropdown-toggle fw-bold" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    Hello, ${sessionScope.username}
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/index.jsp">Home Page</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<%-- HERO HEADER --%>
<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">Event Management</h2>
        <p class="mb-0">Add, Modify, or Remove Campus Events</p>
    </div>
</div>

<%-- MAIN CONTENT --%>
<div class="container">
    <div class="content-box">

        <%-- TOOLBAR --%>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-0">Current Events</h3>
                <p class="text-muted small mb-0">Manage your event listings below</p>
            </div>

            <div>
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="btn btn-outline-dark rounded-pill me-2">
                        Users
                    </a>
                </c:if>
                <a href="${pageContext.request.contextPath}/AddEventServlet" class="btn btn-success rounded-pill px-4 fw-bold">
                    + Add New Event
                </a>
            </div>
        </div>

        <%-- PROFESSIONAL TABLE --%>
        <div class="table-responsive table-container">
            <table class="table custom-table mb-0">
                <thead>
                <tr>
                    <th style="width: 5%;">ID</th>
                    <th style="width: 25%;">Event Title</th>
                    <%-- SEPARATED COLUMNS --%>
                    <th style="width: 15%;">Date</th>
                    <th style="width: 15%;">Venue</th>

                    <th style="width: 10%;">Price</th>
                    <th style="width: 10%;" class="text-center">Seats</th>
                    <th style="width: 20%;" class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="event" items="${eventList}">
                    <tr>
                        <td class="col-id">#${event.id}</td>

                        <td>
                            <strong class="col-title">${event.title}</strong>
                        </td>

                            <%-- SEPARATED DATA CELLS --%>
                        <td class="col-date">${event.eventDate}</td>
                        <td class="col-venue">${event.location}</td>

                        <td class="col-price text-primary fw-bold">RM ${event.price}</td>

                        <td class="text-center">
                            <span class="badge rounded-pill ${event.availableSeats > 0 ? 'bg-success' : 'bg-danger'} px-3">
                                ${event.availableSeats} Left
                            </span>
                        </td>

                        <td class="text-end">
                            <div class="btn-group" role="group">
                                <a href="${pageContext.request.contextPath}/AddEventServlet?id=${event.id}"
                                   class="btn btn-outline-primary btn-sm rounded-start">Edit</a>

                                <a href="${pageContext.request.contextPath}/EventAttendeesServlet?eventId=${event.id}&eventTitle=${event.title}"
                                   class="btn btn-outline-info btn-sm">Attendees</a>

                                <a href="${pageContext.request.contextPath}/DeleteEventServlet?id=${event.id}"
                                   class="btn btn-outline-danger btn-sm rounded-end"
                                   onclick="return confirm('Are you sure you want to delete this event?');">Delete</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty eventList}">
                    <tr>
                            <%-- UPDATED COLSPAN TO 7 --%>
                        <td colspan="7" class="text-center py-5 text-muted">
                            <h5>No events found.</h5>
                            <p>Click "Add New Event" to get started.</p>
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