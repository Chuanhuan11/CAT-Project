<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
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
        /* Removes default browser validation outlines to use Bootstrap's */
        input:focus { box-shadow: none !important; }

        /* === FIX: Dynamic Border Color for Eye Icon Button === */
        /* When input is valid (green), make the button border green */
        .input-group .form-control.is-valid + .btn {
            border-color: #198754 !important; /* Bootstrap green */
        }
        /* When input is invalid (red), make the button border red */
        .input-group .form-control.is-invalid + .btn {
            border-color: #dc3545 !important; /* Bootstrap red */
        }
        /* Ensure the default border color is overridden when not valid/invalid */
        .input-group .form-control:not(.is-valid):not(.is-invalid) + .btn {
            border-color: #ced4da;
        }
        /* ==================================================== */
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

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger text-center small p-2">
                                ${errorMessage}
                        </div>
                    </c:if>

                    <%-- Added 'novalidate' to disable default browser popups --%>
                    <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm" novalidate>

                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">FULL NAME</label>
                            <%-- FIX: Added maxlength="50" to prevent DB truncation error --%>
                            <input type="text" name="fullname" id="fullname" class="form-control"
                                   required minlength="3" maxlength="50" placeholder="John Doe">
                            <div class="invalid-feedback">Name must be 3-50 characters.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">USM EMAIL</label>
                            <input type="email" name="email" id="email" class="form-control" required
                                   placeholder="student@student.usm.my">
                            <div class="invalid-feedback">Must be a valid USM email (.usm.my).</div>
                            <div class="form-text small" id="emailHelp">Must end in .usm.my</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">ACCOUNT TYPE</label>
                            <select name="accountType" class="form-select" required>
                                <option value="STUDENT" selected>Student (Participant)</option>
                                <option value="ORGANIZER">Event Organizer</option>
                            </select>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold">PASSWORD</label>
                                <div class="input-group">
                                    <input type="password" name="password" id="password" class="form-control" required minlength="6" placeholder="Min 6 chars" style="border-right: none;">
                                    <%-- Removed inline style for border-color to allow CSS to override --%>
                                    <button class="btn btn-white bg-white border border-start-0" type="button" id="togglePassword">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#6c757d" class="bi bi-eye-fill" viewBox="0 0 16 16" id="eyeIconPass">
                                            <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                                            <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                                        </svg>
                                    </button>
                                    <div class="invalid-feedback">At least 6 chars.</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold">CONFIRM</label>
                                <div class="input-group">
                                    <input type="password" name="confirm_password" id="confirm_password" class="form-control" required placeholder="Repeat" style="border-right: none;">
                                    <%-- Removed inline style for border-color to allow CSS to override --%>
                                    <button class="btn btn-white bg-white border border-start-0" type="button" id="toggleConfirm">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#6c757d" class="bi bi-eye-fill" viewBox="0 0 16 16" id="eyeIconConf">
                                            <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                                            <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                                        </svg>
                                    </button>
                                    <div class="invalid-feedback">Passwords don't match.</div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="terms" required>
                            <label class="form-check-label small" for="terms">
                                <%-- FIX: Corrected path to rules.jsp (added /user/) --%>
                                I agree to the <a href="${pageContext.request.contextPath}/user/rules.jsp" target="_blank" style="color: #2c1a4d; font-weight: bold;">Rules & Regulations</a>
                            </label>
                            <div class="invalid-feedback">You must agree before proceeding.</div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" id="submitBtn" class="btn btn-brand btn-lg" disabled>Sign Up</button>
                        </div>
                    </form>
                </div>
                <div class="card-footer text-center bg-white py-3 border-0">
                    <small class="text-muted">
                        Already have an account?
                        <a href="${pageContext.request.contextPath}/user/login.jsp" class="fw-bold" style="color: #2c1a4d;">Log In</a>
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Elements
        const form = document.getElementById('registerForm');
        const submitBtn = document.getElementById('submitBtn');

        const fullname = document.getElementById('fullname');
        const email = document.getElementById('email');
        const password = document.getElementById('password');
        const confirmPass = document.getElementById('confirm_password');
        const terms = document.getElementById('terms');

        // Regex for USM Email
        const emailPattern = /.+@.+\.usm\.my$/;

        // 1. DYNAMIC VALIDATION FUNCTION
        function validateInput(input, condition) {
            if (condition) {
                input.classList.remove('is-invalid');
                input.classList.add('is-valid');
                return true;
            } else {
                input.classList.remove('is-valid');
                input.classList.add('is-invalid');
                return false;
            }
        }

        // 2. CHECK ALL FIELDS & ENABLE BUTTON
        function checkFormValidity() {
            const isNameValid = fullname.value.length >= 3 && fullname.value.length <= 50;
            const isEmailValid = emailPattern.test(email.value);
            const isPassValid = password.value.length >= 6;
            const isMatch = (password.value === confirmPass.value) && isPassValid;
            const isTermsChecked = terms.checked;

            if (isNameValid && isEmailValid && isPassValid && isMatch && isTermsChecked) {
                submitBtn.disabled = false;
            } else {
                submitBtn.disabled = true;
            }
        }

        // 3. EVENT LISTENERS (Real-time checks)
        fullname.addEventListener('input', function() {
            validateInput(this, this.value.length >= 3 && this.value.length <= 50);
            checkFormValidity();
        });

        email.addEventListener('input', function() {
            // Hide the helper text if invalid to show error message cleanly
            const helper = document.getElementById('emailHelp');
            const isValid = emailPattern.test(this.value);
            validateInput(this, isValid);
            if(!isValid && this.value.length > 0) helper.style.display = 'none';
            else helper.style.display = 'block';
            checkFormValidity();
        });

        password.addEventListener('input', function() {
            validateInput(this, this.value.length >= 6);
            // Re-check confirmation whenever password changes
            if (confirmPass.value.length > 0) {
                validateInput(confirmPass, confirmPass.value === this.value);
            }
            checkFormValidity();
        });

        confirmPass.addEventListener('input', function() {
            validateInput(this, this.value === password.value);
            checkFormValidity();
        });

        terms.addEventListener('change', function() {
            validateInput(this, this.checked);
            checkFormValidity();
        });

        // 4. PASSWORD VISIBILITY TOGGLE (Your previous code)
        function setupToggle(buttonId, inputId, iconId) {
            const toggleBtn = document.getElementById(buttonId);
            const inputField = document.getElementById(inputId);
            const icon = document.getElementById(iconId);

            if(toggleBtn && inputField && icon) {
                toggleBtn.addEventListener('click', function () {
                    const type = inputField.getAttribute('type') === 'password' ? 'text' : 'password';
                    inputField.setAttribute('type', type);
                    icon.style.fill = (type === 'text') ? "#2c1a4d" : "#6c757d";
                });
            }
        }
        setupToggle('togglePassword', 'password', 'eyeIconPass');
        setupToggle('toggleConfirm', 'confirm_password', 'eyeIconConf');
    });
</script>
</body>
</html>