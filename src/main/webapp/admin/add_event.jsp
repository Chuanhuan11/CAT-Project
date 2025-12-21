<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Event Form</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4>${event != null ? 'Edit Event' : 'Create New Event'}</h4>
                </div>
                <div class="card-body">
                    <%-- CRITICAL CHANGE: Added enctype="multipart/form-data" for file uploads --%>
                    <form action="${pageContext.request.contextPath}/AddEventServlet" method="post" enctype="multipart/form-data">
                        <%-- Keep ID for editing --%>
                        <input type="hidden" name="id" value="${event.id}">
                        <%-- Keep current image name so we don't lose it if the user doesn't upload a new one --%>
                        <input type="hidden" name="currentImage" value="${event.imageUrl}">

                        <div class="mb-3">
                            <label for="title" class="form-label">Event Title</label>
                            <input type="text" id="title" name="title" class="form-control" required
                                   value="${event.title}" placeholder="e.g. Java Workshop">
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="3">${event.description}</textarea>
                        </div>

                        <%-- NEW SECTION: Image Upload --%>
                        <div class="mb-3">
                            <label for="imageFile" class="form-label">Event Poster</label>
                            <input class="form-control" type="file" id="imageFile" name="imageFile" accept="image/*">
                            <div class="form-text">Supported formats: JPG, PNG. Leave empty to keep current image.</div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="eventDate" class="form-label">Date</label>
                                <input type="date" id="eventDate" name="eventDate" class="form-control" required
                                       value="${event.eventDate}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="location" class="form-label">Location</label>
                                <input type="text" id="location" name="location" class="form-control" required
                                       value="${event.location}">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label">Price (RM)</label>
                                <input type="number" step="0.01" id="price" name="price" class="form-control" required
                                       value="${event.price}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="totalSeats" class="form-label">Total Seats</label>
                                <input type="number" id="totalSeats" name="totalSeats" class="form-control" required
                                       value="${event.totalSeats}">
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">Save Event</button>
                            <a href="${pageContext.request.contextPath}/OrganiserDashboardServlet" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>