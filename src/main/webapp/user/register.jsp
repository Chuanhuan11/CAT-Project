<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_user.css">
</head>

<body>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Univent" style="height: 80px;">
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="login.jsp" class="btn-secondary">Login</a>
    </div>
</nav>

<div class="auth-container">
    <div class="auth-card">
        <div class="auth-header">
            <h2>Create Account</h2>
            <p>Join the Univent community</p>
        </div>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="fullname">Full Name</label>
                <input type="text" id="fullname" name="fullname" class="form-control" placeholder="John Doe" required>
            </div>

            <div class="form-group">
                <label for="email">USM Email</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="student@student.usm.my"
                       required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <div class="form-group">
                <label for="confirm_password">Confirm Password</label>
                <input type="password" id="confirm_password" name="confirm_password" class="form-control"
                       placeholder="••••••••" required>
            </div>

            <div class="form-group" style="display: flex; align-items: center; gap: 0.5rem;">
                <input type="checkbox" id="terms" name="terms" required style="width: auto;">
                <label for="terms" style="margin: 0; font-weight: normal; font-size: 0.85rem;">
                    I agree to the <a href="${pageContext.request.contextPath}/rules.jsp" target="_blank"
                                      style="color: var(--primary-color);">Rules & Regulations</a>
                </label>
            </div>

            <button type="submit" class="btn-primary" style="width: 100%; margin-top: 1rem;">Sign Up</button>
        </form>

        <div class="auth-footer">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/user/login.jsp">Login</a></p>
        </div>
    </div>
</div>
</body>

</html>