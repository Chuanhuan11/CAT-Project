<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Event Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
</head>
<body class="bg-light">

<%-- UPDATED NAVBAR WITH LOGO --%>
<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/EventListServlet">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png"
                 alt="Logo" width="30" height="30"
                 class="d-inline-block align-text-top me-2 rounded-circle">
            Univent
        </a>
        <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-outline-light btn-sm">Back to Catalog</a>
    </div>
</nav>

<div class="container">
    <div class="card shadow-sm">
        <div class="row g-0">
            <%-- Left Column: Event Image --%>
            <div class="col-md-6">

                <%-- UPDATED: Image Placeholder Logic --%>
                <c:choose>
                    <c:when test="${not empty event.imageUrl && event.imageUrl.startsWith('http')}">
                        <img src="${event.imageUrl}" class="img-fluid rounded mb-3" alt="${event.title}">
                    </c:when>
                    <c:when test="${not empty event.imageUrl}">
                        <img src="${pageContext.request.contextPath}/assets/img/${event.imageUrl}" class="img-fluid rounded mb-3" alt="${event.title}">
                    </c:when>
                    <c:otherwise>
                        <img src="https://placehold.co/800x400?text=No+Image" class="img-fluid rounded mb-3" alt="Placeholder">
                    </c:otherwise>
                </c:choose>

            </div>

            <%-- Right Column: Event Details --%>
            <div class="col-md-6">
                <div class="card-body p-5">
                    <h2 class="card-title display-5 mb-3">${event.title}</h2>

                    <div class="mb-3">
                        <span class="badge bg-primary fs-6">Date: ${event.eventDate}</span>
                        <span class="badge bg-secondary fs-6">Venue: ${event.location}</span>
                    </div>

                    <h3 class="text-success mb-4">
                        Price:
                        <c:choose>
                            <c:when test="${event.price == 0}">FREE</c:when>
                            <c:otherwise>RM <fmt:formatNumber value="${event.price}" type="number" minFractionDigits="2" /></c:otherwise>
                        </c:choose>
                    </h3>

                    <h5 class="mt-4">About this Event:</h5>
                    <p class="card-text lead">${event.description}</p>

                    <hr class="my-4">

                    <%-- Add to Cart Form --%>
                    <div class="">
                        <form action="${pageContext.request.contextPath}/CartServlet" method="post">
                            <input type="hidden" name="eventId" value="${event.id}">
                            <input type="hidden" name="action" value="add">

                            <%-- Added Quantity Counter from previous fix --%>
                            <div class="mb-4">
                                <label class="form-label fw-bold">Select Quantity:</label>
                                <div class="d-flex align-items-center">
                                    <div class="input-group" style="width: 160px;">
                                        <button class="btn btn-outline-secondary" type="button" onclick="updateQuantity(-1)">-</button>
                                        <input type="text" id="quantityDisplay" name="quantity" class="form-control text-center fw-bold bg-white"
                                               value="1" readonly>
                                        <button class="btn btn-outline-secondary" type="button" onclick="updateQuantity(1)">+</button>
                                    </div>
                                    <span class="ms-3 text-muted small">
                                        Only ${event.availableSeats} seats left!
                                    </span>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success btn-lg" ${event.availableSeats <= 0 ? 'disabled' : ''}>
                                    ${event.availableSeats > 0 ? 'Add to Cart' : 'Sold Out'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

<%-- JAVASCRIPT FOR QUANTITY COUNTER --%>
<script>
    var maxSeats = ${event.availableSeats};

    function updateQuantity(change) {
        var input = document.getElementById('quantityDisplay');
        var currentVal = parseInt(input.value);
        var newVal = currentVal + change;

        if (newVal >= 1 && newVal <= maxSeats) {
            input.value = newVal;
        }
    }
</script>

</body>
</html>