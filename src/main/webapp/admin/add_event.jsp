<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Event Form - Univent</title>
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
        .content-box {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 15px;
            margin-top: 50px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

<%-- --- NAVBAR --- --%>
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
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">Dashboard</a></li>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>
<%-- -------------- --%>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="content-box">
                <div class="text-center mb-4">
                    <h2 class="fw-bold" style="color: #2c1a4d;">${event != null ? 'Edit Event' : 'Create New Event'}</h2>
                    <p class="text-muted">Fill in the details below</p>
                </div>

                <%-- --- EVENT FORM --- --%>
                <form action="${pageContext.request.contextPath}/AddEventServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${event.id}">
                    <input type="hidden" name="currentImage" value="${event.imageUrl}">

                    <div class="mb-3">
                        <label for="title" class="form-label fw-bold">Event Title</label>
                        <input type="text" id="title" name="title" class="form-control" required value="${event.title}">
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label fw-bold">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="3">${event.description}</textarea>
                    </div>

                    <div class="mb-3">
                        <label for="imageFile" class="form-label fw-bold">Event Poster</label>
                        <input class="form-control" type="file" id="imageFile" name="imageFile" accept="image/*">
                        <div class="form-text">Supported formats: JPG, PNG. Leave empty to keep current image.</div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="eventDate" class="form-label fw-bold">Date</label>
                            <input type="date" id="eventDate" name="eventDate" class="form-control" required value="${event.eventDate}">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="location" class="form-label fw-bold">Location</label>
                            <input type="text" id="location" name="location" class="form-control" required value="${event.location}">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="price" class="form-label fw-bold">Price (RM)</label>
                            <input type="number" step="0.01" id="price" name="price" class="form-control" required value="${event.price}">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="totalSeats" class="form-label fw-bold">Total Seats</label>
                            <input type="number" id="totalSeats" name="totalSeats" class="form-control" required value="${event.totalSeats}">
                        </div>
                    </div>

                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-primary btn-lg rounded-pill" style="background-color: #2c1a4d; border: none;">Save Event</button>
                        <a href="${pageContext.request.contextPath}/OrganiserDashboardServlet" class="btn btn-outline-secondary rounded-pill">Cancel</a>
                    </div>
                </form>
                <%-- ------------------ --%>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>