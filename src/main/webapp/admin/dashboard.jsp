<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--@elvariable id="eventList" type="java.util.List<com.univent.model.Event>"--%>
<html>
<head>
    <title>Admin Dashboard - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .dashboard-header { background-color: #2c1a4d; color: white; padding: 20px 0; margin-bottom: 30px; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">Univent Admin</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="dashboard-header text-center">
    <h1>Event Management</h1>
    <p>Add, Modify, or Remove Campus Events</p>
</div>

<div class="container">
    <div class="d-flex justify-content-between mb-3">
        <h3>Current Events</h3>
        <div>
            <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="btn btn-info text-white me-2">Manage Users</a>
            <a href="${pageContext.request.contextPath}/admin/add_event.jsp" class="btn btn-success">+ Add New Event</a>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Date</th>
                    <th>Location</th>
                    <th>Price</th>
                    <th>Seats Left</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="event" items="${eventList}">
                    <tr>
                        <td>${event.id}</td>
                        <td><strong>${event.title}</strong></td>
                        <td>${event.eventDate}</td>
                        <td>${event.location}</td>
                        <td>RM ${event.price}</td>
                        <td>
                            <span class="badge ${event.availableSeats > 0 ? 'bg-success' : 'bg-danger'}">
                                    ${event.availableSeats}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/add_event.jsp?id=${event.id}" class="btn btn-primary btn-sm">Edit</a>

                            <a href="${pageContext.request.contextPath}/DeleteEventServlet?id=${event.id}"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Are you sure you want to delete this event?');">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>