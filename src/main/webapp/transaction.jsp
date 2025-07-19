<%@ page import="java.sql.*, com.mycompany.utils.DBWrapper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>E-Asset System</title>
        <!-- Boostrap css -->
        <link href="Bootstrap/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Custom CSS -->
        <link href="css/style.css" rel="stylesheet"/>
        <script src="js/script.js"></script>
    </head>
    <body>
        <%@include file="header.jsp" %>
        
        <%@include file="sidebar.jsp" %>
        
        <main class="content">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3 class="mb-0">Transaction List</h3>
                <button type="button" class="btn btn-primary" id="modal_addtransaction">
                    <i class="bi bi-plus-circle me-1"></i> Add Transaction
                </button>
            </div>
            <table id="contactsTable" class="display table table-striped" style="width: 100%">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Code</th>
                        <th>Category</th>
                        <th>Brand</th>
                        <th>Model</th>
                        <th>Quantity</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        roleId = (String) session.getAttribute("role_id");
                        String userId = (String) session.getAttribute("user_id");
                        String strsql = "";
                        if ("1".equals(roleId)) {
                            strsql = "select ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num_row, a.trans_id, d.stock_code, b.parameter_value as category, c.parameter_value as brand, d.stock_model, d.quantity " +
                                        " from [transaction] a " +
                                        " left join stock d on a.trans_stockid = d.stock_id and d.is_deleted = 0 " +
                                        " left join gl_parameter b on d.stock_category = b.parameter_code and b.parameter_type = '1002' " +
                                        " left join gl_parameter c on d.stock_brand = c.parameter_code and c.parameter_type = '1003' " +
                                        " where a.is_deleted = 0";
                        }
                        else
                        {
                            strsql = "select ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num_row, a.trans_id, d.stock_code, b.parameter_value as category, c.parameter_value as brand, d.stock_model, d.quantity " +
                                        " from [transaction] a " +
                                        " left join stock d on a.trans_stockid = d.stock_id and d.is_deleted = 0 " +
                                        " left join gl_parameter b on d.stock_category = b.parameter_code and b.parameter_type = '1002' " +
                                        " left join gl_parameter c on d.stock_brand = c.parameter_code and c.parameter_type = '1003' " +
                                        " where a.is_deleted = 0 and a.trans_userid = '" + userId + "'";
                        }
                        try(DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(strsql))
                        {
                            while (rs.next()) { 
                    %>
                    <tr>
                        <td><%= rs.getInt("num_row")%></td>
                        <td><%= rs.getString("stock_code")%></td>
                        <td><%= rs.getString("category")%></td>
                        <td><%= rs.getString("brand")%></td>
                        <td><%= rs.getString("stock_model")%></td>
                        <td><%= rs.getInt("quantity")%></td>
                        <td>
                            <button class="btn btn-sm btn-warning me-1 edit-btn" data-id="<%= rs.getInt("trans_id") %>">
                                <i class="bi bi-pencil"></i>
                            </button>
                            <button class="btn btn-sm btn-danger delete-btn" data-id="<%= rs.getInt("trans_id") %>">
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
        
                
        <!-- Add Transaction Modal -->
        <div class="modal fade" id="addtransactionModal" tabindex="-1" aria-labelledby="addtransactionModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form id="addTransaction">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addTransactionModalLabel">Add New Transaction</h5>
                            <button type="button" class="btn-close" id="modal_close" arial-label="Close">X</button>
                        </div>
                        <div class="modal-body row g-3">
                            <input type="hidden" name="trans_id" id="trans_id" />

                            <div class="col-md-6">
                                <label class="form-label">Item</label>
                                <select name="trans_stockid" id="trans_stockid" class="form-control">
                                    <option value="1">-- Select --</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Quantity</label>
                                <input type="number" name="trans_stockout" id="trans_stockout" class="form-control">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Add Asset</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%@include file="footer.jsp" %>
        
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
                const openModalBtn = document.getElementById("modal_addtransaction");
                const closeModalBtn = document.getElementById("modal_close");
                addAssetModal = new bootstrap.Modal(document.getElementById("addtransactionModal"));
                
                //Load stock
                const ddl_stock = document.getElementById('trans_stockid');
                
                fetch('<%=request.getContextPath()%>/api/stock')
                .then(response => {
                    if (!response.ok) throw new Error("Network error");
                    return response.json();
                })
                .then(data => {
                    data.forEach(category => {
                        const option = document.createElement('option');
                        option.value = category.id;
                        option.textContent = category.name;
                        ddl_stock.appendChild(option);;
                    });
                })
                .catch(error => {
                    console.error('Error fetching category', error);
                    alert('Failed to load category list.');
                });

                openModalBtn.addEventListener("click", function () {
                    addAssetModal.show();
                });
                closeModalBtn.addEventListener("click", function () {
                    addAssetModal.hide();
                });
                
                const today = new Date();
                const yyyy = today.getFullYear();
                const mm = String(today.getMonth() + 1).padStart(2, '0'); // Months start at 0
                const dd = String(today.getDate()).padStart(2, '0');
                const formattedDate = `${dd}-${mm}-${yyyy}`;
                document.getElementById('trans_date').value = formattedDate;
            });
            
            document.querySelectorAll(".edit-btn").forEach(button => {
                    button.addEventListener("click", function (e) {
                        const trans_id = this.dataset.id;
                        console.log(trans_id);
                        
                        fetch("getAssetById.jsp?id=" + trans_id)
                            .then(res => res.json())
                            .then(data => {
                                console.log("Fetched transaction:", data);
                                document.getElementById("trans_id").value = trans_id;
                                document.getElementById("trans_stockid").value = data.trans_stockid; // ✅ matches item_list / ddl_item
                                document.getElementById("trans_stockout").value = data.trans_stockout; // ✅ matches quantity

                                // Update modal title
                                document.getElementById("addTransactionModalLabel").textContent = "Edit Transaction";
                                document.querySelector("button[type='submit']").textContent = "Update";
                                
                                addAssetModal.show();
                            })
                            .catch(err => console.error("Fetch failed", err));
                    });
                });
            
            document.getElementById("addTransaction").addEventListener("submit", function (e) {
                e.preventDefault();
                
                const formData = new FormData(this);
                const data = {};
                
                formData.forEach((value, key) => {
                    data[key] = value;
                });
                
                fetch('<%= request.getContextPath() %>/api/addtransaction', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body:JSON.stringify(data)
                })
                .then(res => {
                    if(!res.ok) throw new Error("Network response was not ok");
                    return res.json();
                })
                .then(response => {
                    alert(response.message);
                    if(response.success) {
                        console.log("Success adding transaction");
                        $('#addtransactionModal').modal('hide');
                        
                        this.reset();
                        location.reload();
                    }
                })
                .catch(err => {
                    console.error("Failed to add transaction", err);
                    alert("Failed to add asset");
                });
            });
        </script>
    </body>
</html>
