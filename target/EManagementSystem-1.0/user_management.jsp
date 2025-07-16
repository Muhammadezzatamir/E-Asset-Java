<%@ page import="java.sql.*, com.mycompany.utils.DBWrapper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>E-Asset System</title>
        <!-- Bootstrap CSS -->
        <link href="Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Custom CSS -->
        <link href="css/style.css" rel="stylesheet"/>
        <script src="js/script.js"></script>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <%@ include file="sidebar.jsp" %>

        <main class="content">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3 class="mb-0">Asset List</h3>
                <button type="button" class="btn btn-primary" id="modal_addasset">
                    <i class="bi bi-plus-circle me-1"></i> Add Asset
                </button>
            </div>
            <table id="contactsTable" class="display table table-striped" style="width:100%">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>IC No.</th>
                        <th>Email</th>
                        <th>Phone No</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String sql = "select ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num_row, first_name, last_name, nric, email, mobile_no from gl_user where is_deleted = 0 and role_id = '1'";
                        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(sql)) {

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("num_row")%></td>
                        <td><%= rs.getString("first_name")%></td>
                        <td><%= rs.getString("last_name")%></td>
                        <td><%= rs.getString("nric")%></td>
                        <td><%= rs.getString("email")%></td>
                        <td><%= rs.getString("mobile_no")%></td>
                        <td></td>
                    </tr>
                    <%
                        }
                    } catch (Exception e) {
                    %>
                    <tr><td colspan="8">Error: <%= e.getMessage()%></td></tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </main>


        <!-- Add Asset Modal -->
        <div class="modal fade" id="addAssetModal" tabindex="-1" aria-labelledby="addAssetModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form id="addAsset">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addAssetModalLabel">Add New Asset</h5>
                            <button type="button" class="btn-close" id="modal_close" aria-label="Close">X</button>
                        </div>
                        <div class="modal-body row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Username</label>
                                <input type="text" name="user_name" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Password</label>
                                <input type="password" name="password" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">First Name</label>
                                <input type="text" name="first_name" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Last Name</label>
                                <input type="text" name="last_name" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">NRIC</label>
                                <input type="text" name="nric" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Mobile No</label>
                                <input type="text" name="mobile_no" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Gender</label>
                                <select name="gender_id" class="form-control">
                                    <option value="">Select</option>
                                    <option value="1">Male</option>
                                    <option value="2">Female</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Race</label>
                                <select name="race_id" class="form-control">
                                    <option value="">Select</option>
                                    <option value="1">Malay</option>
                                    <option value="2">Chinese</option>
                                    <option value="3">Indian</option>
                                    <option value="4">Others</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Marital Status</label>
                                <input type="text" name="marital_status" class="form-control" />
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Add Asset</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Bootstrap JS bundle -->
        <script src="Bootstrap/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                $('#contactsTable').DataTable({
                    paging: true,
                    searching: true,
                    ordering: true
                });
            });

            document.addEventListener("DOMContentLoaded", function () {
    
                const openModalBtn = document.getElementById("modal_addasset");
                const closeModalBtn = document.getElementById("modal_close");
                const addAssetModalEl = document.getElementById("addAssetModal");
                if (!addAssetModalEl) {
                    console.error("Modal element #addAssetModal not found in DOM.");
                    return;
                }

                const addAssetModal = new bootstrap.Modal(addAssetModalEl);

                document.getElementById("modal_addasset").addEventListener("click", function () {
                    addAssetModal.show();
                });

                document.getElementById("modal_close").addEventListener("click", function () {
                    addAssetModal.hide();
                });
            });

            document.getElementById("addAsset").addEventListener("submit", function (e) {
                e.preventDefault();

                const formData = new FormData(this);
                const data = {};

                formData.forEach((value, key) => {
                    data[key] = value;
                });

                fetch('<%= request.getContextPath() %>/api/adduser', {
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
                    alert(response.message);
                    if(response.success) {
                        console.log("Success adding asset");
                        // ✅ Correct Bootstrap 4 jQuery modal hide
                        $('#addAssetModal').modal('hide');

                        this.reset();
                    }
                })
                .catch(err => {
                    console.error("Failed to add asset:", err);
                    alert("Failed to add asset");
                });
            });


        </script>
    </body>
</html>
