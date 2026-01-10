<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
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
            margin-bottom: 2rem;
        }

        /* Headers */
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

        /* Standard Header (Purple) */
        .custom-table thead {
            background-color: #2c1a4d;
            color: white;
            border-bottom: 4px solid #ffc107;
        }

        /* Pending Header (Light Gray) - Clean Look */
        .pending-table thead {
            background-color: #f8f9fa !important;
            color: #333 !important;
            border-bottom: 3px solid #ffc107 !important;
        }

        /* Zebra & Hover */
        .custom-table tbody tr:nth-of-type(even) { background-color: rgba(44, 26, 77, 0.04); }
        .custom-table tbody tr:nth-of-type(odd) { background-color: #ffffff; }

        /* Fix Jitter on Hover */
        .custom-table tbody tr {
            transition: all 0.2s ease;
            border-left: 4px solid transparent;
        }
        .custom-table tbody tr:hover {
            background-color: rgba(255, 193, 7, 0.1);
            border-left: 4px solid #ffc107;
        }

        .col-id { color: #888; font-weight: bold; font-size: 0.9rem; }
        .col-username { font-weight: 600; color: #2c1a4d; font-size: 1.05rem; }
        .col-email { color: #555; font-style: italic; }

        /* --- AVATAR STYLES --- */
        .user-avatar-btn {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.5);
            border-radius: 50%;
            padding: 0;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .user-avatar-btn:hover, .user-avatar-btn.show {
            background: rgba(255,255,255,0.2);
            border-color: #fff;
        }
        .user-avatar-svg {
            fill: white;
            width: 24px;
            height: 24px;
        }
        .dropdown-toggle::after { display: none !important; }

        /* --- MOBILE VIEWPORT OPTIMIZATION --- */
        @media (max-width: 768px) {
            /* Header Stack */
            .dashboard-header { flex-direction: column !important; align-items: flex-start !important; gap: 15px; }
            .dashboard-header > div { width: 100% !important; }
            .dashboard-header .button-group { display: flex; width: 100%; }
            .dashboard-header .btn { flex: 1; width: 100%; display: flex; justify-content: center; align-items: center; }
            .dashboard-header .text-container { margin-bottom: 0 !important; }

            /* Table Simplification */
            /* Hide ID and Email columns to save space */
            .col-id, .col-email { display: none; }
            .custom-table th:nth-child(1), .custom-table th:nth-child(3) { display: none; }

            /* Adjust remaining columns */
            .col-username { font-size: 1rem; }

            /* Button Group Stacking for Mobile (Like Dashboard) */
            .btn-group { display: flex; flex-direction: column; gap: 5px; width: 100%; }
            .btn-group .btn { border-radius: 5px !important; width: 100%; font-size: 0.8rem; padding: 5px; }

            /* Adjust dropdown width in All Users table */
            .form-select {
                width: auto !important;
                min-width: 110px;
                font-size: 0.8rem;
                white-space: normal; /* Allow wrapping */
            }
        }
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
                <button class="user-avatar-btn dropdown-toggle" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    <svg class="user-avatar-svg" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </button>
                <ul class="dropdown-menu dropdown-menu-end mt-2" aria-labelledby="userMenu">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/EventListServlet">Home Page</a></li>
                    <li><hr class="dropdown-divider"></li>
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
        <div class="d-flex justify-content-between align-items-center mb-4 dashboard-header">
            <div class="text-container">
                <h3 class="fw-bold text-dark mb-0">Registered Users</h3>
            </div>
            <div class="button-group">
                <a href="${pageContext.request.contextPath}/OrganiserDashboardServlet"
                   class="btn btn-outline-secondary rounded-pill">
                    Back to Dashboard
                </a>
            </div>
        </div>

        <%-- 1. PENDING ORGANIZER REQUESTS --%>
        <c:if test="${not empty pendingList}">

            <%-- Title Section --%>
            <div class="mb-3 mt-4">
                <h3 class="fw-bold mb-0" style="color: #856404; font-size: 1.3rem;">Pending Organizer Applications</h3>
                <p class="small mb-0" style="color: #856404; opacity: 0.8;">Users requesting upgrade to Organizer status</p>
            </div>

            <div class="table-responsive table-container mb-5">
                <table class="table custom-table pending-table mb-0">
                    <thead>
                    <tr>
                        <th style="width: 10%;">ID</th>
                        <th style="width: 25%;">Username</th>
                        <th style="width: 30%;">Email</th>
                        <th style="width: 15%;">Current Role</th>
                        <th style="width: 20%;" class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="pUser" items="${pendingList}">
                        <tr>
                            <td class="col-id">#${pUser.id}</td>
                            <td class="col-username">${pUser.username}</td>
                            <td class="col-email">${pUser.email}</td>
                            <td><span class="badge bg-secondary">STUDENT</span></td>
                            <td class="text-end">
                                <form action="${pageContext.request.contextPath}/ProcessOrganizerRequestServlet" method="post" class="d-inline">
                                    <input type="hidden" name="userId" value="${pUser.id}">

                                        <%-- UPDATED BUTTON GROUP STYLE --%>
                                    <div class="btn-group shadow-sm" role="group">
                                        <button type="submit" name="action" value="approve"
                                                class="btn btn-outline-success btn-sm fw-bold">
                                            Approve
                                        </button>
                                        <button type="submit" name="action" value="reject"
                                                class="btn btn-outline-danger btn-sm bg-white"
                                                onclick="return confirm('Reject request?');">
                                            Reject
                                        </button>
                                    </div>

                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <%-- 2. ALL USERS TABLE --%>
        <div class="mb-3 mt-5">
            <h3 class="fw-bold text-secondary mb-0" style="font-size: 1.3rem;">All Users</h3>
            <p class="text-muted small mb-0">Full database of registered accounts</p>
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