<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>Secure Checkout - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        body {
            background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 0;
        }

        .checkout-container {
            background-color: rgba(255, 255, 255, 0.96);
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }

        .summary-section {
            background-color: #2c1a4d;
            color: white;
            padding: 40px;
            /* Layout Fix: Ensures total stays at bottom */
            display: flex;
            flex-direction: column;
            min-height: 500px;
        }

        .payment-section { padding: 40px; }
        .summary-header { border-bottom: 2px solid #ffc107; padding-bottom: 15px; margin-bottom: 25px; }

        .total-row {
            font-size: 1.5rem;
            font-weight: bold;
            color: #ffc107;
            margin-top: auto; /* Pushes this row to the bottom */
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.2);
        }

        .card-option {
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .card-option:hover { border-color: #2c1a4d; background-color: #f8f9fa; }
        .card-option.selected { border-color: #2c1a4d; background-color: rgba(44, 26, 77, 0.05); }
        .form-check-input:checked { background-color: #2c1a4d; border-color: #2c1a4d; }

        .btn-pay {
            background-color: #2c1a4d; color: white; font-weight: bold;
            padding: 15px; border-radius: 8px; width: 100%; transition: all 0.3s;
        }
        .btn-pay:hover { background-color: #4a2c82; color: white; }
    </style>
</head>
<body>

<div class="container">
    <div class="checkout-container mx-auto">

        <c:set var="totalAmount" value="0" />
        <c:forEach var="item" items="${sessionScope.cart}">
            <c:set var="totalAmount" value="${totalAmount + item.price}" />
        </c:forEach>

        <c:choose>
            <c:when test="${not empty message}">
                <div class="text-center p-5">
                    <h1 style="font-size: 5rem; color: #28a745;">✓</h1>
                    <h2 class="fw-bold mb-3" style="color: #2c1a4d;">Payment Successful!</h2>
                    <p class="text-muted">${message}</p>
                    <div class="d-flex justify-content-center gap-3 mt-4">
                        <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-outline-dark rounded-pill px-4">Browse More</a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="row g-0 h-100">
                        <%-- Left: Summary (Total at Bottom) --%>
                    <div class="col-md-5 summary-section">
                        <div>
                            <div class="summary-header"><h4 class="mb-0 fw-bold">Order Summary</h4></div>
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <div class="d-flex justify-content-between mb-2 border-bottom border-secondary pb-2">
                                    <span>${item.title}</span>
                                    <span>RM ${item.price}</span>
                                </div>
                            </c:forEach>
                        </div>

                            <%-- TOTAL ROW (Pushed to bottom via mt-auto) --%>
                        <div class="total-row d-flex justify-content-between">
                            <span>TOTAL</span>
                            <span>RM <fmt:formatNumber value="${totalAmount}" type="number" minFractionDigits="2"/></span>
                        </div>
                        <div class="text-white-50 small mt-2 text-center">
                            <span class="me-2">🔒 SSL Secure</span>
                            <span>🛡️ Univent Protection</span>
                        </div>
                    </div>

                        <%-- Right: Payment Form --%>
                    <div class="col-md-7 payment-section">
                        <h3 class="fw-bold mb-4" style="color: #2c1a4d;">Payment Method</h3>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/CheckoutServlet" method="post" id="paymentForm">

                                <%-- 1. SAVED CARDS --%>
                            <c:if test="${not empty savedCards}">
                                <label class="form-label text-muted small fw-bold">SAVED CARDS</label>
                                <c:forEach var="card" items="${savedCards}">
                                    <div class="card-option d-flex align-items-center" onclick="selectCard(${card.id})">
                                        <input class="form-check-input me-3" type="radio" name="paymentMethod"
                                               id="card_${card.id}" value="${card.id}"
                                               onchange="toggleNewCardForm(false)">
                                        <div>
                                            <div class="fw-bold text-dark">${card.cardAlias}</div>
                                            <div class="text-muted small">Expires: ${card.expiry}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                                <%-- 2. NEW CARD OPTION --%>
                            <div class="card-option d-flex align-items-center mb-4" onclick="selectNewCard()">
                                <input class="form-check-input me-3" type="radio" name="paymentMethod"
                                       id="newCardRadio" value="new" checked
                                       onchange="toggleNewCardForm(true)">
                                <span class="fw-bold text-dark">+ Use a New Card</span>
                            </div>

                                <%-- 3. NEW CARD FORM --%>
                            <div id="newCardForm">
                                <div class="mb-3">
                                    <label class="form-label text-muted small fw-bold">CARD NUMBER</label>
                                    <input type="text" name="cardNumber" id="cardNumberInput" class="form-control" placeholder="0000 0000 0000 0000">
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small fw-bold">EXPIRY</label>
                                        <input type="text" name="expiry" id="expiryInput" class="form-control" placeholder="MM/YY">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small fw-bold">CVV</label>
                                        <input type="password" name="cvv" id="cvvInput" class="form-control" placeholder="123">
                                    </div>
                                </div>

                                <div class="form-check mb-4">
                                    <input class="form-check-input" type="checkbox" name="saveCard" id="saveCard" checked>
                                    <label class="form-check-label text-muted" for="saveCard">Save this card for future purchases</label>
                                </div>
                            </div>

                            <button type="submit" class="btn-pay">
                                Pay RM <fmt:formatNumber value="${totalAmount}" type="number" minFractionDigits="2"/>
                            </button>
                        </form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function toggleNewCardForm(show) {
        const form = document.getElementById('newCardForm');
        const inputs = form.querySelectorAll('input:not([type="checkbox"])');

        if (show) {
            form.style.display = 'block';
            inputs.forEach(i => i.required = true);
        } else {
            form.style.display = 'none';
            inputs.forEach(i => i.required = false);
        }
    }

    function selectCard(id) {
        document.getElementById('card_' + id).checked = true;
        toggleNewCardForm(false);
    }
    function selectNewCard() {
        document.getElementById('newCardRadio').checked = true;
        toggleNewCardForm(true);
    }
</script>

</body>
</html>