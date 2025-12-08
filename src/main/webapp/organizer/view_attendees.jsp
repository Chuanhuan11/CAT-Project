<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Attendees - ${eventTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h3>Attendees for: <c:out value="${eventTitle}"/></h3>
    <a href="${pageContext.request.contextPath}/OrganiserDashboardServlet" class="btn btn-secondary mb-3">Back to Dashboard</a>

    <ul class="list-group">
        <c:forEach var="user" items="${attendees}">
            <li class="list-group-item d-flex justify-content-between align-items-center">
                <div>
                    <strong>${user.username}</strong><br>
                    <small class="text-muted">${user.email}</small>
                </div>x
            </li>
        </c:forEach>
        <c:if test="${empty attendees}">
            <li class="list-group-item">No attendees yet.</li>
        </c:if>
    </ul>
</div>
</body>
</html>