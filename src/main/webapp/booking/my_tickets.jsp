<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>My Tickets - Univent</title>
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
            background-color: rgba(255, 255, 255, 0.96);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }
        .digital-ticket {
            border: 2px dashed #2c1a4d;
            border-radius: 20px;
            overflow: hidden;
            background: white;
            position: relative;
        }
        .ticket-header {
            background-color: #2c1a4d;
            color: white;
            padding: 20px;
            text-align: center;
        }
        .ticket-body { padding: 30px; text-align: center; }
        .qr-container {
            margin: 20px auto;
            border: 1px solid #eee;
            padding: 15px;
            background: white;
            border-radius: 15px;
            width: fit-content;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .ticket-footer {
            background-color: #f8f9fa;
            padding: 15px;
            text-align: center;
            font-size: 0.8rem;
            color: #666;
            border-top: 1px dashed #ccc;
        }

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
        /* Hide the default dropdown arrow */
        .dropdown-toggle::after {
            display: none !important;
        }

        /* --- MOBILE NAVBAR OVERLAY FIX (Matches home.jsp) --- */
        @media (max-width: 991px) {
            .navbar-collapse {
                background-color: #212529;
                padding: 15px;
                border-radius: 0 0 10px 10px;
                margin-top: 0;
                position: absolute; /* Floating menu */
                top: 120%;          /* Align to bottom of navbar */
                width: 100%;
                left: 0;
                z-index: 1000;
                box-shadow: 0 10px 15px rgba(0,0,0,0.3);
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <%-- ADDED position-relative for absolute positioning of mobile menu --%>
    <div class="container position-relative">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="d-inline-block align-text-top me-2 rounded-circle">
            Univent
        </a>

        <%-- MOVED AVATAR OUTSIDE COLLAPSE (Visible on Mobile, Left of Hamburger) --%>
        <div class="d-flex align-items-center ms-auto order-lg-last">
            <div class="dropdown">
                <button class="user-avatar-btn dropdown-toggle" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    <svg class="user-avatar-svg" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                    <li>
                        <h6 class="dropdown-header text-truncate" style="max-width: 200px;">
                            Hello, ${sessionScope.username}
                        </h6>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ORGANIZER'}">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">Dashboard</a></li>
                        <li><hr class="dropdown-divider"></li>
                    </c:if>
                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                </ul>
            </div>
        </div>

        <%-- HAMBURGER TOGGLER (Now to the right of Avatar) --%>
        <button class="navbar-toggler ms-2" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse me-3" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/EventListServlet">Catalog</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/CartServlet">My Cart</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">My Tickets</h2>
        <p class="mb-0">Track your bookings and view digital passes</p>
    </div>
</div>

<div class="container">
    <div class="content-box">
        <c:if test="${empty ticketList}">
            <div class="text-center py-5">
                <h3 class="text-muted">No tickets found.</h3>
                <p class="text-muted">You haven't booked any events yet.</p>
                <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-primary rounded-pill mt-3">Browse Events</a>
            </div>
        </c:if>

        <c:if test="${not empty ticketList}">
        <div class="accordion" id="ticketsAccordion">

            <c:set var="lastTitle" value="" />
            <c:set var="groupIndex" value="0" />

            <c:forEach var="ticket" items="${ticketList}" varStatus="status">

                <%-- Check if we need a new Header (Event Name) --%>
            <c:if test="${ticket.eventTitle ne lastTitle}">
                <%-- Close previous item body if this is not the first iteration --%>
            <c:if test="${not status.first}">
        </div> <%-- End list-group --%>
    </div> <%-- End accordion-body --%>
</div> <%-- End accordion-collapse --%>
</div> <%-- End accordion-item --%>
</c:if>

    <%-- Start new Accordion Item --%>
<c:set var="groupIndex" value="${groupIndex + 1}" />
<div class="accordion-item mb-3 shadow-sm border-0">
    <h2 class="accordion-header" id="heading${groupIndex}">
        <button class="accordion-button ${status.first ? '' : 'collapsed'} fw-bold" type="button"
                data-bs-toggle="collapse" data-bs-target="#collapse${groupIndex}"
                aria-expanded="${status.first}" aria-controls="collapse${groupIndex}"
                style="color: #2c1a4d; background-color: #f8f9fa;">
                ${ticket.eventTitle} &nbsp; <span class="badge bg-secondary ms-2 text-white" style="font-size: 0.7rem;">${ticket.eventDate}</span>
        </button>
    </h2>
    <div id="collapse${groupIndex}" class="accordion-collapse collapse ${status.first ? 'show' : ''}"
         aria-labelledby="heading${groupIndex}" data-bs-parent="#ticketsAccordion">
        <div class="accordion-body p-0">
            <div class="list-group list-group-flush">
                <c:set var="lastTitle" value="${ticket.eventTitle}" />
                </c:if>

                    <%-- Ticket Sub-Item --%>
                <div class="list-group-item d-flex justify-content-between align-items-center p-3">
                    <div>
                        <span class="badge bg-light text-dark border me-2">#${ticket.bookingId}</span>
                        <span class="text-muted small">Purchased on <fmt:formatDate value="${ticket.bookingDate}" pattern="dd MMM yyyy" /></span>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="badge rounded-pill bg-success me-3">Confirmed</span>
                        <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3"
                                data-bs-toggle="modal" data-bs-target="#ticketModal"
                                onclick="loadTicket('${ticket.bookingId}', '${ticket.eventTitle}', '${ticket.eventDate}', '${ticket.location}', '${sessionScope.username}')">
                            View Ticket
                        </button>
                    </div>
                </div>

                    <%-- Close the very last group --%>
                <c:if test="${status.last}">
            </div>
        </div>
    </div>
</div>
</c:if>
</c:forEach>

</div>
</c:if>
</div>
</div>

<%-- TICKET MODAL --%>
<div class="modal fade" id="ticketModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 bg-transparent">
            <div class="digital-ticket shadow-lg">
                <div class="ticket-header">
                    <h4 class="mb-0 fw-bold">UNIVENT PASS</h4>
                    <small>Official Digital Ticket</small>
                </div>
                <div class="ticket-body">
                    <h3 id="modalEventTitle" class="fw-bold mb-1" style="color: #2c1a4d;">Event Name</h3>
                    <p class="text-muted mb-3">
                        <span id="modalEventDate">Date</span> | <span id="modalEventLoc">Location</span>
                    </p>
                    <div class="qr-container">
                        <img id="modalQrCode" src="" alt="Scanning..." width="180" height="180">
                    </div>
                    <p class="small text-muted mt-2">Scan for details</p>
                    <div class="mt-3">
                        <span class="badge bg-light text-dark border p-2">Attendee: <strong id="modalUser">User</strong></span>
                        <span class="badge bg-light text-dark border p-2">Order #: <strong id="modalBookingId">000</strong></span>
                    </div>
                </div>
                <div class="ticket-footer">
                    &copy; Univent Inc. • valid for one entry only
                </div>
            </div>
            <div class="text-center mt-3">
                <button type="button" class="btn btn-light rounded-pill px-4 shadow-sm" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
    function loadTicket(id, title, date, loc, user) {
        document.getElementById('modalEventTitle').innerText = title;
        document.getElementById('modalEventDate').innerText = date;
        document.getElementById('modalEventLoc').innerText = loc;
        document.getElementById('modalUser').innerText = user;
        document.getElementById('modalBookingId').innerText = id;

        let textData = "UNIVENT TICKET DETAILS\n----------------------\nEvent: " + title + "\nDate:  " + date + "\nLoc:   " + loc + "\nUser:  " + user + "\nID:    #" + id + "\n----------------------\nStatus: VALID";
        let qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=" + encodeURIComponent(textData);
        document.getElementById('modalQrCode').src = qrUrl;
    }

    document.addEventListener("DOMContentLoaded", function(){
        const navbarCollapse = document.getElementById('navbarNav');
        const userDropdownBtn = document.getElementById('userMenu');

        // 1. If Hamburger opens -> Close Avatar Dropdown
        navbarCollapse.addEventListener('show.bs.collapse', function () {
            if (userDropdownBtn && userDropdownBtn.classList.contains('show')) {
                // Using Bootstrap 5 API to hide dropdown
                const dropdownInstance = bootstrap.Dropdown.getInstance(userDropdownBtn);
                if(dropdownInstance) dropdownInstance.hide();
            }
        });

        // 2. If Avatar Dropdown opens -> Close Hamburger
        if(userDropdownBtn) {
            userDropdownBtn.addEventListener('show.bs.dropdown', function () {
                // Check if navbar is open
                if (navbarCollapse.classList.contains('show')) {
                    // Using Bootstrap 5 API to hide collapse
                    const collapseInstance = bootstrap.Collapse.getInstance(navbarCollapse);
                    if(collapseInstance) collapseInstance.hide();
                }
            });
        }
    });
</script>

<jsp:include page="../footer.jsp" />
</body>
</html>