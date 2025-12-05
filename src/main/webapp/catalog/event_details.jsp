<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Event Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">Univent</a>
        <a href="home.jsp" class="btn btn-outline-light btn-sm">Back to Catalog</a>
    </div>
</nav>

<div class="container">
    <div class="card shadow-sm">
        <div class="row g-0">
            <div class="col-md-6">
                <img src="${pageContext.request.contextPath}/assets/img/${event.imageUrl}" class="img-fluid rounded-start w-100" style="height: 500px; object-fit: cover;" alt="Event Poster">
            </div>

            <div class="col-md-6">
                <div class="card-body p-5">
                    <h2 class="card-title display-5 mb-3">${event.title}</h2>

                    <div class="mb-3">
                        <span class="badge bg-primary fs-6">Date: ${event.eventDate}</span>
                        <span class="badge bg-secondary fs-6">Venue: ${event.location}</span>
                    </div>

                    <h3 class="text-success mb-4">Price: RM ${event.price}</h3>

                    <h5 class="mt-4">About this Event:</h5>
                    <p class="card-text lead">${event.description}</p>

                    <hr class="my-4">

                    <div class="d-grid gap-2">
                        <form action="${pageContext.request.contextPath}/CartServlet" method="post">
                            <input type="hidden" name="eventId" value="${event.id}">
                            <input type="hidden" name="action" value="add">

                            <button type="submit" class="btn btn-success btn-lg w-100" ${event.availableSeats <= 0 ? 'disabled' : ''}>
                                ${event.availableSeats > 0 ? 'Add to Cart' : 'Sold Out'}
                            </button>
                        </form>
                    </div>

                    <p class="mt-3 text-muted small text-center">${event.availableSeats} seats remaining</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>