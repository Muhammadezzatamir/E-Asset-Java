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
                <%
                    if ("1".equals(roleId)) {
                %>
                <button type="button" class="btn btn-primary" id="modal_addasset">
                    <i class="bi bi-plus-circle me-1"></i> Add Asset
                </button>
                <%
                    }
                %>
            </div>
            
            <table id="contactsTable" class="display table table-striped" style="width:100%">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Code</th>
                        <th>Category</th>
                        <th>Brand</th>
                        <th>Model</th>
                        <th>Description</th>
                        <th>Quantity</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String sql = "select ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num_row, * from stock where is_deleted = 0";
                        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(sql)) {

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("num_row")%></td>
                        <td><%= rs.getString("stock_code")%></td>
                        <td><%= rs.getString("stock_category")%></td>
                        <td><%= rs.getString("stock_brand")%></td>
                        <td><%= rs.getString("stock_model")%></td>
                        <td><%= rs.getString("stock_desc")%></td>
                        <td><%= rs.getString("quantity")%></td>
                        <td>
                            <button class="btn btn-sm btn-warning me-1 edit-btn" data-id="<%= rs.getInt("stock_id") %>">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <button class="btn btn-sm btn-danger delete-btn" data-id="<%= rs.getInt("stock_id") %>">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>

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
                            <input type="hidden" name="stock_id" id="stock_id" />
                            <div class="col-md-6">
                                <label class="form-label">Code</label>
                                <input type="text" class="form-control" name="stock_code" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Category</label>
                                <select name="stock_category" id="categoryDropdown" class="form-control">
                                    <option value="">Select</option>
                                    <!-- Add options dynamically if needed -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Brand</label>
                                <select name="stock_brand" id="brandDropdown" class="form-control">
                                    <option value="">Select</option>
                                    <!-- Add options dynamically if needed -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Model</label>
                                <input type="text" class="form-control" name="stock_model" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="stock_desc" rows="4"></textarea>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Quantity</label>
                                <input type="number" class="form-control" name="quantity" required />
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

            let addAssetModal;
            
            document.addEventListener("DOMContentLoaded", function () {
    
                const openModalBtn = document.getElementById("modal_addasset");
                const closeModalBtn = document.getElementById("modal_close");
                addAssetModal = new bootstrap.Modal(document.getElementById("addAssetModal"));


                const categoryDropdown = document.getElementById('categoryDropdown');
                const brandDropdown = document.getElementById('brandDropdown');

                // Load Category Dropdown
                fetch('<%=request.getContextPath()%>/api/category')
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

                // Listen for category change

                categoryDropdown.addEventListener('change', function () {
                const selectedCategoryId = this.value;
                console.log("Brand data:", selectedCategoryId);
                brandDropdown.innerHTML = '<option value="">Select</option>';

                if (selectedCategoryId) {
                    fetch("<%=request.getContextPath()%>/api/brand?categoryId=" + selectedCategoryId + "")
                        .then(response => {
                            if (!response.ok) throw new Error("Network error");
                            return response.json();
                        })
                        .then(data => {
                            console.log("Brand data:", data);
                            data.forEach(brand => {
                                const option = document.createElement('option');
                                option.value = brand.id;
                                option.textContent = brand.name;
                                brandDropdown.appendChild(option);
                            });
                        })
                        .catch(error => {
                            console.error('Error fetching brands', error);
                            alert('Failed to load brand list.');
                        });
                    }
                });



                openModalBtn.addEventListener("click", function () {
                    addAssetModal.show();
                });
                closeModalBtn.addEventListener("click", function () {
                    addAssetModal.hide();
                });

                $('#contactsTable').DataTable({
                    paging: true,
                    searching: true,
                    ordering: true
                });
            });

            document.querySelectorAll(".edit-btn").forEach(button => {
                    button.addEventListener("click", function (e) {
                        const stockId = this.dataset.id;
                        console.log(stockId);
                        
                        fetch("getAssetById.jsp?id=" + stockId)
                            .then(res => res.json())
                            .then(data => {
                                document.getElementById("stock_id").value = stockId;
                                document.querySelector("input[name='stock_code']").value = data.stock_code;
                                document.querySelector("select[name='stock_category']").value = data.stock_category;
                                document.querySelector("select[name='stock_brand']").value = data.stock_brand;
                                document.querySelector("input[name='stock_model']").value = data.stock_model;
                                document.querySelector("textarea[name='stock_desc']").value = data.stock_desc;
                                document.querySelector("input[name='quantity']").value = data.quantity;

                                // Update modal title
                                document.getElementById("addAssetModalLabel").textContent = "Edit Asset";
                                document.querySelector("button[type='submit']").textContent = "Update Asset";
                                
                                addAssetModal.show();
                            })
                            .catch(err => console.error("Fetch failed", err));
                    });
                });

                const currentUserId = <%= session.getAttribute("user_id") %>; // pass user_id to JS

                document.querySelectorAll(".delete-btn").forEach(button => {
                    button.addEventListener("click", function () {
                        const stockId = this.getAttribute("data-id");
                        if (confirm("Are you sure you want to delete this stock?")) {
                            fetch("<%= request.getContextPath() %>/api/deletestock?id=" + stockId, {
                                method: 'DELETE',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify({
                                    stock_id: stockId,
                                    aud_add_userid: currentUserId
                                })
                            })
                            .then(res => {
                                if (!res.ok) throw new Error("Delete failed");
                                location.reload();
                            })
                            .catch(err => {
                                console.error("Delete error", err);
                                alert("Delete failed");
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

                const isEdit = data.stock_id && data.stock_id !== "";
                const endpoint = isEdit
                    ? '<%= request.getContextPath() %>/api/updateasset'
                    : '<%= request.getContextPath() %>/api/addasset';

                fetch(endpoint, {
                    method: 'POST', // or PUT
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
                    if (response.success) {
                        $('#addAssetModal').modal('hide');
                        this.reset();

                        // Reset to Add Mode
                        document.getElementById("addAssetModalLabel").textContent = "Add New Asset";
                        document.querySelector("button[type='submit']").textContent = "Add Asset";

                        location.reload(); // Optional: refresh table
                    }
                })
                .catch(err => {
                    console.error("Failed to save asset:", err);
                    alert("Failed to save asset");
                });
            });

//            document.getElementById("addAsset").addEventListener("submit", function (e) {
//                e.preventDefault();
//
//                const formData = new FormData(this);
//                const data = {};
//
//                formData.forEach((value, key) => {
//                    data[key] = value;
//                });
//
//                fetch('<%= request.getContextPath() %>/api/addasset', {
//                    method: 'POST',
//                    headers: {
//                        'Content-Type': 'application/json'
//                    },
//                    body: JSON.stringify(data)
//                })
//                .then(res => {
//                    if (!res.ok) throw new Error("Network response was not ok");
//                    return res.json();
//                })
//                .then(response => {
//                    alert(response.message);
//                    if(response.success) {
//                        console.log("Success adding asset");
//                        // ✅ Correct Bootstrap 4 jQuery modal hide
//                        $('#addAssetModal').modal('hide');
//
//                        this.reset();
//                    }
//                })
//                .catch(err => {
//                    console.error("Failed to add asset:", err);
//                    alert("Failed to add asset");
//                });
//            });

        </script>
    </body>
</html>
