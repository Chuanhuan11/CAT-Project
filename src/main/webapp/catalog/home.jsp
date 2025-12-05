<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Univent - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        .event-card { transition: transform 0.2s; }
        .event-card:hover { transform: scale(1.02); }
        .hero-section { background-color: #0d6efd; color: white; padding: 40px 0; margin-bottom: 30px; }
        .card-img-top { height: 200px; object-fit: cover; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/EventListServlet">Univent</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/EventListServlet">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/booking/cart.jsp">My Cart</a>
                </li>
            </ul>

            <form class="d-flex" action="${pageContext.request.contextPath}/SearchServlet" method="get">
                <input class="form-control me-2" type="search" name="keyword" placeholder="Search events..." aria-label="Search" value="${param.keyword}">
                <button class="btn btn-outline-light" type="submit">Search</button>
            </form>

            <div class="ms-3">
                <a href="${pageContext.request.contextPath}/user/login.jsp" class="btn btn-warning btn-sm">Login</a>
            </div>
        </div>
    </div>
</nav>

<div class="hero-section text-center">
    <div class="container">
        <h1>Welcome to Univent</h1>
        <p>Discover and book the best events at USM.</p>
    </div>
</div>

<div class="container mb-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3>Upcoming Events</h3>

        <c:if test="${not empty param.keyword}">
            <div class="alert alert-info py-1 px-3 m-0 d-flex align-items-center">
                <small class="me-3">Results for: <strong>${param.keyword}</strong></small>
                <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-close btn-sm" aria-label="Clear Search"></a>
            </div>
        </c:if>
    </div>

    <div class="row">
        <c:forEach var="event" items="${eventList}">
            <div class="col-md-4 mb-4">
                <div class="card h-100 event-card shadow-sm">
                    <img src="${pageContext.request.contextPath}/assets/img/${event.imageUrl}" class="card-img-top" alt="${event.title}">

                    <div class="card-body">
                        <h5 class="card-title">${event.title}</h5>
                        <p class="card-text text-muted small">${event.eventDate} | ${event.location}</p>
                        <h6 class="text-primary">RM ${event.price}</h6>
                        <p class="card-text">
                                ${event.description.length() > 60 ? event.description.substring(0, 60).concat('...') : event.description}
                        </p>
                    </div>

                    <div class="card-footer bg-white border-top-0">
                        <a href="${pageContext.request.contextPath}/EventDetailsServlet?id=${event.id}" class="btn btn-primary w-100">View Details</a>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty eventList}">
            <div class="col-12 text-center py-5">
                <h4 class="text-muted">No events found.</h4>
                <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-outline-primary mt-2">Refresh Catalog</a>
            </div>
        </c:if>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>