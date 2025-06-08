<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>E-Management System</title>
    <!-- Bootstrap CSS -->
    <link href="Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Custom CSS -->
    <link href="css/login-style.css" rel="stylesheet" />
    
    <!-- CDN Bootstrap (optional if using local) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Bootstrap Bundle JS (includes Carousel) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <header class="fixed-top d-flex justify-content-between align-items-center px-3">
        <h1 class="h4 m-0">E-Management System</h1>
        <button id="toggleModeBtn" class="btn btn-outline-primary btn-sm">Dark Mode</button>
    </header>

    <main class="container-fluid content-container d-flex flex-column justify-content-center align-items-center">
        <div id="carouselExampleIndicators" class="carousel slide mb-4" data-bs-ride="carousel" style="max-width:600px;">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
            </div>
            <div class="carousel-inner rounded shadow-sm">
                <div class="carousel-item active">
                    <img src="img/slide1.jpg" class="d-block w-100" alt="Welcome Slide" />
                </div>
                <div class="carousel-item">
                    <img src="img/slide2.jpg" class="d-block w-100" alt="Security Slide" />
                </div>
                <div class="carousel-item">
                    <img src="img/slide3.jpg" class="d-block w-100" alt="Join Slide" />
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>

        <div class="card shadow-sm p-4" style="min-width:320px; max-width:400px; width: 100%;">
            <h2 class="card-title mb-3 text-center">Login</h2>
            <form id="login">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" name="username" id="username" class="form-control" required autofocus />
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" name="password" id="password" class="form-control" required />
                </div>
                <button type="submit" class="btn btn-primary w-100">Login</button>
            </form>
            <div class="text-center mt-3">
                <small>Don't have an account? <a href="register.jsp">Register here</a></small>
            </div>
        </div>
    </main>

    <footer class="fixed-bottom d-flex justify-content-center align-items-center px-3">
        <small>&copy; 2025 MyApp. All rights reserved.</small>
    </footer>

    <!-- Bootstrap JS -->
    <script src="Bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="js/login-script.js"></script>
    
    <script>
        document.getElementById("login").addEventListener("submit", function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const data = {};
            
            formData.forEach((value, key) => {
                data[key] =value;
            });
            
            fetch('<%= request.getContextPath() %>/api/login', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(res => {
                if (!res.ok) throw new Error("Network response was not ok");
                return res.json();
            })
            .then(response => {
                if (response.success) {
                    window.location.href = "index.jsp";
                }
            })
            .catch(err => {
                console.error("Login failed:", err);
                alert("Login failed."); // not "Registration failed"
            });
        
        });
    </script>
</body>
</html>
