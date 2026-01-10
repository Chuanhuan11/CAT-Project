<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- GET TODAY'S DATE --%>
<% request.setAttribute("todayDate", new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())); %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Dashboard - Univent</title>
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

        .hero-section {
            background-color: rgba(50, 13, 70, 0.9);
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

        .custom-table th { font-weight: 700; text-transform: uppercase; font-size: 0.85rem; padding: 18px 15px; border: none; letter-spacing: 0.5px; }
        .custom-table td { padding: 18px 15px; vertical-align: middle; border-bottom: 1px solid #eee; color: #444; }

        /* Common Zebra Striping */
        .custom-table tbody tr:nth-of-type(even) { background-color: rgba(0,0,0, 0.02); }
        .custom-table tbody tr:nth-of-type(odd) { background-color: #ffffff; }

        /* 1. ACTIVE TABLE (Purple/Gold) */
        .active-table thead { background-color: #2c1a4d; color: white; border-bottom: 4px solid #ffc107; }
        .active-table tbody tr:hover { background-color: rgba(255, 193, 7, 0.1); }
        .active-table tbody tr:hover td:first-child { border-left: 4px solid #ffc107; }

        /* 2. PENDING TABLE (Soft Yellow/Orange) */
        .pending-table thead {
            background-color: #ffc107; /* Gold Header */
            color: #2c1a4d; /* Purple Text for contrast */
            border-bottom: 4px solid #e0a800;
        }
        .pending-table tbody tr:hover { background-color: #fff3cd; } /* Soft yellow hover */
        .pending-table tbody tr:hover td:first-child { border-left: 4px solid #ffc107; }

        /* 3. REJECTED TABLE (Soft Red) */
        .rejected-table thead {
            background-color: #dc3545; /* Red Header */
            color: white;
            border-bottom: 4px solid #a71d2a;
        }
        .rejected-table tbody tr:hover { background-color: #f8d7da; } /* Soft red hover */
        .rejected-table tbody tr:hover td:first-child { border-left: 4px solid #dc3545; }

        /* 4. HISTORY TABLE (Grey) */
        .history-table thead { background-color: #6c757d; color: white; border-bottom: 4px solid #dee2e6; }

        .custom-table tbody tr td:first-child { border-left: 4px solid transparent; transition: border-left 0.2s ease; }

        .col-id { color: #888; font-weight: bold; font-size: 0.9rem; }
        .col-title { font-size: 1.05rem; color: #000; }
        .col-price { font-family: 'Segoe UI', sans-serif; font-size: 1.1rem; }
        .col-date { font-weight: 500; color: #555; }
        .col-venue { color: #666; font-style: italic; }

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
        .dropdown-toggle::after {
            display: none !important;
        }

        /* MOBILE RESPONSIVENESS */
        @media (max-width: 768px) {
            .dashboard-header { flex-direction: column !important; align-items: flex-start !important; gap: 15px; }
            .dashboard-header > div { width: 100% !important; }
            .dashboard-header .button-group { display: flex; width: 100%; gap: 10px; }
            .dashboard-header .btn { flex: 1; width: 100%; display: flex; justify-content: center; align-items: center; }
            .dashboard-header .text-container { margin-bottom: 0 !important; }

            /* Removed the broken generic th:nth-child rules */

            .btn-group { display: flex; flex-direction: column; gap: 5px; }
            .btn-group .btn { border-radius: 5px !important; width: 100%; font-size: 0.8rem; padding: 5px; }

            .col-title { font-size: 0.9rem; white-space: normal; }
            /* Mobile date display under title */
            .col-title::after { content: "\A" attr(data-mobile-date); font-size: 0.75rem; color: #666; white-space: pre; font-weight: normal; }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="me-2 rounded-circle">
            Univent ${sessionScope.role == 'ADMIN' ? 'Admin' : 'Organizer'}
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

<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">Event Management</h2>
        <p class="mb-0">Add, Modify, or Remove Campus Events</p>
    </div>
</div>

<div class="container">
    <div class="content-box">
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <strong>System Notice:</strong> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <%-- ========================================= --%>
        <%-- 1. ACTIVE EVENTS (Top Priority) --%>
        <%-- ========================================= --%>
        <div class="d-flex justify-content-between align-items-center mb-4 dashboard-header">
            <div class="mb-3 mb-md-0">
                <h3 class="fw-bold text-dark mb-0">Active Events</h3>
                <p class="text-muted small mb-0">Upcoming events visible to students</p>
            </div>
            <div class="d-flex gap-2 button-group">
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="btn btn-outline-dark rounded-pill">Users</a>
                </c:if>
                <button class="btn btn-success rounded-pill px-4 fw-bold" onclick="openAddModal()">+ Add New Event</button>
            </div>
        </div>

        <div class="table-responsive table-container">
            <table class="table custom-table active-table mb-0">
                <thead>
                <tr>
                    <th class="d-none d-md-table-cell" style="width: 5%;">ID</th>
                    <th style="width: 25%;">Event Title</th>
                    <th class="d-none d-md-table-cell" style="width: 15%;">Date</th>
                    <th class="d-none d-md-table-cell" style="width: 15%;">Venue</th>
                    <th class="d-none d-md-table-cell" style="width: 10%;">Price</th>
                    <th class="d-none d-md-table-cell" style="width: 10%;" class="text-center">Seats</th>
                    <th style="width: 20%;" class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:set var="hasActive" value="false" />
                <c:forEach var="event" items="${eventList}">
                    <c:if test="${event.eventDate >= todayDate && event.status == 'APPROVED'}">
                        <c:set var="hasActive" value="true" />
                        <tr>
                            <td class="col-id d-none d-md-table-cell">#${event.id}
                                <input type="hidden" class="data-id" value="${event.id}">
                                <input type="hidden" class="data-title" value="${event.title}">
                                <input type="hidden" class="data-date" value="${event.eventDate}">
                                <input type="hidden" class="data-loc" value="${event.location}">
                                <input type="hidden" class="data-price" value="${event.price}">
                                <input type="hidden" class="data-seats" value="${event.totalSeats}">
                                <input type="hidden" class="data-img" value="${event.imageUrl}">
                                <div class="d-none data-desc"><c:out value="${event.description}"/></div>
                                <c:set var="bookedCount" value="${event.totalSeats - event.availableSeats}" />
                                <input type="hidden" class="data-booked" value="${bookedCount}">
                            </td>
                            <td><strong class="col-title" data-mobile-date="📅 ${event.eventDate}">${event.title}</strong></td>
                            <td class="col-date d-none d-md-table-cell">${event.eventDate}</td>
                            <td class="col-venue d-none d-md-table-cell">${event.location}</td>
                            <td class="col-price text-primary fw-bold d-none d-md-table-cell">RM <fmt:formatNumber value="${event.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                            <td class="text-center d-none d-md-table-cell">
                                <span class="badge rounded-pill ${event.availableSeats > 0 ? 'bg-success' : 'bg-danger'} px-3">
                                    ${event.availableSeats} Left
                                </span>
                            </td>
                            <td class="text-end">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-outline-primary btn-sm rounded-start" onclick="openEditModal(this)">Edit</button>
                                    <a href="${pageContext.request.contextPath}/EventAttendeesServlet?eventId=${event.id}&eventTitle=${event.title}" class="btn btn-outline-info btn-sm">Attendees</a>
                                    <a href="${pageContext.request.contextPath}/DeleteEventServlet?id=${event.id}" class="btn btn-outline-danger btn-sm rounded-end" onclick="return confirm('Delete this event?');">Delete</a>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                <c:if test="${!hasActive}">
                    <tr><td colspan="7" class="text-center py-5 text-muted"><h5>No active events.</h5></td></tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <%-- ========================================= --%>
        <%-- 2. PENDING PROPOSALS --%>
        <%-- ========================================= --%>
        <div class="mb-3 mt-5">
            <h3 class="fw-bold mb-0" style="color: #856404; font-size: 1.3rem;">Pending Proposals</h3>
            <p class="small mb-0" style="color: #856404; opacity: 0.8;">Events waiting for admin approval</p>
        </div>

        <div class="table-responsive table-container mb-5">
            <table class="table custom-table pending-table mb-0">
                <thead>
                <tr>
                    <th class="d-none d-md-table-cell" style="width: 5%;">ID</th>
                    <th style="width: 35%;">Event Title</th>
                    <th class="d-none d-md-table-cell" style="width: 25%;">Organizer</th>
                    <th class="d-none d-md-table-cell" style="width: 15%;">Status</th>
                    <th style="width: 20%;" class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:set var="hasPending" value="false" />
                <c:forEach var="event" items="${eventList}">
                    <c:if test="${event.status == 'PENDING'}">
                        <c:set var="hasPending" value="true" />
                        <tr>
                            <td class="text-muted d-none d-md-table-cell">#${event.id}</td>
                            <td>
                                <strong>${event.title}</strong><br>
                                <small class="text-muted d-md-none">${event.eventDate}</small>
                            </td>
                            <td class="d-none d-md-table-cell">
                                <c:choose>
                                    <c:when test="${event.organizerId == sessionScope.userId}"> <span class="badge bg-light text-dark border">You</span> </c:when>
                                    <c:otherwise> <span class="text-muted small">ID: ${event.organizerId}</span> </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="d-none d-md-table-cell"><span class="badge bg-warning text-dark">Pending Review</span></td>
                            <td class="text-end">
                                <input type="hidden" class="data-id" value="${event.id}">
                                <input type="hidden" class="data-title" value="${event.title}">
                                <input type="hidden" class="data-date" value="${event.eventDate}">
                                <input type="hidden" class="data-loc" value="${event.location}">
                                <input type="hidden" class="data-price" value="${event.price}">
                                <input type="hidden" class="data-seats" value="${event.totalSeats}">
                                <input type="hidden" class="data-img" value="${event.imageUrl}">
                                <div class="d-none data-desc"><c:out value="${event.description}"/></div>
                                <c:set var="bookedCount" value="${event.totalSeats - event.availableSeats}" />
                                <input type="hidden" class="data-booked" value="${bookedCount}">

                                <c:choose>
                                    <c:when test="${sessionScope.role == 'ADMIN'}">
                                        <button class="btn btn-primary btn-sm rounded-pill px-3" onclick="openReviewModal(this)">Review</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-sm btn-outline-secondary rounded-pill px-3" onclick="openEditModal(this)">Edit</button>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                <c:if test="${!hasPending}">
                    <tr><td colspan="5" class="text-center py-3 text-muted">No pending proposals.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <%-- ========================================= --%>
        <%-- 3. REJECTED PROPOSALS --%>
        <%-- ========================================= --%>
        <c:if test="${sessionScope.role == 'ORGANIZER'}">
            <div class="mb-3 mt-5">
                <h3 class="fw-bold mb-0" style="color: #721c24; font-size: 1.3rem;">Rejected Proposals</h3>
                <p class="small mb-0" style="color: #721c24; opacity: 0.8;">Proposals that require revision</p>
            </div>

            <div class="table-responsive table-container">
                <table class="table custom-table rejected-table mb-0">
                    <thead>
                    <tr>
                        <th style="width: 35%;">Event Title</th>
                        <th class="d-none d-md-table-cell" style="width: 20%;">Date</th>
                        <th class="d-none d-md-table-cell" style="width: 20%;">Status</th>
                        <th style="width: 25%;" class="text-end">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="event" items="${eventList}">
                        <c:if test="${event.status == 'REJECTED'}">
                            <tr>
                                <td>
                                    <strong>${event.title}</strong>
                                    <div class="d-md-none small text-danger">Rejected</div>
                                </td>
                                <td class="d-none d-md-table-cell">${event.eventDate}</td>
                                <td class="d-none d-md-table-cell"><span class="badge bg-danger">Rejected</span></td>
                                <td class="text-end">
                                    <input type="hidden" class="data-id" value="${event.id}">
                                    <input type="hidden" class="data-title" value="${event.title}">
                                    <input type="hidden" class="data-date" value="${event.eventDate}">
                                    <input type="hidden" class="data-loc" value="${event.location}">
                                    <input type="hidden" class="data-price" value="${event.price}">
                                    <input type="hidden" class="data-seats" value="${event.totalSeats}">
                                    <input type="hidden" class="data-img" value="${event.imageUrl}">
                                    <div class="d-none data-desc"><c:out value="${event.description}"/></div>
                                    <input type="hidden" class="data-booked" value="0">

                                    <button class="btn btn-sm btn-outline-primary rounded-pill px-3" onclick="openEditModal(this)">Edit to Resubmit</button>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <%-- ========================================= --%>
        <%-- 4. HISTORY (Bottom) --%>
        <%-- ========================================= --%>
        <div class="mb-3 mt-5">
            <h3 class="fw-bold text-secondary mb-0" style="font-size: 1.3rem;">Event History</h3>
            <p class="text-muted small mb-0">Past events archive</p>
        </div>

        <div class="table-responsive table-container">
            <table class="table custom-table history-table mb-0">
                <thead>
                <tr>
                    <th class="d-none d-md-table-cell" style="width: 5%;">ID</th>
                    <th style="width: 25%;">Event Title</th>
                    <th class="d-none d-md-table-cell" style="width: 15%;">Date</th>
                    <th class="d-none d-md-table-cell" style="width: 15%;">Venue</th>
                    <th class="d-none d-md-table-cell" style="width: 10%;">Price</th>
                    <th class="d-none d-md-table-cell" style="width: 10%;" class="text-center">Seats</th>
                    <th style="width: 20%;" class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:set var="hasHistory" value="false" />
                <c:forEach var="event" items="${eventList}">
                    <c:if test="${event.eventDate < todayDate}">
                        <c:set var="hasHistory" value="true" />
                        <tr>
                            <td class="col-id d-none d-md-table-cell">#${event.id}</td>
                            <td><strong>${event.title}</strong><span class="badge bg-secondary ms-2" style="font-size: 0.65rem;">ENDED</span></td>
                            <td class="col-date d-none d-md-table-cell">${event.eventDate}</td>
                            <td class="col-venue d-none d-md-table-cell">${event.location}</td>
                            <td class="d-none d-md-table-cell">RM <fmt:formatNumber value="${event.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                            <td class="text-center d-none d-md-table-cell"><span class="badge bg-secondary rounded-pill px-3">${event.totalSeats - event.availableSeats} / ${event.totalSeats} Sold</span></td>
                            <td class="text-end">
                                <div class="btn-group" role="group">
                                    <a href="${pageContext.request.contextPath}/EventAttendeesServlet?eventId=${event.id}&eventTitle=${event.title}" class="btn btn-outline-secondary btn-sm rounded-start">Attendees</a>
                                    <a href="${pageContext.request.contextPath}/DeleteEventServlet?id=${event.id}" class="btn btn-outline-danger btn-sm rounded-end" onclick="return confirm('Permanently delete history?');">Delete</a>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                <c:if test="${!hasHistory}">
                    <tr><td colspan="7" class="text-center py-4 text-muted">No past events found.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%-- JS SCRIPT BLOCK (Kept same as before) --%>
<div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="modalTitle">Event Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="filter: invert(1);"></button>
            </div>
            <form action="${pageContext.request.contextPath}/AddEventServlet" method="post" enctype="multipart/form-data" class="needs-validation" novalidate id="eventForm">
                <div class="modal-body p-4">
                    <input type="hidden" name="id" id="eventId">
                    <input type="hidden" name="currentImage" id="currentImage">
                    <div id="reviewNotice" class="alert alert-info d-none mb-3"><strong>Review Mode:</strong> Verify details before approving.</div>
                    <div class="mb-3">
                        <label for="title" class="form-label fw-bold">Event Title</label>
                        <input type="text" id="title" name="title" class="form-control" required placeholder="e.g. Annual Tech Talk">
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label fw-bold">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="4" placeholder="Brief details..."></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="eventDate" class="form-label fw-bold">Date</label>
                            <input type="date" id="eventDate" name="eventDate" class="form-control" required min="${todayDate}">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="location" class="form-label fw-bold">Location</label>
                            <input type="text" id="location" name="location" class="form-control" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="price" class="form-label fw-bold">Price (RM)</label>
                            <input type="number" step="0.01" min="0" id="price" name="price" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="totalSeats" class="form-label fw-bold">Total Seats</label>
                            <input type="number" min="1" id="totalSeats" name="totalSeats" class="form-control" required>
                            <div class="invalid-feedback" id="seatFeedback">Must be at least 1.</div>
                        </div>
                    </div>
                    <div class="mb-3" id="imageUploadDiv">
                        <label for="imageFile" class="form-label fw-bold">Event Poster</label>
                        <input class="form-control" type="file" id="imageFile" name="imageFile" accept="image/*">
                        <div class="form-text">Current Image: <span id="currentImageDisplay" class="text-primary fw-bold">None</span></div>
                    </div>
                </div>
                <div class="modal-footer bg-light" id="defaultFooter">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4" style="background-color: #2c1a4d; border:none;">Save Event</button>
                </div>
            </form>
            <div class="modal-footer bg-light d-none" id="reviewFooter">
                <form action="${pageContext.request.contextPath}/UpdateEventStatusServlet" method="post" class="w-100 d-flex justify-content-end gap-2">
                    <input type="hidden" name="eventId" id="reviewEventId">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Close</button>
                    <button type="submit" name="status" value="REJECTED" class="btn btn-outline-danger rounded-pill px-4" onclick="return confirm('Reject this proposal?')">Reject</button>
                    <button type="submit" name="status" value="APPROVED" class="btn btn-success rounded-pill px-4 fw-bold">Approve Event</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
    var eventModal = new bootstrap.Modal(document.getElementById('eventModal'));
    var eventForm = document.getElementById('eventForm');
    var totalSeatsInput = document.getElementById('totalSeats');
    var seatFeedback = document.getElementById('seatFeedback');
    var dateInput = document.getElementById('eventDate');
    var defaultFooter = document.getElementById('defaultFooter');
    var reviewFooter = document.getElementById('reviewFooter');
    var reviewNotice = document.getElementById('reviewNotice');
    var modalTitle = document.getElementById('modalTitle');
    var imageUploadDiv = document.getElementById('imageUploadDiv');
    var allInputs = eventForm.querySelectorAll('input, textarea, select');

    function resetFormState() {
        eventForm.classList.remove('was-validated');
        eventForm.reset();
        totalSeatsInput.setCustomValidity("");
        seatFeedback.innerText = "Must be at least 1.";
        totalSeatsInput.oninput = null;
        allInputs.forEach(input => input.disabled = false);
        imageUploadDiv.classList.remove('d-none');
        defaultFooter.classList.remove('d-none');
        reviewFooter.classList.add('d-none');
        reviewNotice.classList.add('d-none');
    }

    function populateForm(row) {
        let id = row.querySelector('.data-id').value;
        let title = row.querySelector('.data-title').value;
        let date = row.querySelector('.data-date').value;
        let loc = row.querySelector('.data-loc').value;
        let price = row.querySelector('.data-price').value;
        let seats = row.querySelector('.data-seats').value;
        let img = row.querySelector('.data-img').value;
        let desc = row.querySelector('.data-desc').textContent;
        document.getElementById('eventId').value = id;
        document.getElementById('currentImage').value = img;
        document.getElementById('currentImageDisplay').innerText = img ? img : "None";
        document.getElementById('title').value = title;
        document.getElementById('description').value = desc;
        document.getElementById('eventDate').value = date;
        document.getElementById('location').value = loc;
        document.getElementById('price').value = parseFloat(price).toFixed(2);
        document.getElementById('totalSeats').value = seats;
        return {id, seats};
    }

    function openAddModal() {
        resetFormState();
        modalTitle.innerText = "Create New Event";
        document.getElementById('currentImageDisplay').innerText = "None";
        let today = new Date().toISOString().split("T")[0];
        dateInput.value = today;
        dateInput.min = today;
        eventModal.show();
    }

    function openEditModal(btn) {
        resetFormState();
        modalTitle.innerText = "Edit Event";
        let row = btn.closest('tr');
        let data = populateForm(row);
        let booked = row.querySelector('.data-booked').value;
        let today = new Date().toISOString().split("T")[0];
        dateInput.min = today;
        totalSeatsInput.min = booked;
        totalSeatsInput.oninput = function() {
            if (parseInt(this.value) < parseInt(booked)) {
                let msg = "Cannot be less than booked seats (" + booked + ").";
                this.setCustomValidity(msg);
                seatFeedback.innerText = msg;
            } else {
                this.setCustomValidity("");
                seatFeedback.innerText = "Must be at least 1.";
            }
        };
        eventModal.show();
    }

    function openReviewModal(btn) {
        resetFormState();
        modalTitle.innerText = "Review Event Proposal";
        let row = btn.closest('tr');
        let data = populateForm(row);
        document.getElementById('reviewEventId').value = data.id;
        allInputs.forEach(input => input.disabled = true);
        imageUploadDiv.classList.add('d-none');
        defaultFooter.classList.add('d-none');
        reviewFooter.classList.remove('d-none');
        reviewNotice.classList.remove('d-none');
        eventModal.show();
    }
</script>
</body>
</html>