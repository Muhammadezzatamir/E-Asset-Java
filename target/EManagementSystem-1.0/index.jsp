<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard - E-Management System</title>
        <!-- Bootstrap CSS -->
        <link href="Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
        <script src="Bootstrap/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Custom CSS -->
        <link href="css/style.css" rel="stylesheet"/>
        <script src="js/script.js"></script>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <%@ include file="sidebar.jsp" %>

        <main class="content">
            <div class="row">
                <div class="col-md-3">
                    <div class="card  rounded-5">
                        <div class="card-body bg-primary rounded-5">
                            <h5 class="card-title">Card Title</h5>
                            <p class="card-text">This is some example text inside the card body.</p>
                            <a href="#" class="btn btn-primary">Go somewhere</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card  rounded-5">
                        <div class="card-body bg-primary rounded-5">
                            <h5 class="card-title">Card Title</h5>
                            <p class="card-text">This is some example text inside the card body.</p>
                            <a href="#" class="btn btn-primary">Go somewhere</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card  rounded-5">
                        <div class="card-body bg-primary rounded-5">
                            <h5 class="card-title">Card Title</h5>
                            <p class="card-text">This is some example text inside the card body.</p>
                            <a href="#" class="btn btn-primary">Go somewhere</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card  rounded-5">
                        <div class="card-body bg-primary rounded-5">
                            <h5 class="card-title">Card Title</h5>
                            <p class="card-text">This is some example text inside the card body.</p>
                            <a href="#" class="btn btn-primary">Go somewhere</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="footer.jsp" %>

        <!-- Bootstrap JS bundle -->
        <script src="Bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
