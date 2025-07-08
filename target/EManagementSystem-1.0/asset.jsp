<%@ page import="java.sql.*, com.mycompany.utils.DBWrapper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Dashboard - E-Asset System</title>
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
                        <th>Category</th>
                        <th>Brand</th>
                        <th>Model</th>
                        <th>Quantity</th>
                        <th>Used</th>
                        <th>Damage</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String sql = "select * from stock";
                        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(sql)) {

                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("stock_id")%></td>
                        <td><%= rs.getString("stock_code")%></td>
                        <td><%= rs.getString("stock_brand")%></td>
                        <td><%= rs.getString("stock_model")%></td>
                        <td><%= rs.getString("stock_desc")%></td>
                        <td><%= rs.getString("stock_desc")%></td>
                        <td><%= rs.getString("stock_desc")%></td>
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
                                <label class="form-label">Code</label>
                                <input type="text" class="form-control" name="category" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Category</label>
                                <select name="category" id="categoryDropdown" class="form-control">
                                    <option value="">Select</option>
                                    <!-- Add options dynamically if needed -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Brand</label>
                                <select name="brand" id="brandDropdown" class="form-control">
                                    <option value="">Select</option>
                                    <!-- Add options dynamically if needed -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Model</label>
                                <input type="text" class="form-control" name="model" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="model" rows="4"></textarea>
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

            document.addEventListener("DOMContentLoaded", function () {
    
    const openModalBtn = document.getElementById("modal_addasset");
    const closeModalBtn = document.getElementById("modal_close");
    const addAssetModal = new bootstrap.Modal(document.getElementById("addAssetModal"));

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

document.getElement("addAsset").addEventListenner("submit", function(e) {
    e.prevent();
    const formData = new FormData(this);
    const data = {};
    
    formData.forEach((value, ket) => {
        data[key] = value;
    });
    
    fetch('<%= request.getContextPath() %>/api/addassets', {
        method: 'POST',
        headers: {
            'Content-Type' : 'application/json'
        },
        body: JSON.stringify(data)
    })
            .then(res => {
                if (!res.ok)
                    throw new Error ("Network response was not ok");
                    return res.json();
            })
            .then(response => {
                alert(response.message);
                if (response.success) {
                    addAssetModal.hide();
                }
            })
                    .catch(err => {
                        console.error("Faild when add asset", err);
                        alert("Faild when add asset");
                    });         
});

        </script>
    </body>
</html>
