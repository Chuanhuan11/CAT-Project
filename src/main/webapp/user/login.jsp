<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Login - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        /* Matches your Catalog 'home.jsp' background style */
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

        /* Glass-morphism Card Style */
        .login-card {
            background-color: rgba(255, 255, 255, 0.95);
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .login-header {
            background-color: #2c1a4d; /* Brand Purple */
            color: white;
            padding: 25px;
            text-align: center;
        }

        .btn-brand {
            background-color: #2c1a4d;
            color: white;
            font-weight: bold;
            transition: all 0.3s;
        }

        .btn-brand:hover {
            background-color: #4a2c82; /* Lighter purple on hover */
            color: white;
        }

        .form-control:focus {
            border-color: #2c1a4d;
            box-shadow: 0 0 0 0.25rem rgba(44, 26, 77, 0.25);
        }
    </style>
</head>
<body>

<a href="${pageContext.request.contextPath}/index.jsp"
   class="btn btn-light position-absolute top-0 start-0 m-4 shadow-sm rounded-pill px-4 fw-bold"
   style="color: #2c1a4d; text-decoration: none;">
    &larr; Back to Home
</a>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card login-card">
                <div class="login-header">
                    <img src="${pageContext.request.contextPath}/assets/img/logo.png"
                         alt="Univent" width="60" class="rounded-circle mb-2 shadow-sm">
                    <h4 class="mb-0">Welcome Back</h4>
                </div>
                <div class="card-body p-4">

                    <%-- Error Message Alert --%>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger text-center p-2 small">
                                ${errorMessage}
                        </div>
                    </c:if>

                    <%-- Login form: sends data to LoginServlet --%>
                    <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                        <div class="mb-3">
                            <label class="form-label text-muted fw-bold" style="font-size: 1.0rem;">USERNAME</label>
                            <input type="text" name="username" class="form-control" required placeholder="Enter username"
                                   style="font-size: 1.2rem;">
                        </div>

                        <div class="mb-4">
                            <label class="form-label text-muted fw-bold" style="font-size: 1.0rem;">PASSWORD</label>
                            <input type="password" name="password" class="form-control" required
                                   placeholder="Enter password" style="font-size: 1.2rem;">
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-brand btn-lg">Log In</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center bg-white py-3 border-0">
                    <small class="text-muted">
                        Don't have an account?
                        <a href="register.jsp" class="fw-bold" style="color: #2c1a4d;">Register here</a>
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>