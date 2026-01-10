<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
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

        /* --- HERO SECTION --- */
        .hero-section {
            background-color: rgba(50, 13, 70, 0.9);
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
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

        /* Past Event Style (Grey) */
        .past-event-card {
            background-color: #f2f2f2;
            border: 1px solid #dcdcdc;
            color: #6c757d;
            filter: grayscale(100%);
        }
        .past-event-card:hover { transform: none; }

        /* Sold Out Event Style (Light Red) */
        .soldout-event-card {
            background-color: #fff5f5;
            border: 1px solid #ffc9c9;
        }
        .soldout-event-card:hover { transform: none; }

        .floating-alert {
            position: fixed; top: 80px; right: 20px; z-index: 9999;
            min-width: 300px; box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            animation: slideInRight 0.5s ease-out;
        }
        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        /* --- AVATAR STYLES FIX --- */
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

        /* --- MOBILE SEARCH BAR FIX --- */
        .mobile-search-container {
            margin-top: -20px; /* Pull it slightly up into the gap */
            margin-bottom: 30px;
        }
        .search-input-field {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1) !important;
            border: none;
        }

        /* --- MODAL STYLES --- */
        .modal-details-img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-top-left-radius: calc(0.3rem - 1px);
            border-top-right-radius: calc(0.3rem - 1px);
        }

        .desc-scroll-area {
            max-height: 120px;
            overflow-y: auto;
            overflow-x: hidden;
            padding-right: 10px;
            margin-bottom: 15px;
            border: 1px solid #f1f1f1;
            padding: 10px;
            border-radius: 5px;
            background-color: #fafafa;
        }
        .desc-scroll-area p {
            word-wrap: break-word;
            white-space: normal;
            margin-bottom: 0;
        }
        .desc-scroll-area::-webkit-scrollbar { width: 5px; }
        .desc-scroll-area::-webkit-scrollbar-thumb { background: #ccc; border-radius: 3px; }

        /* --- MOBILE NAVBAR GAP FIX --- */
        @media (max-width: 991px) {
            .navbar-collapse {
                background-color: #212529;
                padding: 15px;
                border-radius: 0 0 10px 10px;
                margin-top: 0;
                position: absolute;
                top: 120%;
                width: 100%;
                left: 0;
                z-index: 1000;
                box-shadow: 0 10px 15px rgba(0,0,0,0.3);
            }
            .floating-alert {
                width: 90%;
                right: 5%;
                left: 5%;
                min-width: auto;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container position-relative">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="me-2 rounded-circle">
            Univent
        </a>

        <div class="d-flex align-items-center ms-auto order-lg-last">
            <c:choose>
                <c:when test="${not empty sessionScope.username}">
                    <div class="dropdown">
                        <button class="user-avatar-btn dropdown-toggle" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                            <svg class="user-avatar-svg" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                            </svg>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                            <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ORGANIZER'}">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/OrganiserDashboardServlet">Dashboard</a></li>
                            </c:if>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/OrderHistoryServlet">My Tickets</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/user/login.jsp" class="btn btn-warning btn-sm fw-bold px-3 rounded-pill">Login</a>
                </c:otherwise>
            </c:choose>
        </div>

        <button class="navbar-toggler ms-2" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse me-3" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/EventListServlet">Catalog</a></li>
                <c:if test="${not empty sessionScope.username}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/CartServlet">My Cart</a></li>
                </c:if>
            </ul>

            <div class="d-none d-lg-block">
                <input class="form-control form-control-sm rounded-pill px-3 search-input-field" type="search" placeholder="Search events...">
            </div>
        </div>
    </div>
</nav>

<%-- HERO HEADER --%>
<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">Univent Catalog</h2>
        <p class="mb-0">Find your next experience here.</p>
    </div>
</div>

<%-- MOBILE SEARCH BAR (Below Hero) --%>
<div class="container mobile-search-container d-lg-none">
    <div class="input-group">
        <span class="input-group-text bg-white border-0 shadow-sm ps-3">
             <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#aaa" class="bi bi-search" viewBox="0 0 16 16">
                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
            </svg>
        </span>
        <input class="form-control form-control-lg border-0 shadow-sm search-input-field" type="search" placeholder="Search events..." style="height: 50px;">
    </div>
</div>

<%-- SUCCESS/ERROR MESSAGES --%>
<c:if test="${not empty sessionScope.successMessage}">
    <div class="alert alert-success alert-dismissible fade show floating-alert" role="alert">
        <strong>Success!</strong> ${sessionScope.successMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="successMessage" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show floating-alert" role="alert">
        <strong>Error:</strong> ${sessionScope.errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <c:remove var="errorMessage" scope="session"/>
</c:if>

<div class="container mb-5">
    <div class="content-box">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold text-dark">Upcoming Events</h3>
            <span id="filterCount" class="text-muted small">Browsing Catalog</span>
        </div>

        <div id="noResultsMessage" class="alert alert-light text-center border" style="display:none;">
            <h4>No events found matching your search.</h4>
            <button class="btn btn-outline-primary btn-sm mt-2" onclick="clearFilter()">Clear Search</button>
        </div>

        <div class="row" id="eventsContainer">
            <c:forEach var="event" items="${upcomingEvents}">
                <div class="col-md-4 mb-4 event-item">
                    <div class="card h-100 shadow-sm event-card">
                        <div class="position-relative">
                            <c:choose>
                                <c:when test="${not empty event.imageUrl}">
                                    <c:choose>
                                        <%-- Case 1: Cloudinary/External URL --%>
                                        <c:when test="${event.imageUrl.startsWith('http')}">
                                            <img src="${event.imageUrl}" class="card-img-top" alt="${event.title}">
                                        </c:when>
                                        <%-- Case 2: Local File (Fallback) --%>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/img/${event.imageUrl}" class="card-img-top" alt="${event.title}">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <img src="https://placehold.co/600x400?text=No+Image" class="card-img-top" alt="Placeholder">
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card-body">
                            <h5 class="card-title event-title">${event.title}</h5>
                            <p class="card-text text-muted small">
                                <span class="badge bg-secondary me-1">DATE</span> ${event.eventDate} <br>
                                <span class="badge bg-secondary me-1">LOC</span> ${event.location}
                            </p>
                            <h6 class="text-primary mt-2">
                                <c:choose>
                                    <c:when test="${event.price == 0}">FREE</c:when>
                                    <c:otherwise>RM <fmt:formatNumber value="${event.price}" type="number" minFractionDigits="2" maxFractionDigits="2" /></c:otherwise>
                                </c:choose>
                            </h6>
                            <div class="d-none full-description">${event.description}</div>
                            <p class="card-text mt-3 text-secondary event-desc" style="font-size: 0.9rem;">
                                    ${event.description.length() > 60 ? event.description.substring(0, 60).concat('...') : event.description}
                            </p>
                        </div>
                        <div class="card-footer bg-white border-top-0 pb-3">
                            <button class="btn btn-primary w-100 fw-bold"
                                    onclick="openDetailsModal('${event.id}', '${event.title}', this, '${event.eventDate}', '${event.location}', '${event.price}', '${event.imageUrl}', '${event.availableSeats}', 'upcoming')">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty upcomingEvents}">
                <div class="col-12 text-center py-4 text-muted">No upcoming events found.</div>
            </c:if>
        </div>

        <c:if test="${not empty soldOutEvents}">
            <hr class="my-5">
            <h3 class="fw-bold text-danger mb-4">Sold Out Events</h3>
            <div class="row">
                <c:forEach var="event" items="${soldOutEvents}">
                    <div class="col-md-4 mb-4 event-item">
                        <div class="card h-100 soldout-event-card shadow-sm">
                            <div class="position-relative">
                                <c:choose>
                                    <c:when test="${not empty event.imageUrl}">
                                        <c:choose>
                                            <%-- Case 1: Cloudinary/External URL --%>
                                            <c:when test="${event.imageUrl.startsWith('http')}">
                                                <img src="${event.imageUrl}" class="card-img-top" alt="${event.title}">
                                            </c:when>
                                            <%-- Case 2: Local File (Fallback) --%>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/assets/img/${event.imageUrl}" class="card-img-top" alt="${event.title}">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://placehold.co/600x400?text=No+Image" class="card-img-top" alt="Placeholder">
                                    </c:otherwise>
                                </c:choose>
                                <div class="position-absolute top-50 start-50 translate-middle">
                                    <span class="badge bg-danger fs-5 shadow">SOLD OUT</span>
                                </div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title event-title text-muted">${event.title}</h5>
                                <p class="card-text text-muted small"><span class="badge bg-secondary me-1">DATE</span> ${event.eventDate}</p>
                                <div class="d-none full-description">${event.description}</div>
                            </div>
                            <div class="card-footer bg-light border-top-0 pb-3">
                                <button class="btn btn-secondary w-100" onclick="openDetailsModal('${event.id}', '${event.title}', this, '${event.eventDate}', '${event.location}', '${event.price}', '${event.imageUrl}', 0, 'soldout')">View Details (Full)</button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${not empty pastEvents}">
            <hr class="my-5">
            <h3 class="fw-bold text-secondary mb-4">Past Events</h3>
            <div class="row">
                <c:forEach var="event" items="${pastEvents}">
                    <div class="col-md-4 mb-4 event-item">
                        <div class="card h-100 past-event-card shadow-sm">
                            <div class="position-relative">
                                <c:choose>
                                    <c:when test="${not empty event.imageUrl}">
                                        <c:choose>
                                            <%-- Case 1: Cloudinary/External URL --%>
                                            <c:when test="${event.imageUrl.startsWith('http')}">
                                                <img src="${event.imageUrl}" class="card-img-top" alt="${event.title}">
                                            </c:when>
                                            <%-- Case 2: Local File (Fallback) --%>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/assets/img/${event.imageUrl}" class="card-img-top" alt="${event.title}">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://placehold.co/600x400?text=No+Image" class="card-img-top" alt="Placeholder">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title event-title text-muted">${event.title}</h5>
                                <div class="d-none full-description">${event.description}</div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<%-- MODAL --%>
<div class="modal fade" id="detailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0">
            <div class="position-relative">
                <img id="modalImg" src="" class="modal-details-img" alt="Event">
                <button type="button" class="btn-close position-absolute top-0 end-0 m-3 bg-white p-2 shadow-sm" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <div>
                        <h2 class="fw-bold mb-1" id="modalTitle" style="color: #2c1a4d;"></h2>
                        <span class="badge bg-primary fs-6 me-2" id="modalDate"></span>
                        <span class="badge bg-secondary fs-6" id="modalLoc"></span>
                    </div>
                    <div class="text-end">
                        <h3 class="text-success fw-bold" id="modalPrice"></h3>
                        <small class="text-muted" id="modalSeats"></small>
                    </div>
                </div>
                <h5 class="fw-bold text-muted mt-3 mb-2">About this Event</h5>
                <div class="desc-scroll-area"><p id="modalDesc" class="lead fs-6 text-secondary"></p></div>
                <form action="${pageContext.request.contextPath}/CartServlet" method="post" class="mt-3">
                    <input type="hidden" name="eventId" id="modalEventId">
                    <input type="hidden" name="action" value="add">
                    <div class="row g-2 align-items-center">
                        <div class="col-4">
                            <label class="form-label fw-bold small text-muted mb-1">Quantity</label>
                            <div class="input-group">
                                <button class="btn btn-outline-secondary" type="button" onclick="updateModalQuantity(-1)">-</button>
                                <input type="text" id="modalQuantity" name="quantity" class="form-control text-center bg-white" value="1" readonly>
                                <button class="btn btn-outline-secondary" type="button" onclick="updateModalQuantity(1)">+</button>
                            </div>
                        </div>
                        <div class="col-8">
                            <label class="form-label d-block mb-1">&nbsp;</label>
                            <button type="submit" id="modalBtn" class="btn btn-success w-100 fw-bold">Add to Cart</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
    var detailsModal = new bootstrap.Modal(document.getElementById('detailsModal'));
    var modalMaxSeats = 1;

    // ... Modal Functions ...
    function openDetailsModal(id, title, btnRef, date, loc, price, img, seats, status) {
        let cardBody = btnRef.closest('.card').querySelector('.card-body');
        let fullDesc = cardBody.querySelector('.full-description').innerText;
        let priceVal = parseFloat(price);
        let displayPrice = (priceVal === 0) ? "FREE" : "RM " + priceVal.toFixed(2);

        document.getElementById('modalEventId').value = id;
        document.getElementById('modalTitle').innerText = title;
        document.getElementById('modalDesc').innerText = fullDesc;
        document.getElementById('modalDate').innerText = date;
        document.getElementById('modalLoc').innerText = loc;
        document.getElementById('modalPrice').innerText = displayPrice;
        document.getElementById('modalSeats').innerText = seats + " seats remaining";

        if (img && img.trim() !== "") {
            document.getElementById('modalImg').src = "${pageContext.request.contextPath}/assets/img/" + img;
        } else {
            document.getElementById('modalImg').src = "https://placehold.co/600x400?text=No+Image";
        }

        if (img && img.trim() !== "") {
            if (img.startsWith("http")) {
                // It's a Cloudinary/External URL -> Use directly
                document.getElementById('modalImg').src = img;
            } else {
                // It's a Local File -> Prepend path
                document.getElementById('modalImg').src = "${pageContext.request.contextPath}/assets/img/" + img;
            }
        } else {
            document.getElementById('modalImg').src = "https://placehold.co/600x400?text=No+Image";
        }

        modalMaxSeats = parseInt(seats);
        document.getElementById('modalQuantity').value = 1;

        let btn = document.getElementById('modalBtn');
        let qtyInput = document.getElementById('modalQuantity');

        if (status === 'soldout') {
            btn.disabled = true;
            btn.innerText = "Sold Out";
            btn.classList.replace('btn-success', 'btn-secondary');
            qtyInput.disabled = true;
        } else {
            btn.disabled = false;
            btn.innerText = "Add to Cart";
            btn.classList.replace('btn-secondary', 'btn-success');
            qtyInput.disabled = false;
        }

        detailsModal.show();
    }

    function updateModalQuantity(change) {
        if (modalMaxSeats <= 0) return;
        let input = document.getElementById('modalQuantity');
        let val = parseInt(input.value);
        if (isNaN(val)) val = 1;
        let newVal = val + change;
        if (newVal >= 1 && newVal <= modalMaxSeats) {
            input.value = newVal;
        }
    }

    // --- SEARCH LOGIC ---
    const searchInputs = document.querySelectorAll('.search-input-field');

    searchInputs.forEach(input => {
        input.addEventListener('input', function() {
            let val = this.value;
            searchInputs.forEach(otherInput => {
                if(otherInput !== input) otherInput.value = val;
            });

            if (val === '') {
                clearFilter();
            } else {
                filterEvents(val);
            }
        });
    });

    function filterEvents(val) {
        let filter = val.toLowerCase();
        let items = document.querySelectorAll('.event-item');
        let visibleCount = 0;

        items.forEach(function(item) {
            let title = item.querySelector('.event-title').textContent.toLowerCase();
            let desc = item.querySelector('.full-description').textContent.toLowerCase();
            if (title.includes(filter) || desc.includes(filter)) {
                item.style.display = '';
                visibleCount++;
            } else { item.style.display = 'none'; }
        });

        let noResultsMsg = document.getElementById('noResultsMessage');
        if (visibleCount === 0) {
            noResultsMsg.style.display = 'block';
            document.getElementById('filterCount').textContent = "No events found";
        } else {
            noResultsMsg.style.display = 'none';
            document.getElementById('filterCount').textContent = "Showing " + visibleCount + " event(s)";
        }
    }

    function clearFilter() {
        searchInputs.forEach(input => input.value = '');
        let items = document.querySelectorAll('.event-item');
        items.forEach(item => item.style.display = '');
        document.getElementById('noResultsMessage').style.display = 'none';
        document.getElementById('filterCount').textContent = "Browsing Catalog";
    }
</script>
</body>
</html>