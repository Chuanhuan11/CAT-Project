<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Shopping Cart - Univent</title>
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

        /* --- DESKTOP TABLE STYLES --- */
        .custom-table thead {
            background-color: #2c1a4d;
            color: white;
            border-bottom: 3px solid #ffc107;
        }
        .custom-table th {
            padding: 15px;
            font-weight: 600;
            text-transform: uppercase;
            border: none;
        }
        .custom-table td {
            vertical-align: middle;
            padding: 15px;
        }

        /* --- FOOTER LAYOUT --- */
        .total-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            border: 1px solid #e9ecef;
        }
        .footer-actions {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .action-btn { width: 100%; }
        .total-display { text-align: center; margin-bottom: 10px; }

        @media (min-width: 768px) {
            .footer-actions {
                flex-direction: row;
                justify-content: space-between;
                align-items: center;
            }
            .action-btn { width: auto !important; min-width: 180px; }
            .right-section { display: flex; align-items: center; gap: 20px; }
            .total-display { text-align: right; margin-bottom: 0; margin-right: 10px; }
        }

        /* --- MOBILE CARD DESIGN (FLEXBOX FIX) --- */
        @media (max-width: 768px) {
            .custom-table thead { display: none; }

            /* The Card Container: Uses Flex Wrap to flow naturally */
            .custom-table tbody tr {
                display: flex;
                flex-wrap: wrap;
                align-items: flex-start;
                margin-bottom: 20px;
                background: #fff;
                border: 1px solid #e0e0e0;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.03);
                padding: 10px;
            }

            /* 1. CHECKBOX (Top Left) */
            .custom-table td.checkbox-cell {
                width: 40px;
                order: 1;
                border: none;
                padding: 5px;
            }

            /* 2. TITLE + DATE (Top Middle - Header) */
            .custom-table td.event-name-cell {
                width: calc(100% - 90px); /* Full width minus checkbox & trash */
                order: 2;
                border: none;
                padding: 5px 0;
                text-align: left;
            }
            .event-name-cell .title-text {
                font-size: 1.1rem;
                font-weight: bold;
                color: #2c1a4d;
                line-height: 1.2;
                display: block;
            }
            .event-name-cell .date-text {
                font-size: 0.85rem;
                color: #e65100; /* Orange for date */
                font-weight: 600;
                margin-top: 4px;
                display: block;
            }

            /* 3. TRASH ICON (Top Right) */
            .custom-table td.action-cell {
                width: 40px;
                order: 3;
                border: none;
                padding: 5px;
                text-align: right;
            }

            /* 4. GRID ITEMS (Venue, Price, Qty, Total) */
            .custom-table td {
                width: 50%; /* Half width */
                border: none;
                padding: 10px 5px;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                order: 4;
                border-bottom: 1px solid #f5f5f5;
            }

            /* Labels */
            .custom-table td::before {
                content: attr(data-label);
                font-size: 0.75rem;
                text-transform: uppercase;
                color: #888;
                font-weight: 700;
                margin-bottom: 4px;
            }

            /* Align Price & Total to right */
            .custom-table td:nth-child(4), /* Price */
            .custom-table td:nth-child(6) { /* Total */
                text-align: right;
                align-items: flex-end;
            }

            /* Remove border from last row */
            .custom-table td:last-child { border-bottom: none; }

            /* Trash Icon Styling */
            .btn-remove-custom {
                color: #dc3545;
                background: none;
                border: none;
                padding: 0;
            }

            /* Mobile Select All Bar */
            .mobile-select-all {
                background: #fff;
                border: 1px solid #e0e0e0;
                border-radius: 12px;
                padding: 15px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="30" height="30" class="me-2 rounded-circle">
            Univent
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/EventListServlet">Catalog</a></li>
                <li class="nav-item"><a class="nav-link active fw-bold" href="${pageContext.request.contextPath}/CartServlet">My Cart</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="hero-section text-center">
    <div class="container">
        <h2 class="fw-bold">Your Shopping Cart</h2>
        <p class="mb-0">Review your selected events.</p>
    </div>
</div>

<div class="container mb-5">
    <div class="content-box">
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                    ${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${empty sessionScope.cart}">
            <div class="text-center py-5">
                <h3 class="text-muted mb-3">Your cart is empty.</h3>
                <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-primary rounded-pill px-5">Browse Events</a>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.cart}">
            <form action="${pageContext.request.contextPath}/CartServlet" method="post" id="cartForm">
                <input type="hidden" name="action" value="prepareCheckout">

                    <%-- MOBILE ONLY: Select All Bar --%>
                <div class="d-md-none mobile-select-all">
                    <input type="checkbox" id="selectAllMobile" class="form-check-input me-3"
                           style="width: 1.3em; height: 1.3em;" checked onchange="toggleAll(this)">
                    <span class="fw-bold text-dark">Select All Items</span>
                </div>

                <div class="table-responsive-md">
                    <table class="table custom-table mb-0">
                        <thead>
                        <tr>
                                <%-- DESKTOP: Select All Header --%>
                            <th>
                                <div class="d-flex align-items-center gap-2">
                                    <input type="checkbox" id="selectAll" class="form-check-input" checked onchange="toggleAll(this)">
                                    <span class="small">Select All</span>
                                </div>
                            </th>
                            <th>Event Details</th>
                            <th>Venue</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th class="text-center">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:set var="grandTotal" value="0" />

                        <c:forEach var="item" items="${sessionScope.cart}">
                            <tr class="cart-row" data-id="${item.id}" data-price="${item.price}" data-available="${item.availableSeats}">

                                    <%-- 1. CHECKBOX --%>
                                <td class="checkbox-cell">
                                    <input type="checkbox" name="selectedEvents" value="${item.id}"
                                           class="form-check-input item-check" checked
                                           onchange="updateGrandTotal()">
                                </td>

                                    <%-- 2. TITLE + DATE --%>
                                <td class="event-name-cell">
                                    <span class="title-text">${item.title}</span>
                                    <span class="date-text d-md-none">${item.eventDate}</span>
                                    <span class="d-none d-md-block small text-muted">${item.eventDate}</span>
                                </td>

                                    <%-- 3. VENUE --%>
                                <td data-label="Venue">
                                    <span class="text-muted">${item.location}</span>
                                </td>

                                    <%-- 4. PRICE --%>
                                <td data-label="Price">
                                    <span class="text-muted">RM <fmt:formatNumber value="${item.price}" type="number" minFractionDigits="2" /></span>
                                </td>

                                    <%-- 5. QUANTITY --%>
                                <td data-label="Quantity">
                                    <div class="input-group input-group-sm" style="width: 100px;">
                                        <button class="btn btn-outline-secondary qty-btn" type="button" onclick="updateCartQuantity(${item.id}, -1, this)">-</button>
                                        <input type="text" class="form-control text-center bg-white qty-input" value="${item.quantity}" readonly>
                                        <button class="btn btn-outline-secondary qty-btn" type="button" onclick="updateCartQuantity(${item.id}, 1, this)">+</button>
                                    </div>
                                    <div class="text-danger small mt-1 max-msg" style="display:none;">Max reached</div>
                                </td>

                                    <%-- 6. TOTAL --%>
                                <td class="fw-bold text-dark row-total" data-label="Subtotal">
                                    RM <fmt:formatNumber value="${item.price * item.quantity}" type="number" minFractionDigits="2" />
                                </td>

                                    <%-- 7. ACTION --%>
                                <td class="action-cell">
                                    <a href="${pageContext.request.contextPath}/CartServlet?action=remove&eventId=${item.id}"
                                       class="btn-remove-custom"
                                       onclick="return confirm('Remove this event?');">
                                        <span class="d-md-none">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-trash3-fill" viewBox="0 0 16 16">
                                                <path d="M11 1.5v1h3.5a.5.5 0 0 1 0 1h-.538l-.853 10.66A2 2 0 0 1 11.115 16h-6.23a2 2 0 0 1-1.994-1.84L2.038 3.5H1.5a.5.5 0 0 1 0-1H5v-1A1.5 1.5 0 0 1 6.5 0h3A1.5 1.5 0 0 1 11 1.5Zm-5 0v1h4v-1a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5ZM4.5 5.029l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5a.5.5 0 1 0-.998.06Zm6.53-.528a.5.5 0 0 0-.528.47l-.5 8.5a.5.5 0 0 0 .998.058l.5-8.5a.5.5 0 0 0-.47-.528ZM8 4.5a.5.5 0 0 0-.5.5v8.5a.5.5 0 0 0 1 0V5a.5.5 0 0 0-.5-.5Z"/>
                                            </svg>
                                        </span>
                                        <span class="d-none d-md-inline-block btn btn-outline-danger btn-sm rounded-pill px-3">
                                            Remove
                                        </span>
                                    </a>
                                </td>
                            </tr>
                            <c:set var="grandTotal" value="${grandTotal + (item.price * item.quantity)}" />
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="total-section footer-actions">
                    <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-outline-secondary rounded-pill px-4 action-btn">
                        &larr; Shop More
                    </a>

                    <div class="right-section">
                        <div class="total-display">
                            <span class="text-muted small d-block">Total Amount</span>
                            <span class="h3 fw-bold text-dark m-0" id="grandTotalDisplay">
                            RM <fmt:formatNumber value="${grandTotal}" type="number" minFractionDigits="2" />
                        </span>
                        </div>

                        <button type="submit" class="btn btn-success btn-lg rounded-pill px-5 fw-bold shadow-sm action-btn">
                            Checkout &rarr;
                        </button>
                    </div>
                </div>
            </form>
        </c:if>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = "${pageContext.request.contextPath}";

    // Toggle All Function (Works for both Mobile and Desktop)
    function toggleAll(source) {
        const isChecked = source.checked;

        // 1. Sync the OTHER master checkbox (e.g. if mobile clicked, update desktop)
        const deskCheck = document.getElementById('selectAll');
        const mobCheck = document.getElementById('selectAllMobile');

        if (deskCheck) deskCheck.checked = isChecked;
        if (mobCheck) mobCheck.checked = isChecked;

        // 2. Update all item checkboxes
        document.querySelectorAll('.item-check').forEach(box => {
            box.checked = isChecked;
        });

        // 3. Recalculate totals
        updateGrandTotal();
    }

    function updateCartQuantity(eventId, change, btn) {
        const row = btn.closest('.cart-row');
        const input = row.querySelector('.qty-input');
        const totalCell = row.querySelector('.row-total');
        const msgDiv = row.querySelector('.max-msg');

        const price = parseFloat(row.dataset.price);
        const available = parseInt(row.dataset.available);
        let currentQty = parseInt(input.value);
        let newQty = currentQty + change;

        if (newQty < 1) return;
        if (newQty > available) {
            msgDiv.style.display = "block";
            setTimeout(() => msgDiv.style.display = "none", 2000);
            return;
        }

        input.value = newQty;
        let newRowTotal = (price * newQty).toFixed(2);
        totalCell.innerHTML = "RM " + newRowTotal;

        updateGrandTotal();

        fetch(contextPath + '/CartServlet', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'action=update&eventId=' + eventId + '&quantity=' + newQty
        }).catch(err => console.error(err));
    }

    function updateGrandTotal() {
        let grandTotal = 0;

        // Calculate Total
        document.querySelectorAll('.cart-row').forEach(row => {
            const checkbox = row.querySelector('.item-check');
            if (checkbox.checked) {
                const price = parseFloat(row.dataset.price);
                const qty = parseInt(row.querySelector('.qty-input').value);
                grandTotal += (price * qty);
            }
        });
        document.getElementById('grandTotalDisplay').innerText = "RM " + grandTotal.toFixed(2);

        // Check Logic: If ALL items are manually checked, check the Master "Select All" boxes
        const allChecks = document.querySelectorAll('.item-check');
        const allChecked = Array.from(allChecks).every(c => c.checked) && allChecks.length > 0;

        const deskCheck = document.getElementById('selectAll');
        const mobCheck = document.getElementById('selectAllMobile');

        if (deskCheck) deskCheck.checked = allChecked;
        if (mobCheck) mobCheck.checked = allChecked;
    }
</script>
</body>
</html>