<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Univent - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <style>
        .event-card { transition: transform 0.2s; }
        .event-card:hover { transform: scale(1.02); }
        .hero-section { background-color: #0d6efd; color: white; padding: 40px 0; margin-bottom: 30px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">Univent</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link active" href="home.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="../booking/cart.jsp">My Cart</a></li>
            </ul>
            <form class="d-flex" action="${pageContext.request.contextPath}/SearchServlet" method="get">
                <input class="form-control me-2" type="search" name="keyword" placeholder="Search events..." aria-label="Search">
                <button class="btn btn-outline-light" type="submit">Search</button>
            </form>
            <div class="ms-3">
                <a href="../user/login.jsp" class="btn btn-warning btn-sm">Login</a>
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
    <h3 class="mb-4">Upcoming Events</h3>

    <div class="row">
        <c:forEach var="event" items="${eventList}">
            <div class="col-md-4 mb-4">
                <div class="card h-100 event-card shadow-sm">
                    <img src="${pageContext.request.contextPath}/assets/img/${event.imageUrl}" class="card-img-top" alt="Event Image" style="height: 200px; object-fit: cover;">

                    <div class="card-body">
                        <h5 class="card-title">${event.title}</h5>
                        <p class="card-text text-muted">${event.eventDate} | ${event.location}</p>
                        <h6 class="text-primary">RM ${event.price}</h6>
                        <p class="card-text">${event.description.length() > 50 ? event.description.substring(0, 50) : event.description}...</p>
                    </div>

                    <div class="card-footer bg-white border-top-0">
                        <a href="${pageContext.request.contextPath}/EventDetailsServlet?id=${event.id}" class="btn btn-primary w-100">View Details</a>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty eventList}">
            <div class="col-12 text-center text-muted">
                <p>No events found. (The Servlet needs to send data here!)</p>
            </div>
        </c:if>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>