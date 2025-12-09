<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h2>Welcome Back</h2>
                    <p>Login to discover events</p>
                </div>

                <form action="login" method="post">
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="student@usm.my"
                            required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••"
                            required>
                    </div>

                    <button type="submit" class="btn-primary" style="width: 100%; margin-top: 1rem;">Login</button>
                </form>

                <div class="auth-footer">
                    <p>Don't have an account? <a href="register.jsp">Sign up</a></p>
                    <p style="margin-top: 0.5rem;"><a href="#" style="font-size: 0.85rem; color: #888;">Forgot
                            Password?</a></p>
                </div>
            </div>
        </div>
        </body>

    </html>