<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Secure Checkout - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        /* MODAL PAGE STYLING */
        body {
            background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Dark Overlay effect */
        body::before {
            content: "";
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.75);
            z-index: -1;
        }

        .checkout-container {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.5);
            overflow: hidden;
            width: 100%;
            max-width: 950px;
            position: relative;
            animation: slideIn 0.4s ease-out;
            min-height: 550px; /* Fixed height for consistency */
        }

        @keyframes slideIn {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        /* Close Button (X) */
        .btn-close-modal {
            position: absolute;
            top: 20px;
            right: 25px;
            z-index: 10;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #6c757d;
            cursor: pointer;
            transition: color 0.2s;
            text-decoration: none;
        }
        .btn-close-modal:hover { color: #000; }

        /* Left Panel: Summary */
        .summary-section {
            background-color: #2c1a4d;
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            height: 550px;
        }

        .summary-header { border-bottom: 2px solid #ffc107; padding-bottom: 15px; margin-bottom: 25px; }

        /* Scrollable Item Area */
        .cart-items-scroll {
            flex-grow: 1;
            overflow-y: auto;
            margin-bottom: 20px;
            padding-right: 10px;
        }

        /* Custom Scrollbar for dark theme */
        .cart-items-scroll::-webkit-scrollbar { width: 6px; }
        .cart-items-scroll::-webkit-scrollbar-track { background: rgba(255,255,255,0.1); }
        .cart-items-scroll::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.3); border-radius: 3px; }

        /* Right Panel: Payment Form */
        .payment-section {
            padding: 40px;
            position: relative;
            height: 550px; /* Match container height */
            overflow-y: auto;
        }

        .total-row {
            font-size: 1.5rem;
            font-weight: bold;
            color: #ffc107;
            margin-top: auto; /* Pushes to bottom */
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.2);
            background-color: #2c1a4d;
        }

        /* Payment Options Styling */
        .card-option {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .card-option:hover { border-color: #2c1a4d; background-color: #f8f9fa; }
        .card-option.selected { border-color: #2c1a4d; background-color: rgba(44, 26, 77, 0.05); }

        .btn-pay {
            background-color: #2c1a4d;
            color: white; font-weight: bold;
            padding: 15px; border-radius: 8px; width: 100%; transition: all 0.3s;
            margin-top: 20px;
        }
        .btn-pay:hover { background-color: #4a2c82; color: white; }

        /* Success State Styling */
        .success-wrapper {
            height: 550px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 50px;
        }
        .success-icon {
            font-size: 5rem;
            color: #198754;
            margin-bottom: 20px;
            animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        @keyframes popIn {
            from { transform: scale(0); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        /* --- MOBILE RESPONSIVENESS (Add to bottom of style tag) --- */
        @media (max-width: 991px) {
            .checkout-container {
                height: auto !important;
                min-height: auto !important;
                display: flex;
                flex-direction: column;
                margin-top: 20px;
                margin-bottom: 20px;
            }

            .summary-section, .payment-section, .success-wrapper {
                height: auto !important; /* Let content dictate height */
                padding: 30px 20px;
            }

            .summary-section {
                order: 1; /* Show summary first */
                border-bottom: 5px solid #ffc107; /* Visual divider */
            }

            .payment-section {
                order: 2; /* Show payment/buttons second */
            }

            /* Fix the absolute positioned form in Free Checkout */
            form[style*="absolute"] {
                position: static !important; /* Stop floating */
                margin-top: 20px;
                padding: 0;
            }

            /* Adjust scroll areas */
            .cart-items-scroll {
                max-height: 250px; /* Limit height on mobile */
            }

            /* Fix Total Row */
            .total-row {
                position: static;
                margin-top: 20px;
            }

            /* Fix Close Button position */
            .btn-close-modal {
                top: 10px;
                right: 15px;
                color: white; /* Make visible against dark summary header if needed */
                background-color: rgba(0,0,0,0.5); /* Background for visibility */
                width: 30px;
                height: 30px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                padding-bottom: 4px;
            }
        }
    </style>
</head>
<body>

<div class="checkout-container">

    <a href="${pageContext.request.contextPath}/${not empty message ? 'EventListServlet' : 'CartServlet'}"
       class="btn-close-modal" title="Close">&times;</a>

    <c:choose>
        <%-- STATE 1: PAYMENT SUCCESSFUL --%>
        <c:when test="${not empty message}">
            <div class="success-wrapper">
                <div class="success-icon">✓</div>
                <h2 class="fw-bold mb-3" style="color: #2c1a4d;">Payment Successful!</h2>
                <p class="text-muted mb-4" style="max-width: 400px;">
                        ${message}
                </p>
                <div class="d-flex gap-3">
                    <a href="${pageContext.request.contextPath}/OrderHistoryServlet" class="btn btn-outline-dark rounded-pill px-4">View My Tickets</a>
                    <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-success rounded-pill px-4">Continue Shopping</a>
                </div>
            </div>
        </c:when>

        <%-- STATE 2: CHECKOUT FORM --%>
        <c:otherwise>
            <div class="row g-0">
                <div class="col-md-5 summary-section">
                    <div class="summary-header">
                        <h4 class="mb-0 fw-bold">Order Summary</h4>
                    </div>

                        <%-- Calculate Total at top of scope --%>
                    <c:set var="totalAmount" value="0" />

                    <div class="cart-items-scroll">
                        <c:forEach var="item" items="${sessionScope.cart}">
                            <div class="d-flex justify-content-between mb-3 border-bottom border-secondary pb-2">
                                <div>
                                    <div class="fw-bold">
                                            ${item.title}
                                            <%-- UPDATED: Show Quantity Badge --%>
                                        <span class="badge bg-light text-dark ms-1">x${item.quantity}</span>
                                    </div>
                                    <small class="text-white-50">${item.location}</small>
                                </div>
                                    <%-- UPDATED: Show Price * Quantity --%>
                                <span class="fw-bold">RM <fmt:formatNumber value="${item.price * item.quantity}" type="number" minFractionDigits="2"/></span>
                            </div>

                            <%-- UPDATED: Add Price * Quantity to Total --%>
                            <c:set var="totalAmount" value="${totalAmount + (item.price * item.quantity)}" />
                        </c:forEach>

                        <c:if test="${empty sessionScope.cart}">
                            <p class="text-white-50">Your cart is empty.</p>
                        </c:if>
                    </div>

                    <div class="total-row d-flex justify-content-between align-items-center">
                        <span>TOTAL</span>
                        <span>RM <fmt:formatNumber value="${totalAmount}" type="number" minFractionDigits="2"/></span>
                    </div>
                </div>

                <div class="col-md-7 payment-section">
                    <c:choose>
                        <%-- CASE 1: FREE ORDER (Total=0) --%>
                    <c:when test="${totalAmount == 0}">
                        <h3 class="fw-bold mb-4" style="color: #2c1a4d;">Confirm Booking
                        </h3>

                            <div class="alert alert-info py-3 shadow-sm border-0"
                                 style="background-color: #e3f2fd; color: #0d47a1;">
                                <h5 class="alert-heading fw-bold mb-1">Free Event</h5>
                                <p class="mb-0 small">No payment is required for this order.
                                    Click below to confirm.</p>
                            </div>

                            <form
                                    action="${pageContext.request.contextPath}/CheckoutServlet"
                                    method="post"
                                    style="position: absolute; bottom: 40px; left: 40px; right: 40px;">
                                    <%-- Send 'free' to skip validation server-side --%>
                                <input type="hidden" name="paymentMethod" value="free">

                                <button type="submit" class="btn-pay shadow-sm mt-3">
                                    Confirm Booking
                                </button>

                                <div class="text-center mt-3">
                                    <small class="text-muted">Instant
                                        Confirmation</small>
                                </div>
                            </form>
                        </div>
                    </c:when>

                        <%-- CASE 2: PAID ORDER (Show Card Form) --%>
                    <c:otherwise>
                    <h3 class="fw-bold mb-4" style="color: #2c1a4d;">Payment Details</h3>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger p-2 small text-center rounded mb-3">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/CheckoutServlet" method="post" id="paymentForm" novalidate>

                        <div class="mb-4">
                            <label class="form-label text-muted small fw-bold mb-2">SELECT METHOD</label>

                            <c:forEach var="card" items="${savedCards}">
                                <div class="card-option d-flex align-items-center" onclick="selectCard(${card.id})">
                                    <input class="form-check-input me-3" type="radio" name="paymentMethod" id="card_${card.id}" value="${card.id}" onchange="toggleNewCardForm(false)">
                                    <div>
                                        <div class="fw-bold text-dark">${card.cardAlias}</div>
                                        <div class="text-muted small">Expires: ${card.expiry}</div>
                                    </div>
                                </div>
                            </c:forEach>

                            <div class="card-option d-flex align-items-center" onclick="selectNewCard()">
                                <input class="form-check-input me-3" type="radio" name="paymentMethod" id="newCardRadio" value="new" checked onchange="toggleNewCardForm(true)">
                                <span class="fw-bold text-dark">+ Add New Card</span>
                            </div>
                        </div>

                        <div id="newCardForm">
                            <div class="mb-3">
                                <label for="cardNumberInput" class="form-label text-muted small fw-bold">CARD NUMBER</label>
                                <input type="text" name="cardNumber" id="cardNumberInput" class="form-control form-control-lg" placeholder="0000 0000 0000 0000" maxlength="19">
                                <div class="invalid-feedback">Invalid card number. Must be 13-19 digits.</div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="expiryInput" class="form-label text-muted small fw-bold">EXPIRY DATE</label>
                                    <input type="text" name="expiry" id="expiryInput" class="form-control form-control-lg" placeholder="MM/YY" maxlength="5">
                                    <div class="invalid-feedback">Invalid format. Use MM/YY.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="cvvInput" class="form-label text-muted small fw-bold">CVV / CVC</label>
                                    <input type="password" name="cvv" id="cvvInput" class="form-control form-control-lg" placeholder="123" maxlength="4">
                                    <div class="invalid-feedback">Must be 3 or 4 digits.</div>
                                </div>
                            </div>

                            <div class="form-check mt-2">
                                <input class="form-check-input" type="checkbox" name="saveCard" id="saveCard" checked>
                                <label class="form-check-label text-muted small" for="saveCard">Save card securely for future payments</label>
                            </div>
                        </div>

                        <button type="submit" class="btn-pay shadow-sm">
                            Pay RM <fmt:formatNumber value="${totalAmount}" type="number" minFractionDigits="2"/>
                        </button>

                        <div class="text-center mt-3">
                            <small class="text-muted"><span class="me-1">🔒</span> 256-bit SSL Encrypted Payment</small>
                        </div>
                    </form>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</div>
</c:otherwise>
</c:choose>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

<script>
    if (document.getElementById('paymentForm')) {
        function toggleNewCardForm(show) {
            const form = document.getElementById('newCardForm');
            const inputs = form.querySelectorAll('input:not([type="checkbox"])');

            if (show) {
                form.style.display = 'block';
                inputs.forEach(i => i.disabled = false);
                document.querySelector('#newCardRadio').closest('.card-option').classList.add('selected');
                document.querySelectorAll('input[name="paymentMethod"]:not(#newCardRadio)').forEach(el => {
                    el.closest('.card-option').classList.remove('selected');
                });
            } else {
                form.style.display = 'none';
                inputs.forEach(i => i.disabled = true);
                document.querySelectorAll('.card-option').forEach(el => el.classList.remove('selected'));
                const checked = document.querySelector('input[name="paymentMethod"]:checked');
                if(checked) checked.closest('.card-option').classList.add('selected');
            }
        }

        window.selectCard = function(id) {
            document.getElementById('card_' + id).checked = true;
            toggleNewCardForm(false);
        };

        window.selectNewCard = function() {
            document.getElementById('newCardRadio').checked = true;
            toggleNewCardForm(true);
        };

        if(document.getElementById('newCardRadio').checked) {
            selectNewCard();
        } else {
            toggleNewCardForm(false);
        }

        document.getElementById('paymentForm').addEventListener('submit', function(event) {
            const isNewCard = document.getElementById('newCardRadio').checked;
            if (!isNewCard) return;

            let isValid = true;
            const cardInput = document.getElementById('cardNumberInput');
            const expiryInput = document.getElementById('expiryInput');
            const cvvInput = document.getElementById('cvvInput');

            [cardInput, expiryInput, cvvInput].forEach(input => input.classList.remove('is-invalid'));

            const cleanCardVal = cardInput.value.replace(/\s/g, '');
            if (!/^\d{13,19}$/.test(cleanCardVal)) {
                cardInput.classList.add('is-invalid');
                isValid = false;
            }
            if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiryInput.value)) {
                expiryInput.classList.add('is-invalid');
                isValid = false;
            }
            if (!/^\d{3,4}$/.test(cvvInput.value)) {
                cvvInput.classList.add('is-invalid');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault();
                event.stopPropagation();
            }
        });

        document.getElementById('expiryInput').addEventListener('input', function(e) {
            let input = e.target.value.replace(/\D/g, '');
            if (input.length > 2) {
                input = input.substring(0, 2) + '/' + input.substring(2, 4);
            }
            e.target.value = input;
        });
    }
</script>

</body>
</html>