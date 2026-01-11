<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <title>Login - Univent</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <style>
        /* --- LAYOUT & CENTERING --- */
        html, body {
            height: 100%;
            margin: 0;
        }
        body {
            background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;

            /* Flexbox for Perfect Centering */
            display: flex;
            align-items: center;     /* Vertical Center */
            justify-content: center; /* Horizontal Center */
            flex-direction: column;  /* Stack items vertically */
        }

        /* --- CARD STYLES --- */
        .login-card {
            background-color: rgba(255, 255, 255, 0.95);
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
            width: 100%;
            max-width: 400px;
        }
        .login-header {
            background-color: #2c1a4d;
            color: white;
            padding: 30px 20px;
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

        /* --- FLOATING ALERT STYLES --- */
        .floating-alert {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            animation: slideInRight 0.5s ease-out;
        }
        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @media (max-width: 576px) {
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

<%-- 1. SUCCESS ALERT (From Registration) --%>
<c:if test="${param.success eq '1'}">
    <div class="alert alert-success alert-dismissible fade show floating-alert" role="alert">
        <strong>Success!</strong> Account created successfully.<br>Please log in.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<%-- 2. ERROR ALERT (From Login Failure) --%>
<c:if test="${not empty errorMessage}">
    <div class="alert alert-danger alert-dismissible fade show floating-alert" role="alert">
        <strong>Error:</strong> ${errorMessage}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<%-- HOME BUTTON --%>
<a href="${pageContext.request.contextPath}/index.jsp"
   class="btn btn-light position-absolute top-0 start-0 m-4 shadow-sm rounded-pill px-4 fw-bold"
   style="color: #2c1a4d; text-decoration: none;">
    &larr; Home
</a>

<%-- LOGIN FORM CONTAINER --%>
<div class="container d-flex justify-content-center">
    <div class="login-card">
        <div class="login-header">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" width="60" class="mb-3 rounded-circle border border-2 border-white">
            <h4 class="mb-0 fw-bold">Welcome Back</h4>
            <p class="mb-0 small opacity-75">Login to continue</p>
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">USERNAME</label>
                    <input type="text" name="username" class="form-control" required placeholder="Enter your username">
                </div>
                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold">PASSWORD</label>
                    <div class="input-group">
                        <%-- Added id="passwordInput" for JS targeting --%>
                        <input type="password" name="password" id="passwordInput" class="form-control" required placeholder="Enter your password" style="border-right: none;">

                        <%-- The Eye Button --%>
                        <button class="btn btn-white bg-white border border-start-0" type="button" id="togglePassword" style="border-color: #ced4da;">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#6c757d" class="bi bi-eye-fill" viewBox="0 0 16 16" id="eyeIcon">
                                <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                                <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                            </svg>
                        </button>
                    </div>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-brand btn-lg">Log In</button>
                </div>
            </form>
        </div>
        <div class="card-footer text-center bg-white py-3 border-0">
            <small class="text-muted">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/user/register.jsp" class="fw-bold" style="color: #2c1a4d;">Register Now</a>
            </small>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#passwordInput');
    const eyeIcon = document.querySelector('#eyeIcon');

    togglePassword.addEventListener('click', function (e) {
        // 1. Toggle the type attribute
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);

        // 2. Toggle the eye icon color/style (Optional visual feedback)
        if (type === 'text') {
            eyeIcon.style.fill = "#2c1a4d"; // Brand Purple when visible
        } else {
            eyeIcon.style.fill = "#6c757d"; // Gray when hidden
        }
    });
</script>
</body>
</html>