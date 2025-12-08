<%@ page contentType="text/html;charset=UTF-8" %>
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
                    <h4>${param.id == null ? 'Create New Event' : 'Edit Event'}</h4>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/AddEventServlet" method="post">
                        <input type="hidden" name="id" value="${param.id}">

                        <div class="mb-3">
                            <label for="title" class="form-label">Event Title</label>
                            <input type="text" id="title" name="title" class="form-control" required placeholder="e.g. Java Workshop">
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="3"></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="eventDate" class="form-label">Date</label>
                                <input type="date" id="eventDate" name="eventDate" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="location" class="form-label">Location</label>
                                <input type="text" id="location" name="location" class="form-control" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label">Price (RM)</label>
                                <input type="number" step="0.01" id="price" name="price" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="totalSeats" class="form-label">Total Seats</label>
                                <input type="number" id="totalSeats" name="totalSeats" class="form-control" required>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">Save Event</button>
                            <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>