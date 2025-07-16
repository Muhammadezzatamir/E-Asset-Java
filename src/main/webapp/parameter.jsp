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
                <h3 class="mb-0">Parameter List</h3>
                <button type="button" class="btn btn-primary" id="modal_addasset">
                    <i class="bi bi-plus-circle me-1"></i> Add Parameter
                </button>
            </div>
            <table id="contactsTable" class="display table table-striped" style="width:100%">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Code</th>
                        <th>Parent Code</th>
                        <th>Parameter Value</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String sql = "SELECT " +
                                    "ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num_row, " +
                                    "parameter_code, parameter_parent_code, parameter_value " +
                                    "FROM gl_parameter " +
                                    "WHERE is_deleted = 0";
                        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(sql)) {

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("num_row")%></td>
                        <td><%= rs.getString("parameter_code")%></td>
                        <td><%= rs.getString("parameter_parent_code")%></td>
                        <td><%= rs.getString("parameter_value")%></td>
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
                            <h5 class="modal-title" id="addAssetModalLabel">Add New Parameter</h5>
                            <button type="button" class="btn-close" id="modal_close" aria-label="Close">X</button>
                        </div>
                        <div class="modal-body row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Code</label>
                                <input type="text" class="form-control" name="parameter_code" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Parent</label>
                                <select name="parameter_type" id="categoryDropdown" class="form-control">
                                    <option value="">Select</option>
                                    <!-- Add options dynamically if needed -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Parent Code</label>
                                <select name="parameter_parent_code" id="brandDropdown" class="form-control">
                                    <option value="">Select</option>
                                    <!-- Add options dynamically if needed -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Parameter Name</label>
                                <input type="text" class="form-control" name="parameter_value" required />
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Add</button>
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
                
                const categoryDropdown = document.getElementById('categoryDropdown');
                const brandDropdown = document.getElementById('brandDropdown');

                // Load Category Dropdown
                fetch('<%=request.getContextPath()%>/api/addparametergroup')
                    .then(response => {
                        if (!response.ok) throw new Error("Network error");
                        return response.json();
                    })
                    .then(data => {
                        data.forEach(category => {
                            const option = document.createElement('option');
                            option.value = category.id;
                            option.textContent = category.name;
                            categoryDropdown.appendChild(option);
                        });
                    })
                    .catch(error => {
                        console.error('Error fetching category', error);
                        alert('Failed to load category list.');
                    });
                
                categoryDropdown.addEventListener('change', function () {
                    const selectedCategoryId = this.value;
                    console.log("Brand data:", selectedCategoryId);
                    brandDropdown.innerHTML = '<option value="">Select</option>';

                    if (selectedCategoryId) {
                        fetch("<%=request.getContextPath()%>/api/parameter?categoryId=" + selectedCategoryId + "")
                            .then(response => {
                                if (!response.ok) throw new Error("Network error");
                                return response.json();
                            })
                            .then(data => {
                                console.log("Parameter data:", data);
                                data.forEach(brand => {
                                    const option = document.createElement('option');
                                    option.value = brand.id;
                                    option.textContent = brand.name;
                                    brandDropdown.appendChild(option);
                                });
                            })
                            .catch(error => {
                                console.error('Error fetching parameter', error);
                                alert('Failed to load parameter list.');
                            });
                    }
                });
            });

            document.getElementById("addAsset").addEventListener("submit", function (e) {
                e.preventDefault();

                const formData = new FormData(this);
                const data = {};

                formData.forEach((value, key) => {
                    data[key] = value;
                });

                fetch('<%= request.getContextPath() %>/api/parameter', {
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