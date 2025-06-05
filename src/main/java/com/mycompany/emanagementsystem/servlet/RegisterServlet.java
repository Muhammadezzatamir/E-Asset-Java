package com.mycompany.servlets;

import com.mycompany.utils.CryptoUtil;
import com.mycompany.utils.DBWrapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (DBWrapper db = new DBWrapper()) {

            // --- 1. Insert Address into gl_address ---
            String insertAddressSQL = "INSERT INTO gl_address (address1, address2, address3, postcode, city_id, city_other, district_id, district_other, state_id, state_other, country, aud_add_date, aud_add_userid, aud_action, aud_action_date) " +
                                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            Timestamp now = new Timestamp(System.currentTimeMillis());

            try (PreparedStatement addressStmt = db.getConnection().prepareStatement(insertAddressSQL, Statement.RETURN_GENERATED_KEYS)) {
                addressStmt.setString(1, request.getParameter("address1"));
                addressStmt.setString(2, request.getParameter("address2"));
                addressStmt.setString(3, request.getParameter("address3"));
                addressStmt.setString(4, request.getParameter("postcode"));
                addressStmt.setString(5, request.getParameter("city_id"));
                addressStmt.setString(6, request.getParameter("city_other"));
                addressStmt.setString(7, request.getParameter("district_id"));
                addressStmt.setString(8, request.getParameter("district_other"));
                addressStmt.setString(9, request.getParameter("state_id"));
                addressStmt.setString(10, request.getParameter("state_other"));
                addressStmt.setString(11, request.getParameter("country"));
                addressStmt.setTimestamp(12, now);
                addressStmt.setString(13, getAuditUser(request));
                addressStmt.setString(14, "INSERT");
                addressStmt.setTimestamp(15, now);
                addressStmt.executeUpdate();

                ResultSet keys = addressStmt.getGeneratedKeys();
                int addressId = -1;
                if (keys.next()) {
                    addressId = keys.getInt(1);
                } else {
                    throw new SQLException("Failed to retrieve address ID.");
                }
                
                String encrypted = request.getParameter("password");
                String encypt_pass;
                try {
                    encypt_pass = CryptoUtil.encrypt(encrypted);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Encryption failed.");
                    return;
                }


                // --- 2. Insert into gl_user ---
                String insertUserSQL = "INSERT INTO gl_user (user_name, password, first_name, last_name, nric, email, mobile_no, gender_id, race_id, marital_status, address_id, company_name, company_no, company_address_id, aud_add_date, aud_add_userid, aud_action, aud_action_date) " +
                                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement userStmt = db.getConnection().prepareStatement(insertUserSQL)) {
                    userStmt.setString(1, request.getParameter("user_name"));
                    userStmt.setString(2, encypt_pass);
                    userStmt.setString(3, request.getParameter("first_name"));
                    userStmt.setString(4, request.getParameter("last_name"));
                    userStmt.setString(5, request.getParameter("nric"));
                    userStmt.setString(6, request.getParameter("email"));
                    userStmt.setString(7, request.getParameter("mobile_no"));
                    userStmt.setString(8, request.getParameter("gender_id"));
                    userStmt.setString(9, request.getParameter("race_id"));
                    userStmt.setString(10, request.getParameter("marital_status"));
                    userStmt.setInt(11, addressId);
                    userStmt.setString(12, request.getParameter("company_name"));
                    userStmt.setString(13, request.getParameter("company_no"));
                    userStmt.setString(14, request.getParameter("company_address_id"));
                    userStmt.setTimestamp(15, now);
                    userStmt.setString(16, getAuditUser(request));
                    userStmt.setString(17, "INSERT");
                    userStmt.setTimestamp(18, now);
                    userStmt.executeUpdate();
                }
            }

            response.sendRedirect("register-success.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Registration failed.");
        }
    }

    private String getAuditUser(HttpServletRequest request) {
        String user = request.getParameter("aud_add_userid");
        return (user != null && !user.trim().isEmpty()) ? user : "system";
    }
}
