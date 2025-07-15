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
                        <th>Transaction ID</th>
                        <th>Code</th>
                        <th>Category</th>
                        <th>Brand</th>
                        <th>Quantity</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String strsql = "select * from [transaction]";
                        try(DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(strsql))
                        {
                            while (rs.next()) { 
                    %>
                    <tr>
                        <td><%= rs.getInt("trans_id")%></td>
                        <td><%= rs.getInt("trans_stockid")%></td>
                        <td><%= rs.getInt("trans_stockid")%></td>
                        <td><%= rs.getInt("trans_stockid")%></td>
                        <td><%= rs.getInt("trans_stockid")%></td>
                        <td><%= rs.getInt("trans_stockid")%></td>
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
                            <div class="col-md-6">
                                <label class="form-label">Item</label>
                                <select name="item_list" id="ddl_item" class="form-control">
                                    <option value="1">-- Select --</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Quantity</label>
                                <input type="number" name="quantity" id="quantity" class="form-control">
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
            
            document.addEventListener("DOMContentLoaded", function () {
                const openModalBtn = document.getElementById("modal_addtransaction");
                const closeModalBtn = document.getElementById("modal_close");
                const addAssetModal = new bootstrap.Modal(document.getElementById("addtransactionModal"));

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
                
                const today = new Date();
                const yyyy = today.getFullYear();
                const mm = String(today.getMonth() + 1).padStart(2, '0'); // Months start at 0
                const dd = String(today.getDate()).padStart(2, '0');
                const formattedDate = `${dd}-${mm}-${yyyy}`;
                document.getElementById('trans_date').value = formattedDate;
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
                        console.log("Success adding asset");
                        $('#addtransactionModal').modal('hide');
                        
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
