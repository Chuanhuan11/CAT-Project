<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_user.css">
</head>

<body>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Univent"
             style="height: 80px; width: auto;">
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/user/register.jsp" class="btn-secondary">Sign Up</a>
    </div>
</nav>

<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Welcome Back</h2>
            <p>Login to discover events</p>
        </div>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="student@usm.my" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>


            <% if ("success".equals(request.getParameter("registration"))) { %>
            <div class="success-message"
                 style="color: green; text-align: center; margin-bottom: 1rem; padding: 10px; background-color: #d4edda; border-radius: 5px;">
                Registration successful! Please login.
            </div>
            <% } %>

            <div class="error-message" style="color: red; text-align: center; margin-bottom: 1rem;">
                ${errorMessage}
            </div>

            <button type="submit" class="btn-primary" style="width: 100%; margin-top: 1rem;">Login</button>
        </form>

        <div class="auth-footer">
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/user/register.jsp">Sign up</a></p>
            <p style="margin-top: 0.5rem;"><a href="#" style="font-size: 0.85rem; color: #888;">Forgot Password?</a></p>
        </div>
    </div>
</div>
</body>

</html>