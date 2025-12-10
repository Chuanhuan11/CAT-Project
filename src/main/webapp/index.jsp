<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Univent - USM Student Marketplace</title>
        <link rel="stylesheet" href="css/style_user.css">
    </head>

    <body>
        <nav class="navbar">
            <a href="#" class="logo"><img src="assets/img/logo.png" alt="Univent" style="height: 40px;"></a>
            <div class="nav-links">
                <a href="login" class="btn-secondary">Login</a>
                <a href="user/register.jsp" class="btn-primary">Get Started</a>
            </div>
        </nav>

        <section class="hero">
            <h1>Buy, Sell & Connect at USM</h1>
            <p>The exclusive marketplace for Universiti Sains Malaysia students. Trade textbooks, electronics, and find
                campus events easily.</p>
            <div style="display: flex; gap: 1rem; justify-content: center;">
                <a href="user/register.jsp" class="btn-primary"
                    style="background: var(--white); color: var(--primary-color);">Join Now</a>
                <a href="#features" class="btn-secondary" style="border-color: var(--white); color: var(--white);">Learn
                    More</a>
            </div>
        </section>

        <section id="features" class="features">
            <div class="feature-card">
                <div class="feature-icon">📚</div>
                <h3>Academic Trading</h3>
                <p>Buy and sell second-hand textbooks, notes, and lab equipment at student-friendly prices.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📅</div>
                <h3>Campus Events</h3>
                <p>Discover and register for club activities, workshops, and university programs in one place.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <h3>Secure Community</h3>
                <p>Verified USM student community ensures a safer and more reliable trading environment.</p>
            </div>
        </section>

        <footer style="text-align: center; padding: 2rem; color: #666; font-size: 0.9rem;">
            <p>&copy; 2025 Univent USM. All rights reserved.</p>
        </footer>
    </body>

    </html>