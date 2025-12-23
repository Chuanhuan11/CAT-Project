<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>Shopping Cart - Univent</title>
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
            background-color: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 15px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }
        /* --- TABLE STYLING --- */
        .custom-table thead {
            background-color: #2c1a4d;
            color: white;
            border-bottom: 3px solid #ffc107; /* Gold Accent */
        }
        .custom-table th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
            padding: 15px;
            border: none;
        }
        .custom-table td {
            padding: 15px;
            vertical-align: middle;
            font-size: 1rem;
        }
        .event-title {
            color: #2c1a4d;
            font-weight: bold;
        }
        .total-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            border: 1px solid #e9ecef;
        }
    </style>
</head>
<body>

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
                <li class="nav-item"><a class="nav-link active fw-bold" href="${pageContext.request.contextPath}/CartServlet">My Cart</a></li>
            </ul>
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.username}">
                        <div class="dropdown">
                            <button class="btn btn-outline-light btn-sm dropdown-toggle fw-bold" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                Hello, ${sessionScope.username}
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                                <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ORGANIZER'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">Dashboard</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/OrderHistoryServlet">My Tickets</a></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/user/login.jsp" class="btn btn-warning btn-sm fw-bold px-3 rounded-pill">Login</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<%-- HERO HEADER (UPDATED) --%>
<div class="hero-section text-center">
    <div class="container">
        <%-- Changed from h1 display-4 to h2 --%>
        <h2 class="fw-bold">Your Shopping Cart</h2>
        <%-- Changed from p lead to p mb-0 --%>
        <p class="mb-0">Review your selected events before checkout.</p>
    </div>
</div>

<div class="container mb-5">
    <div class="content-box">
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <strong>Notice:</strong> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger text-center rounded-pill mb-4">
                <c:choose>
                    <c:when test="${param.error == 'Missing Event ID'}">Error: Event ID is missing.</c:when>
                    <c:when test="${param.error == 'Invalid Event ID'}">Error: Invalid Event ID.</c:when>
                    <c:when test="${param.error == 'Event Not Found'}">Error: Event not found.</c:when>
                    <c:otherwise>An unknown error occurred.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${empty sessionScope.cart}">
            <div class="text-center py-5">
                <div class="mb-3 text-muted" style="font-size: 4rem;">🛒</div>
                <h3 class="text-muted mb-3">Your cart is currently empty.</h3>
                <p class="text-muted mb-4">Looks like you haven't added any events yet.</p>
                <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-primary rounded-pill px-5 py-2 fw-bold" style="background-color: #2c1a4d; border: none;">
                    Browse Events
                </a>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.cart}">
            <div class="table-responsive">
                <table class="table table-hover align-middle custom-table mb-0">
                    <thead>
                    <tr>
                        <th style="width: 40%;">Event</th>
                        <th>Date</th>
                        <th>Location</th>
                        <th>Price</th>
                        <th class="text-end">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="grandTotal" value="0" />

                    <c:forEach var="item" items="${sessionScope.cart}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="event-title fw-bold">${item.title}</div>
                                </div>
                                <small class="text-muted">${item.eventDate}</small>
                            </td>

                            <td class="text-muted">RM <fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" /></td>

                                <%-- QUANTITY ADJUSTER --%>
                            <td>
                                <form action="${pageContext.request.contextPath}/CartServlet" method="post" class="d-flex m-0">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="eventId" value="${item.id}">

                                    <div class="input-group input-group-sm" style="width: 120px;">
                                        <button class="btn btn-outline-secondary" type="submit" name="quantity" value="${item.quantity - 1}">-</button>
                                        <input type="text" class="form-control text-center bg-white" value="${item.quantity}" readonly>
                                        <button class="btn btn-outline-secondary" type="submit" name="quantity" value="${item.quantity + 1}">+</button>
                                    </div>
                                </form>
                            </td>

                            <td class="fw-bold text-dark">
                                RM <fmt:formatNumber value="${item.price * item.quantity}" type="number" minFractionDigits="2" />
                            </td>

                            <td class="text-end">
                                <a href="${pageContext.request.contextPath}/CartServlet?action=remove&eventId=${item.id}"
                                   class="btn btn-outline-danger btn-sm rounded-pill px-3"
                                   onclick="return confirm('Remove this event?');">
                                    Remove
                                </a>
                            </td>
                        </tr>
                        <%-- Calculate Grand Total --%>
                        <c:set var="grandTotal" value="${grandTotal + (item.price * item.quantity)}" />
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="total-section d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-outline-secondary rounded-pill px-4">
                    &larr; Continue Shopping
                </a>
                <div class="text-end d-flex align-items-center">
                    <div class="me-4 text-end">
                        <span class="text-muted small d-block">Total Amount</span>
                        <span class="h3 fw-bold text-dark m-0">RM <fmt:formatNumber value="${total}" type="number" minFractionDigits="2" /></span>
                    </div>
                    <a href="${pageContext.request.contextPath}/CheckoutServlet" class="btn btn-success btn-lg rounded-pill px-5 fw-bold shadow-sm">
                        Proceed to Checkout &rarr;
                    </a>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>