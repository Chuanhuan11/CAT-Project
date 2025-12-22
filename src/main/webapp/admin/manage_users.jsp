<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Manage Users - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        /* --- THEME SETUP --- */
        body {
            background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
        }
        .navbar { box-shadow: 0 4px 10px rgba(0,0,0,0.3); }

        .hero-section {
            background-color: rgba(50, 13, 70, 0.9); /* Brand Purple */
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

        .content-box {
            background-color: rgba(255, 255, 255, 0.98);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }

        /* --- TABLE STYLING --- */
        .table-container {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #ddd;
        }

        /* FEATURE ROW (HEADER) */
        .custom-table thead {
            background-color: #2c1a4d;
            color: white;
            border-bottom: 4px solid #ffc107; /* GOLD ACCENT */
        }

        .custom-table th {
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85rem;
            padding: 18px 15px;
            border: none;
            letter-spacing: 0.5px;
        }

        .custom-table td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #eee;
            color: #444;
        }

        /* ZEBRA STRIPING & HOVER */
        .custom-table tbody tr:nth-of-type(even) { background-color: rgba(44, 26, 77, 0.04); }
        .custom-table tbody tr:nth-of-type(odd) { background-color: #ffffff; }

        .custom-table tbody tr {
            transition: all 0.2s ease;
            border-left: 4px solid transparent;
        }

        .custom-table tbody tr:hover {
            background-color: rgba(255, 193, 7, 0.1);
            border-left: 4px solid #ffc107;
        }

        /* Typography */
        .col-id { color: #888; font-weight: bold; font-size: 0.9rem; }
        .col-username { font-weight: 600; color: #2c1a4d; font-size: 1.05rem; }
        .col-email { color: #555; font-style: italic; }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="me-2 rounded-circle">
            Univent Admin
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

<%-- HERO HEADER --%>
<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">User Management</h2>
        <p class="mb-0">View and Manage Registered Participants</p>
    </div>
</div>

<%-- MAIN CONTENT --%>
<div class="container">
    <div class="content-box">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-dark mb-0">Registered Users</h3>
            <a href="${pageContext.request.contextPath}/OrganiserDashboardServlet" class="btn btn-outline-secondary rounded-pill">Back to Dashboard</a>
        </div>

        <div class="table-responsive table-container">
            <table class="table custom-table mb-0">
                <thead>
                <tr>
                    <th style="width: 10%;">ID</th>
                    <th style="width: 25%;">Username</th>
                    <th style="width: 30%;">Email</th>
                    <th style="width: 20%;">Role</th>
                    <th style="width: 15%;" class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="user" items="${userList}">
                    <tr>
                        <td class="col-id">#${user.id}</td>
                        <td class="col-username">${user.username}</td>
                        <td class="col-email">${user.email}</td>
                        <td>
                                <%-- Role Dropdown --%>
                            <form action="${pageContext.request.contextPath}/UpdateUserRoleServlet" method="post" class="d-flex align-items-center m-0">
                                <input type="hidden" name="userId" value="${user.id}">
                                <select name="role" class="form-select form-select-sm border-0 bg-light fw-bold"
                                        style="cursor: pointer;" onchange="this.form.submit()">
                                    <option value="STUDENT" ${user.role == 'STUDENT' ? 'selected' : ''}>Student</option>
                                    <option value="ORGANIZER" ${user.role == 'ORGANIZER' ? 'selected' : ''}>Organizer</option>
                                    <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                </select>
                            </form>
                        </td>
                        <td class="text-end">
                            <c:if test="${user.username != 'admin'}">
                                <a href="${pageContext.request.contextPath}/DeleteUserServlet?id=${user.id}"
                                   class="btn btn-outline-danger btn-sm rounded-pill px-3"
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

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>