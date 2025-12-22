<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Univent - Catalog</title>
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
            padding: 60px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }
        .content-box {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 50px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        }
        .event-card { transition: transform 0.2s; }
        .event-card:hover { transform: scale(1.02); }
        .card-img-top { height: 200px; object-fit: cover; }

        /* NEW STYLE: Search Icon Positioning */
        .search-icon {
            pointer-events: none; /* Let clicks pass through to the input if needed */
            color: #6c757d;
        }
    </style>
</head>
<body>

<%-- NAVBAR SECTION --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">

        <%-- BRAND LOGO --%>
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png"
                 alt="Logo" width="30" height="30"
                 class="d-inline-block align-text-top me-2 rounded-circle">
            Univent
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">

            <%-- LEFT SIDE: NAVIGATION LINKS --%>
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/EventListServlet">Catalog</a>
                </li>
                <c:if test="${not empty sessionScope.username}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/booking/cart.jsp">My Cart</a>
                    </li>
                </c:if>
            </ul>

            <%-- RIGHT SIDE: SEARCH + LOGIN --%>
            <div class="d-flex align-items-center">

                <%-- 1. ROUNDED SEARCH BAR WITH ICON --%>
                <div class="me-3 position-relative">
                    <%-- Input: rounded-pill for shape, pe-5 to make room for icon --%>
                    <input id="searchInput"
                           class="form-control form-control-sm rounded-pill px-3 pe-5"
                           type="search"
                           placeholder="Search"
                           aria-label="Search"
                           style="width: 250px;">

                    <%-- Icon: Absolute position to the right --%>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                         class="bi bi-search position-absolute top-50 end-0 translate-middle-y me-3 search-icon"
                         viewBox="0 0 16 16">
                        <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                    </svg>
                </div>

                <%-- 2. AUTH BUTTONS --%>
                <div>
                    <c:choose>
                        <c:when test="${not empty sessionScope.username}">
                            <div class="dropdown">
                                <button class="btn btn-outline-light btn-sm dropdown-toggle fw-bold" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                    Hello, ${sessionScope.username}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                                    <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ORGANIZER'}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">Dashboard</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                    </c:if>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <%-- Login Button also uses rounded-pill for consistency --%>
                            <a href="${pageContext.request.contextPath}/user/login.jsp" class="btn btn-warning btn-sm fw-bold px-3 rounded-pill">Login</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </div>
</nav>

<%-- HERO SECTION --%>
<div class="hero-section text-center">
    <div class="container">
        <h1 class="display-4 fw-bold">Univent Catalog</h1>
        <p class="lead">Find your next experience here.</p>
    </div>
</div>

<%-- MAIN CONTENT --%>
<div class="container mb-5">
    <div class="content-box">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3>Upcoming Events</h3>
            <span id="filterCount" class="text-muted small">Showing all events</span>
        </div>

        <%-- EVENT GRID --%>
        <div class="row" id="eventsContainer">
            <c:forEach var="event" items="${eventList}">
                <div class="col-md-4 mb-4 event-item">
                    <div class="card h-100 event-card shadow-sm">
                        <img src="${pageContext.request.contextPath}/assets/img/${event.imageUrl}" class="card-img-top" alt="${event.title}">

                        <div class="card-body">
                            <h5 class="card-title event-title">${event.title}</h5>
                            <p class="card-text text-muted small">
                                <span class="badge bg-secondary me-1">DATE</span> ${event.eventDate} <br>
                                <span class="badge bg-secondary me-1">LOC</span> ${event.location}
                            </p>
                            <h6 class="text-primary mt-2">RM ${event.price}</h6>
                            <p class="card-text mt-3 text-secondary event-desc" style="font-size: 0.9rem;">
                                    ${event.description.length() > 60 ? event.description.substring(0, 60).concat('...') : event.description}
                            </p>
                        </div>

                        <div class="card-footer bg-white border-top-0 pb-3">
                            <a href="${pageContext.request.contextPath}/EventDetailsServlet?id=${event.id}" class="btn btn-primary w-100 fw-bold">View Details</a>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <div id="noResultsMessage" class="col-12 text-center py-5" style="display: none;">
                <h4 class="text-muted">No matching events found.</h4>
                <button class="btn btn-outline-primary mt-2" onclick="document.getElementById('searchInput').value=''; document.getElementById('searchInput').dispatchEvent(new Event('keyup'));">Clear Filter</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

<script>
    document.getElementById('searchInput').addEventListener('keyup', function() {
        let filter = this.value.toLowerCase();
        let items = document.querySelectorAll('.event-item');
        let visibleCount = 0;

        items.forEach(function(item) {
            let title = item.querySelector('.event-title').textContent.toLowerCase();
            let desc = item.querySelector('.event-desc').textContent.toLowerCase();

            if (title.includes(filter) || desc.includes(filter)) {
                item.style.display = '';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });

        let noResultsMsg = document.getElementById('noResultsMessage');
        if (visibleCount === 0) {
            noResultsMsg.style.display = 'block';
            document.getElementById('filterCount').textContent = "No events found";
        } else {
            noResultsMsg.style.display = 'none';
            document.getElementById('filterCount').textContent = "Showing " + visibleCount + " event(s)";
        }
    });
</script>

</body>
</html>