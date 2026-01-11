<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* --- ULTRA-MINIMAL FOOTER --- */
    .univent-footer {
        background-color: #2c1a4d; /* Brand Purple */
        color: rgba(255, 255, 255, 0.6); /* Slightly muted text */
        padding: 40px 0 25px 0;
        margin-top: 80px;
        text-align: center;
        box-shadow: 0 -5px 20px rgba(0,0,0,0.1);
        font-size: 0.9rem;
    }

    /* Brand Name Style */
    .footer-brand {
        color: white;
        font-weight: 800;
        font-size: 1.5rem;
        letter-spacing: 1px;
        text-transform: uppercase;
        margin-bottom: 15px;
        display: inline-block;
    }

    /* Navigation Links */
    .footer-nav {
        margin-bottom: 25px;
        display: flex;
        justify-content: center;
        gap: 30px; /* Generous spacing */
        flex-wrap: wrap;
    }

    .footer-link {
        color: rgba(255, 255, 255, 0.8);
        text-decoration: none;
        transition: color 0.2s ease;
    }

    .footer-link:hover {
        color: #ffcc00; /* Gold hover */
    }

    /* Highlight the "Contact" link subtly */
    .contact-link {
        color: #ffcc00;
        font-weight: 600;
        cursor: pointer;
    }
    .contact-link:hover {
        color: white;
        text-decoration: underline;
    }

    /* Copyright Text */
    .copyright {
        font-size: 0.75rem;
        opacity: 0.5;
        border-top: 1px solid rgba(255,255,255,0.1); /* Subtle separator */
        padding-top: 20px;
        margin-top: 10px;
        width: 80%;
        margin-left: auto;
        margin-right: auto;
    }

    /* --- MODAL STYLES (Unchanged) --- */
    .inquiry-modal-content {
        border-radius: 15px; border: none;
        box-shadow: 0 10px 40px rgba(0,0,0,0.4); text-align: left;
    }
    .inquiry-header {
        background-color: #2c1a4d; color: white;
        border-top-left-radius: 15px; border-top-right-radius: 15px; padding: 20px;
    }
    .form-control-soft {
        background-color: #f8f9fa; border: 1px solid #e9ecef;
        border-radius: 8px; padding: 12px;
    }
</style>

<footer class="univent-footer">
    <div class="container">

        <%-- 1. BRAND TEXT ONLY --%>
        <div class="footer-brand">Univent</div>

        <%-- 2. LINKS ROW --%>
        <div class="footer-nav">
            <a href="${pageContext.request.contextPath}/index.jsp" class="footer-link">Home</a>
            <a href="${pageContext.request.contextPath}/EventListServlet" class="footer-link">Catalog</a>

            <c:if test="${not empty sessionScope.username}">
                <a href="${pageContext.request.contextPath}/CartServlet" class="footer-link">My Cart</a>
            </c:if>

            <%-- Trigger Modal --%>
            <span class="footer-link contact-link" data-bs-toggle="modal" data-bs-target="#inquiryModal">
                Contact Support
            </span>
        </div>

        <%-- 3. COPYRIGHT --%>
        <div class="copyright">
            &copy; <%= new java.util.Date().getYear() + 1900 %> Univent.
            All rights reserved.
        </div>
    </div>
</footer>

<%-- --- HIDDEN INQUIRY MODAL --- --%>
<div class="modal fade" id="inquiryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content inquiry-modal-content">
            <div class="inquiry-header d-flex justify-content-between align-items-center">
                <h5 class="modal-title fw-bold">Contact Support</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form action="${pageContext.request.contextPath}/InquiryServlet" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small">YOUR NAME</label>
                        <input type="text" name="name" class="form-control form-control-soft"
                               value="${sessionScope.username != null ? sessionScope.username : ''}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small">EMAIL ADDRESS</label>
                        <input type="email" name="email" class="form-control form-control-soft" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small">HOW CAN WE HELP?</label>
                        <textarea name="message" class="form-control form-control-soft" rows="4" required></textarea>
                    </div>
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary fw-bold py-2" style="background-color: #2c1a4d; border:none;">
                            Send Message
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>