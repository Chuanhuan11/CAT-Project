<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Univent - Discover USM Life</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">

    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* --- NEW BRAND HEADER (Top Left) --- */
        .brand-header {
            position: absolute;
            top: 30px;
            left: 10%; /* Aligns with the main text padding */
            display: flex;
            align-items: center;
            z-index: 10; /* Ensures it sits on top of background */
        }

        .brand-logo {
            height: 50px;
            margin-right: 15px;
            border-radius: 50%; /* <--- THIS MAKES IT ROUND */
        }

        .brand-text {
            font-size: 2rem;
            font-weight: 800;
            color: #2c1a4d; /* Matches your brand purple */
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* --- HERO SECTION --- */
        .hero-container {
            background-image: url('${pageContext.request.contextPath}/assets/img/landing-bg.jpg');
            height: 100%;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;

            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
            text-align: left;
            padding-left: 10%;
        }

        :root { --brand-purple: #2c1a4d; }

        .big-title {
            font-size: 5rem;
            font-weight: 800;
            color: var(--brand-purple);
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
            margin-top: 30px;
        }

        .btn-explore:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(44, 26, 77, 0.25);
            color: var(--brand-purple);
        }

        .footer-note {
            position: absolute;
            bottom: 50px;
            left: 10%;
            color: var(--brand-purple);
            font-weight: 500;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="brand-header">
    <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" class="brand-logo">
    <span class="brand-text">Univent</span>
</div>

<div class="hero-container">
    <h1 class="big-title">Discover USM <br> Life</h1>
    <p class="subtitle">Concerts. Workshops. Sports. All in One Place.</p>

    <a href="${pageContext.request.contextPath}/EventListServlet" class="btn-explore">
        Explore Events
    </a>

    <p class="footer-note">Join 10,000+ students booking tickets today.</p>
</div>

</body>
</html>