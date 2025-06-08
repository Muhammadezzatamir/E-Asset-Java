<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold fs-4" href="#">
            <i class="bi bi-gear-fill me-2"></i> <!-- Bootstrap Icons, optional -->
            E-Management System
        </a>

        <button id="sidebarToggle" class="btn btn-outline-light btn-sm me-2">
            <i class="bi bi-list"></i>
        </button>

        <div class="collapse navbar-collapse justify-content-end" id="navbarUserMenu">
            <ul class="navbar-nav align-items-center">
                <li class="nav-item col-7">
                    <span class="navbar-text text-white">
                        Welcome, <strong><%= session.getAttribute("fullname") != null ? session.getAttribute("fullname") : "User"%></strong>
                    </span>
                </li>

                <!-- Add inside .navbar-nav before Logout -->
                <li class="nav-item me-3">
                    <button id="themeToggle" class="btn btn-outline-light btn-sm px-3">
                        <i class="bi bi-moon"></i>
                    </button>
                </li>
                <li class="nav-item me-3">
                    <a href="profile.jsp" class="btn btn-outline-light btn-sm px-3" title="Update your profile">
                        <i class="bi bi-person-lines-fill me-1"></i>
                    </a>
                </li>
                <li class="nav-item  me-3">
                    <a href="login.jsp" class="btn btn-outline-light btn-sm px-3">
                        <i class="bi bi-box-arrow-right me-1"></i>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

