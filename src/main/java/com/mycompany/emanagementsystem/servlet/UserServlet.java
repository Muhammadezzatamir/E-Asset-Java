package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.AuditUtil;
import com.mycompany.utils.AuditUtil.AuditInfo;
import com.mycompany.utils.CryptoUtil;
import com.mycompany.utils.DBWrapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;

import org.json.JSONObject;
import java.io.IOException;
import java.sql.*;

@WebServlet("/api/adduser")
public class UserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        JSONObject result = new JSONObject();

        try (BufferedReader reader = request.getReader()) {
            StringBuilder jb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) jb.append(line);

            JSONObject input = new JSONObject(jb.toString());
            int auditUser = input.optInt("aud_add_userid", 0); // default to 0 if key is missing


            AuditUtil.AuditInfo audit = AuditUtil.generateCreateAudit(auditUser);

            try (DBWrapper db = new DBWrapper(); Connection conn = db.getConnection()) {
                conn.setAutoCommit(false);

                insertUser(conn, input, audit);

                conn.commit();

                result.put("success", true);
                result.put("message", "Registration successful!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Registration failed: " + e.getMessage());
        }

        response.getWriter().write(result.toString());
    }
    
    private void insertUser(Connection conn, JSONObject input, AuditInfo audit) throws SQLException {
    String sql = "INSERT INTO gl_user (" +
                 "user_name, password, first_name, last_name, nric, email, mobile_no, gender_id, race_id, marital_status, " +
                 "role_id, " +
                 "reason, " +
                 "aud_add_date, aud_add_userid, aud_mod_date, aud_mod_userid, aud_action, aud_action_date" +
                 ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                 
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, input.optString("user_name", null));
            String rawPassword = input.optString("password", null);
            String encrypted;
            try {
                encrypted = CryptoUtil.encrypt(rawPassword);
            } catch (Exception e) {
                throw new SQLException("Password encryption failed", e);
            }

            stmt.setString(2, encrypted);
            stmt.setString(3, input.optString("first_name", null));
            stmt.setString(4, input.optString("last_name", null));
            stmt.setString(5, input.optString("nric", null));
            stmt.setString(6, input.optString("email", null));
            stmt.setString(7, input.optString("mobile_no", null));
            stmt.setInt(8, input.optInt("gender_id", 0));
            stmt.setInt(9, input.optInt("race_id", 0));
            stmt.setString(10, input.optString("marital_status", null));
            stmt.setInt(11, 1);

            // is_deleted = 0
            stmt.setString(12, input.optString("reason", null));

            stmt.setTimestamp(13, audit.addDate);
            stmt.setInt(14, audit.modUserId);
            stmt.setTimestamp(15, audit.modDate);  // or null if no modification yet
            stmt.setInt(16, audit.modUserId); // or null
            stmt.setString(17, audit.action);
            stmt.setTimestamp(18, audit.actionDate);

            stmt.executeUpdate();
        }
    }


    private String opt(JSONObject obj, String key) {
      String v = obj.optString(key, "").trim();
      return v.isEmpty() ? null : v;
    }
}
