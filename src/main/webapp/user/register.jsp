<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Register - Univent</title>
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
        }

        .register-card {
            background-color: rgba(255, 255, 255, 0.95);
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .register-header {
            background-color: #2c1a4d;
            color: white;
            padding: 20px;
            text-align: center;
        }

        .btn-brand {
            background-color: #2c1a4d;
            color: white;
            font-weight: bold;
            transition: all 0.3s;
        }
        .btn-brand:hover {
            background-color: #4a2c82;
            color: white;
        }
    </style>
</head>
<body>

<a href="${pageContext.request.contextPath}/index.jsp"
   class="btn btn-light position-absolute top-0 start-0 m-4 shadow-sm rounded-pill px-4 fw-bold"
   style="color: #2c1a4d; text-decoration: none;">
    &larr; Home
</a>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card register-card">
                <div class="register-header">
                    <h4 class="mb-0">Create Account</h4>
                    <p class="mb-0 small opacity-75">Join the Univent community</p>
                </div>
                <div class="card-body p-4">

                    <%-- Show Error Message if Registration Fails --%>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger text-center small p-2">
                                ${errorMessage}
                        </div>
                    </c:if>

                    <%-- FIX 1: Action updated to "/register" to match @WebServlet("/register") --%>
                    <form action="${pageContext.request.contextPath}/register" method="post">

                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">FULL NAME</label>
                            <%-- FIX 2: Name updated to "fullname" to match request.getParameter("fullname") --%>
                            <input type="text" name="fullname" class="form-control" required placeholder="John Doe">
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">USM EMAIL</label>
                            <input type="email" name="email" class="form-control" required placeholder="student@student.usm.my">
                            <div class="form-text small">Must be a valid USM email ending in .usm.my</div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold">PASSWORD</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold">CONFIRM</label>
                                <%-- FIX 3: Name updated to "confirm_password" to match backend --%>
                                <input type="password" name="confirm_password" class="form-control" required>
                            </div>
                        </div>

                        <%-- Terms Checkbox (Optional visual, as Servlet doesn't check it yet, but good for UI) --%>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="terms" required>
                            <label class="form-check-label small" for="terms">
                                I agree to the <a href="#" style="color: #2c1a4d;">Rules & Regulations</a>
                            </label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-brand btn-lg">Sign Up</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center bg-white py-3 border-0">
                    <small class="text-muted">
                        Already have an account?
                        <a href="login.jsp" class="fw-bold" style="color: #2c1a4d;">Log In</a>
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>