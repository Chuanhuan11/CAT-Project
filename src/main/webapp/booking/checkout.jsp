<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>

<head>
    <title>Checkout - Univent</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
            margin: 0;
        }

        .container {
            max-width: 500px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 25px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #34495e;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }

        input:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }

        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn:hover {
            background-color: #2ecc71;
        }

        .message {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #3498db;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
<div class="container">
    <h2>Checkout</h2>

    <c:if test="${not empty message}">
        <div class="message success">
                ${message}
        </div>
        <p style="text-align: center;">Thank you for your purchase!</p>
        <a href="${pageContext.request.contextPath}/EventListServlet" class="btn"
           style="background-color: #3498db; text-align: center; text-decoration: none;">Back to Events</a>
    </c:if>

    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>

    <c:if test="${empty message}">
        <form action="${pageContext.request.contextPath}/CheckoutServlet" method="post">
            <div class="form-group">
                <label for="cardName">Name on Card</label>
                <input type="text" id="cardName" name="cardName" required placeholder="John Doe">
            </div>
            <div class="form-group">
                <label for="cardNumber">Card Number</label>
                <input type="text" id="cardNumber" name="cardNumber" required placeholder="XXXX-XXXX-XXXX-XXXX">
            </div>
            <div class="form-group">
                <label for="expiry">Expiry Date</label>
                <input type="text" id="expiry" name="expiry" required placeholder="MM/YY">
            </div>
            <div class="form-group">
                <label for="cvv">CVV</label>
                <input type="number" id="cvv" name="cvv" required placeholder="123">
            </div>

            <button type="submit" class="btn">Pay Now</button>
        </form>

        <a href="${pageContext.request.contextPath}/booking/cart.jsp" class="back-link">Back to Cart</a>
    </c:if>
</div>
</body>

</html>