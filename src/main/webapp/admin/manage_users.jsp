<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Manage Users - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .dashboard-header { background-color: #2c1a4d; color: white; padding: 20px 0; margin-bottom: 30px; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">Univent Admin</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
</nav>

<div class="dashboard-header text-center">
    <h1>User Management</h1>
    <p>View and Manage Registered Participants</p>
</div>

<div class="container">
    <div class="d-flex justify-content-between mb-3">
        <h3>Registered Users</h3>
        <a href="${pageContext.request.contextPath}/OrganiserDashboardServlet" class="btn btn-secondary">Back to Dashboard</a>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${userList}">
                    <tr>
                        <td>${user.id}</td>
                        <td><strong>${user.username}</strong></td>
                        <td>${user.email}</td>
                        <td>
                                <%-- Form to update role --%>
                            <form action="${pageContext.request.contextPath}/UpdateUserRoleServlet" method="post" class="d-flex align-items-center m-0">
                                <input type="hidden" name="userId" value="${user.id}">
                                <select name="role" class="form-select form-select-sm me-2" onchange="this.form.submit()">
                                    <option value="STUDENT" ${user.role == 'STUDENT' ? 'selected' : ''}>Student</option>
                                    <option value="ORGANIZER" ${user.role == 'ORGANIZER' ? 'selected' : ''}>Organizer</option>
                                    <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                </select>
                            </form>
                        </td>
                        <td>
                            <c:if test="${user.username != 'admin'}">
                                <a href="${pageContext.request.contextPath}/DeleteUserServlet?id=${user.id}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Delete this user?');">Delete</a>
                            </c:if>
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