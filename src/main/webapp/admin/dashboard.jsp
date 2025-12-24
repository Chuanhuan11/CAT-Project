<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. GET TODAY'S DATE FOR COMPARISON --%>
<% request.setAttribute("todayDate", new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())); %>

<html>
<head>
    <title>Dashboard - Univent</title>
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

        /* Active Table Header */
        .active-table thead {
            background-color: #2c1a4d;
            color: white;
            border-bottom: 4px solid #ffc107;
        }

        /* Past Table Header (Grey) */
        .history-table thead {
            background-color: #6c757d;
            color: white;
            border-bottom: 4px solid #dee2e6;
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
            padding: 18px 15px;
            vertical-align: middle;
            border-bottom: 1px solid #eee;
            color: #444;
        }

        /* Zebra Striping */
        .custom-table tbody tr:nth-of-type(even) { background-color: rgba(0,0,0, 0.02); }
        .custom-table tbody tr:nth-of-type(odd) { background-color: #ffffff; }

        /* Hover Effect (Active only) */
        .active-table tbody tr:hover { background-color: rgba(255, 193, 7, 0.1); }
        .active-table tbody tr:hover td:first-child { border-left: 4px solid #ffc107; }

        /* Past Row Styling */
        .history-table td { color: #adb5bd; }
        .history-table strong { color: #6c757d; }
        .history-table .btn { filter: grayscale(100%); opacity: 0.7; }
        .history-table .btn:hover { filter: grayscale(0%); opacity: 1; }

        .custom-table tbody tr td:first-child {
            border-left: 4px solid transparent;
            transition: border-left 0.2s ease;
        }

        .col-id { color: #888; font-weight: bold; font-size: 0.9rem; }
        .col-title { font-size: 1.05rem; color: #000; }
        .col-price { font-family: 'Segoe UI', sans-serif; font-size: 1.1rem; }
        .col-date { font-weight: 500; color: #555; }
        .col-venue { color: #666; font-style: italic; }

        .modal-header { background-color: #2c1a4d; color: white; }
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
                <button class="btn btn-outline-light btn-sm dropdown-toggle fw-bold" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    Hello, ${sessionScope.username}
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
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
        <%-- SERVER ERROR FALLBACK --%>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <strong>System Notice:</strong> ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-0">Active Events</h3>
                <p class="text-muted small mb-0">Upcoming events visible to students</p>
            </div>
            <div>
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/ManageUsersServlet" class="btn btn-outline-dark rounded-pill me-2">
                        Users
                    </a>
                </c:if>
                <button class="btn btn-success rounded-pill px-4 fw-bold" onclick="openAddModal()">
                    + Add New Event
                </button>
            </div>
        </div>

        <div class="table-responsive table-container">
            <table class="table custom-table active-table mb-0">
                <thead>
                <tr>
                    <th style="width: 5%;">ID</th>
                    <th style="width: 25%;">Event Title</th>
                    <th style="width: 15%;">Date</th>
                    <th style="width: 15%;">Venue</th>
                    <th style="width: 10%;">Price</th>
                    <th style="width: 10%;" class="text-center">Seats</th>
                    <th style="width: 20%;" class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:set var="hasActive" value="false" />
                <c:forEach var="event" items="${eventList}">
                    <%-- FILTER: Only Future Events --%>
                    <c:if test="${event.eventDate >= todayDate}">
                        <c:set var="hasActive" value="true" />
                        <tr>
                            <td class="col-id">
                                #${event.id}
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

                            <td><strong class="col-title">${event.title}</strong></td>
                            <td class="col-date">${event.eventDate}</td>
                            <td class="col-venue">${event.location}</td>
                            <td class="col-price text-primary fw-bold">RM <fmt:formatNumber value="${event.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                            <td class="text-center">
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

        <h4 class="fw-bold text-secondary mb-3 mt-5">Event History</h4>
        <div class="table-responsive table-container">
            <table class="table custom-table history-table mb-0">
                <thead>
                <tr>
                    <th style="width: 5%;">ID</th>
                    <th style="width: 25%;">Event Title</th>
                    <th style="width: 15%;">Date</th>
                    <th style="width: 15%;">Venue</th>
                    <th style="width: 10%;">Price</th>
                    <th style="width: 10%;" class="text-center">Seats</th>
                    <th style="width: 20%;" class="text-end">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:set var="hasHistory" value="false" />
                <c:forEach var="event" items="${eventList}">
                    <%-- FILTER: Only Past Events --%>
                    <c:if test="${event.eventDate < todayDate}">
                        <c:set var="hasHistory" value="true" />
                        <tr>
                            <td class="col-id">#${event.id}</td>
                            <td>
                                <strong>${event.title}</strong>
                                <span class="badge bg-secondary ms-2" style="font-size: 0.65rem;">ENDED</span>
                            </td>
                            <td class="col-date">${event.eventDate}</td>
                            <td class="col-venue">${event.location}</td>
                            <td>RM <fmt:formatNumber value="${event.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                            <td class="text-center">
                                <span class="badge bg-secondary rounded-pill px-3">
                                    ${event.totalSeats - event.availableSeats} / ${event.totalSeats} Sold
                                </span>
                            </td>
                            <td class="text-end">
                                <div class="btn-group" role="group">
                                        <%-- Hidden inputs for Edit Modal (still useful for history correction) --%>
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

                                    <button type="button" class="btn btn-outline-secondary btn-sm rounded-start" onclick="openEditModal(this)">Edit</button>
                                    <a href="${pageContext.request.contextPath}/EventAttendeesServlet?eventId=${event.id}&eventTitle=${event.title}" class="btn btn-outline-secondary btn-sm">Attendees</a>
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

<%-- MODAL (Reused standard modal) --%>
<div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="modalTitle">Create New Event</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="filter: invert(1);"></button>
            </div>

            <form action="${pageContext.request.contextPath}/AddEventServlet" method="post" enctype="multipart/form-data"
                  class="needs-validation" novalidate id="eventForm">

                <div class="modal-body p-4">
                    <input type="hidden" name="id" id="eventId">
                    <input type="hidden" name="currentImage" id="currentImage">

                    <div class="mb-3">
                        <label for="title" class="form-label fw-bold">Event Title</label>
                        <input type="text" id="title" name="title" class="form-control" required placeholder="e.g. Annual Tech Talk">
                        <div class="invalid-feedback">Please provide an event title.</div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label fw-bold">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="4" placeholder="Brief details..."></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="eventDate" class="form-label fw-bold">Date</label>
                            <input type="date" id="eventDate" name="eventDate" class="form-control" required>
                            <div class="invalid-feedback">Please select a valid date.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="location" class="form-label fw-bold">Location</label>
                            <input type="text" id="location" name="location" class="form-control" required placeholder="e.g. Main Auditorium">
                            <div class="invalid-feedback">Please specify the location.</div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="price" class="form-label fw-bold">Price (RM)</label>
                            <input type="number" step="0.01" min="0" id="price" name="price" class="form-control" required placeholder="0.00">
                            <div class="invalid-feedback">Price cannot be negative.</div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="totalSeats" class="form-label fw-bold">Total Seats</label>
                            <input type="number" min="1" id="totalSeats" name="totalSeats" class="form-control" required placeholder="e.g. 100">
                            <div class="invalid-feedback" id="seatFeedback">Must be at least 1.</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="imageFile" class="form-label fw-bold">Event Poster</label>
                        <input class="form-control" type="file" id="imageFile" name="imageFile" accept="image/*">
                        <div class="form-text">
                            Current Image: <span id="currentImageDisplay" class="text-primary fw-bold">None</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-4" style="background-color: #2c1a4d; border:none;">Save Event</button>
                </div>
            </form>
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

    eventForm.addEventListener('submit', function (event) {
        if (!eventForm.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        eventForm.classList.add('was-validated');
    }, false);

    function resetFormState() {
        eventForm.classList.remove('was-validated');
        totalSeatsInput.setCustomValidity("");
        seatFeedback.innerText = "Must be at least 1.";
    }

    function openAddModal() {
        document.getElementById('modalTitle').innerText = "Create New Event";
        document.getElementById('eventId').value = "";
        document.getElementById('currentImage').value = "";
        document.getElementById('currentImageDisplay').innerText = "None";
        document.getElementById('title').value = "";
        document.getElementById('description').value = "";
        document.getElementById('eventDate').value = "";
        document.getElementById('location').value = "";
        document.getElementById('price').value = "";
        document.getElementById('imageFile').value = "";

        resetFormState();
        totalSeatsInput.value = "";
        totalSeatsInput.min = 1;
        totalSeatsInput.oninput = null;

        let today = new Date().toISOString().split("T")[0];
        dateInput.value = today;

        eventModal.show();
    }

    function openEditModal(btn) {
        let row = btn.closest('tr');
        let id = row.querySelector('.data-id').value;
        let title = row.querySelector('.data-title').value;
        let date = row.querySelector('.data-date').value;
        let loc = row.querySelector('.data-loc').value;
        let price = row.querySelector('.data-price').value;
        let seats = row.querySelector('.data-seats').value;
        let img = row.querySelector('.data-img').value;
        let desc = row.querySelector('.data-desc').textContent;
        let booked = row.querySelector('.data-booked').value;

        document.getElementById('modalTitle').innerText = "Edit Event";
        document.getElementById('eventId').value = id;
        document.getElementById('currentImage').value = img;
        document.getElementById('currentImageDisplay').innerText = img ? img : "None";
        document.getElementById('title').value = title;
        document.getElementById('description').value = desc;
        document.getElementById('eventDate').value = date;
        document.getElementById('location').value = loc;
        document.getElementById('price').value = parseFloat(price).toFixed(2);
        document.getElementById('imageFile').value = "";

        resetFormState();
        totalSeatsInput.value = seats;
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
</script>
</body>
</html>