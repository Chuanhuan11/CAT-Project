<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Univent - Discover USM Life</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">

    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden; /* Prevent horizontal scroll */
        }

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

        /* --- DESKTOP HERO STYLES --- */
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
            padding-right: 10%;
            position: relative;
        }

        /* Hide the separate image on desktop because landing-bg.jpg already has it */
        .mobile-landing-img {
            display: none;
        }

        :root { --brand-purple: #2c1a4d; }

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
            bottom: 50px;
            left: 10%;
            color: var(--brand-purple);
            font-weight: 500;
            font-size: 0.9rem;
        }

        /* --- MOBILE LAYOUT OVERRIDES --- */
        @media (max-width: 768px) {
            .brand-header {
                left: 50%;
                transform: translateX(-50%); /* Center logo */
                top: 20px;
                width: max-content;
            }

            .brand-text {
                font-size: 1.5rem;
            }

            .hero-container {
                /* Switch to standard app background */
                background-image: url('${pageContext.request.contextPath}/assets/img/home-bg.jpg');
                background-attachment: fixed;
                padding-left: 5%;
                padding-right: 5%;
                padding-top: 80px; /* Space for logo */
                align-items: center;
                text-align: center;
                justify-content: flex-start; /* Start stacking from top */
                overflow-y: auto; /* Allow scrolling if image is tall */
            }

            .big-title {
                font-size: 3rem;
                line-height: 1.2;
                margin-top: 20px;
            }

            .subtitle {
                font-size: 1rem;
            }

            /* Show the specific image on mobile */
            .mobile-landing-img {
                display: block;
                width: 90%;
                max-width: 400px; /* Prevent it from getting too huge */
                height: auto;
                margin: 20px auto 30px auto;
                filter: drop-shadow(0 10px 15px rgba(0,0,0,0.1));
                /* Optional floating animation */
                animation: float 4s ease-in-out infinite;
            }

            .btn-explore {
                width: 80%; /* Wider button on mobile */
                padding: 15px 0;
                margin-top: 0;
                margin-bottom: 60px; /* Space above footer */
            }

            .footer-note {
                position: relative;
                bottom: auto;
                left: auto;
                margin-top: auto;
                margin-bottom: 20px;
                opacity: 0.8;
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

<div class="brand-header">
    <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" class="brand-logo">
    <span class="brand-text">Univent</span>
</div>

<div class="hero-container">
    <h1 class="big-title">Discover USM <br> Life</h1>
    <p class="subtitle">Concerts. Workshops. Sports. All in One Place.</p>

    <img src="${pageContext.request.contextPath}/assets/img/landing-img.png"
         alt="University Life 3D Illustration"
         class="mobile-landing-img">

    <a href="${pageContext.request.contextPath}/EventListServlet" class="btn-explore">
        Explore Events
    </a>

    <p class="footer-note">Join 10,000+ students booking tickets today.</p>
</div>

</body>
</html>