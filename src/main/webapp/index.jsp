<%@ page import="com.mycompany.emanagementsystem.servlet.AssetDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard - E-Asset System</title>
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
            <%
                if ("1".equals(roleId)) {
            %>
            <div class="row g-3">
                <!-- My Assigned Assets -->
                <%
                    String userId = (String) session.getAttribute("user_id");
                    int assetCount = AssetDAO.getAssignedAssetCount(userId);
                    int transCount = AssetDAO.getAssignedTransCount(userId);
                    int userCount = AssetDAO.getAssignedUserCount(userId);
                %>
                
                <div class="col-md-4">
                    <div class="card rounded-5">
                        <div class="card-body bg-primary text-white rounded-5">
                            <h5 class="card-title">Assets</h5>
                            <p class="card-text fs-2"><%= assetCount %></p>
                            <a href="asset.jsp" class="btn btn-light btn-sm">View My Assets</a>
                        </div>
                    </div>
                </div>

                <!-- Pending Requests -->
                <div class="col-md-4">
                    <div class="card rounded-5">
                        <div class="card-body bg-warning text-dark rounded-5">
                            <h5 class="card-title">Transaction</h5>
                            <p class="card-text fs-2"><%= transCount %></p>
                            <a href="transaction.jsp" class="btn btn-dark btn-sm">View Transaction</a>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Maintenance -->
                <div class="col-md-4">
                    <div class="card rounded-5">
                        <div class="card-body bg-success text-white rounded-5">
                            <h5 class="card-title">User</h5>
                            <p class="card-text fs-2"><%= userCount %></p>
                            <a href="users.jsp" class="btn btn-light btn-sm">View User</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity List -->
<!--            <div class="row mt-4">
                <div class="col-12">
                    <div class="card rounded-5">
                        <div class="card-body">
                            <h5 class="card-title">Recent Activity</h5>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">Requested Laptop for Project X - Pending</li>
                                <li class="list-group-item">Returned Projector on 2025-06-01</li>
                                <li class="list-group-item">Reported issue with Printer #12</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>-->

            <!-- Quick Actions -->
<!--            <div class="row mt-4">
                <div class="col-12 d-flex justify-content-start gap-3">
                    <a href="requestAsset.jsp" class="btn btn-primary rounded-5 px-4">Request Asset</a>
                    <a href="reportIssue.jsp" class="btn btn-danger rounded-5 px-4">Report Issue</a>
                    <a href="profile.jsp" class="btn btn-secondary rounded-5 px-4">View Profile</a>
                </div>
            </div>-->
            <%
                }
                else
                {
            %>
            <div class="row g-3">
                <!-- My Assigned Assets -->
                <%
                    String userId = (String) session.getAttribute("user_id");
                    int assetCount = AssetDAO.getAssignedAssetCount_USER(userId);
                    int transCount = AssetDAO.getAssignedTransCount_USER(userId);
                %>
                
                <div class="col-md-6">
                    <div class="card rounded-5">
                        <div class="card-body bg-primary text-white rounded-5">
                            <h5 class="card-title">Assets</h5>
                            <p class="card-text fs-2"><%= assetCount %></p>
                            <a href="asset.jsp" class="btn btn-light btn-sm">View My Assets</a>
                        </div>
                    </div>
                </div>

                <!-- Pending Requests -->
                <div class="col-md-6">
                    <div class="card rounded-5">
                        <div class="card-body bg-warning text-dark rounded-5">
                            <h5 class="card-title">Transaction</h5>
                            <p class="card-text fs-2"><%= transCount %></p>
                            <a href="transaction.jsp" class="btn btn-dark btn-sm">Manage Transactions</a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </main>


        <%@ include file="footer.jsp" %>

        <!-- Bootstrap JS bundle -->
        <script src="Bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
