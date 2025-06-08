<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top shadow-sm">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold fs-4" href="#">
      <i class="bi bi-gear-fill me-2"></i> <!-- Bootstrap Icons, optional -->
      E-Management System
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarUserMenu" aria-controls="navbarUserMenu" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-end" id="navbarUserMenu">
      <ul class="navbar-nav align-items-center">
        <li class="nav-item me-3">
          <span class="navbar-text text-white">
            Welcome, <strong><%= session.getAttribute("fullname") != null ? session.getAttribute("fullname") : "User" %></strong>
          </span>
        </li>
        <li class="nav-item">
          <a href="logout.jsp" class="btn btn-outline-light btn-sm px-3">
            <i class="bi bi-box-arrow-right me-1"></i> Logout
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>

