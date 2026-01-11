<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Univent - Discover USM Life</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">

    <style>
        /* --- GLOBAL STYLES --- */
        body, html {
            /* REMOVED height: 100% to prevent scroll locking issues */
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
            background-color: #f4f4f4; /* Fallback color */
        }

        :root { --brand-purple: #2c1a4d; }

        /* --- HERO CONTAINER --- */
        .hero-container {
            background-image: url('${pageContext.request.contextPath}/assets/img/landing-bg.jpg');

            /* FIX 1: Use min-height: 100vh.
               This guarantees it covers the full viewport, but allows
               content to expand if needed without breaking layout. */
            min-height: 100vh;
            width: 100%;

            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;

            /* Flexbox to vertically center the content */
            display: flex;
            flex-direction: column;
            justify-content: center; /* Centers content vertically */

            text-align: left;
            padding: 80px 10%; /* Added top padding so header doesn't overlap */
            position: relative;
        }

        /* --- BRAND HEADER --- */
        .brand-header {
            position: absolute;
            top: 30px;
            left: 10%;
            display: flex;
            align-items: center;
            z-index: 10;
        }

        .brand-logo {
            height: 50px;
            margin-right: 15px;
            border-radius: 50%;
        }

        .brand-text {
            font-size: 2rem;
            font-weight: 800;
            color: #2c1a4d;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* --- CONTENT STYLES --- */
        .mobile-landing-img { display: none; }

        .big-title {
            font-size: 5rem;
            font-weight: 800;
            color: #2c1a4d;
            line-height: 1.1;
            margin-bottom: 1.5rem;
        }

        .subtitle {
            font-size: 1.25rem;
            color: var(--brand-purple);
            font-weight: 600;
            margin-bottom: 1rem;
            letter-spacing: 0.5px;
            max-width: 600px;
        }

        /* --- CTA BUTTON --- */
        .btn-explore {
            background-color: white;
            color: var(--brand-purple);
            font-size: 1.2rem;
            font-weight: 800;
            text-transform: uppercase;
            padding: 18px 50px;
            border-radius: 50px;
            border: none;
            text-decoration: none;
            box-shadow: 0 10px 20px rgba(44, 26, 77, 0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-top: 20px;
            display: inline-block;
        }

        .btn-explore:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(44, 26, 77, 0.25);
            color: var(--brand-purple);
        }

        .footer-note {
            position: absolute;
            bottom: 30px;
            left: 10%;
            color: var(--brand-purple);
            font-weight: 500;
            font-size: 0.9rem;
        }

        /* --- MOBILE LAYOUT OVERRIDES --- */
        @media (max-width: 768px) {
            .hero-container {
                background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');

                /* FIX 2: 'scroll' prevents jumpy background on iPhone */
                background-attachment: scroll;

                padding: 100px 5% 40px 5%; /* More top padding for mobile */
                text-align: center;
                align-items: center;

                /* On mobile, we let the content stack naturally */
                justify-content: flex-start;
            }

            .brand-header {
                position: absolute;
                top: 30px;
                left: 0;
                width: 100%;
                justify-content: center;
            }

            .brand-text { font-size: 1.5rem; }

            .big-title {
                font-size: 3rem;
                line-height: 1.2;
                margin-top: 20px;
            }

            .subtitle { font-size: 1rem; }

            .mobile-landing-img {
                display: block;
                width: 90%;
                max-width: 350px;
                height: auto;
                margin: 20px auto 30px auto;
                filter: drop-shadow(0 10px 15px rgba(0,0,0,0.1));
                animation: float 4s ease-in-out infinite;
            }

            .btn-explore {
                width: 80%;
                padding: 15px 0;
                margin-bottom: 20px;
            }

            .footer-note {
                position: relative;
                bottom: auto;
                left: auto;
                margin-top: 20px;
                opacity: 0.8;
                font-size: 0.8rem;
                padding-bottom: 10px;
            }
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }
    </style>
</head>
<body>

<%-- --- HERO CONTAINER --- --%>
<div class="hero-container">

    <%-- BRAND HEADER --%>
    <div class="brand-header">
        <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" class="brand-logo">
        <span class="brand-text">Univent</span>
    </div>

    <%-- MAIN CONTENT --%>
    <div>
        <h1 class="big-title">Discover USM <br> Life</h1>
        <p class="subtitle">Concerts. Workshops. Sports. All in One Place.</p>

        <%-- MOBILE ILLUSTRATION --%>
        <img src="${pageContext.request.contextPath}/assets/img/landing-img.png"
             alt="University Life 3D Illustration"
             class="mobile-landing-img">

        <%-- CALL TO ACTION --%>
        <a href="${pageContext.request.contextPath}/EventListServlet" class="btn-explore">
            Explore Events
        </a>
    </div>

    <%-- FOOTER NOTE (Optional: Keep if you like the "Join 10,000" text) --%>
    <p class="footer-note">Join 10,000+ students booking tickets today.</p>
</div>

<%-- --- STANDARD FOOTER (Appears below the hero when scrolling) --- --%>
<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>