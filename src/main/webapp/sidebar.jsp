<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="sidebar" class="sidebar bg-dark text-white">
    <nav class="nav flex-column pt-3">
        <a href="index.jsp" class="nav-link text-white px-3">Dashboard</a>
        <a href="asset.jsp" class="nav-link text-white px-3">Assets</a>
        <a href="transaction.jsp" class="nav-link text-white px-3">Transaction</a>
        <%
            String roleId = (String) session.getAttribute("role_id");
            if ("1".equals(roleId)) {
        %>
            <a href="parameter.jsp" class="nav-link text-white px-3">Parameter</a>
            <a href="user_management.jsp" class="nav-link text-white px-3">User Management</a>
        <%
            }
        %>
    </nav>
</div>

