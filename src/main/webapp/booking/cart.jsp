<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>

<head>
    <title>Shopping Cart - Univent</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9f9f9;
            padding: 20px;
            margin: 0;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th,
        td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #ecf0f1;
            color: #2c3e50;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            font-size: 14px;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-primary {
            background-color: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }

        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #7f8c8d;
        }

        .btn-danger {
            background-color: #e74c3c;
            color: white;
            padding: 5px 10px;
            font-size: 12px;
        }

        .btn-danger:hover {
            background-color: #c0392b;
        }

        .total {
            font-size: 1.2em;
            font-weight: bold;
            text-align: right;
            margin-top: 10px;
        }

        .actions {
            text-align: right;
            margin-top: 20px;
        }

        .message {
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .empty-cart {
            text-align: center;
            margin: 40px 0;
            color: #7f8c8d;
        }
    </style>
</head>

<body>
<div class="container">
    <h1>Your Shopping Cart</h1>

    <c:if test="${not empty param.error}">
        <div class="message error">
            <c:choose>
                <c:when test="${param.error == 'Missing Event ID'}">Error: Event ID is missing.</c:when>
                <c:when test="${param.error == 'Invalid Event ID'}">Error: Invalid Event ID.</c:when>
                <c:when test="${param.error == 'Event Not Found'}">Error: Event not found.</c:when>
                <c:otherwise>An unknown error occurred.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${empty sessionScope.cart}">
        <div class="empty-cart">
            <p>Your cart is empty.</p>
            <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-primary">Browse
                Events</a>
        </div>
    </c:if>

    <c:if test="${not empty sessionScope.cart}">
        <table>
            <thead>
            <tr>
                <th>Event</th>
                <th>Date</th>
                <th>Location</th>
                <th>Price</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:set var="total" value="0" />
            <c:forEach var="item" items="${sessionScope.cart}">
                <tr>
                    <td>${item.title}</td>
                    <td>${item.eventDate}</td>
                    <td>${item.location}</td>
                    <td>RM${item.price}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/CartServlet?action=remove&eventId=${item.id}"
                           class="btn btn-danger">Remove</a>
                    </td>
                </tr>
                <c:set var="total" value="${total + item.price}" />
            </c:forEach>
            </tbody>
        </table>

        <div class="total">
            Total: RM
            <c:out value="${total}" />
        </div>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/EventListServlet" class="btn btn-secondary">Continue
                Shopping</a>
            <a href="${pageContext.request.contextPath}/CheckoutServlet" class="btn btn-primary">Proceed to Checkout</a>
        </div>
    </c:if>
</div>
</body>

</html>