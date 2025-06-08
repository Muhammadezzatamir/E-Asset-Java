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

@WebServlet("/api/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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


            AuditInfo audit = AuditUtil.generateCreateAudit(auditUser);

            try (DBWrapper db = new DBWrapper(); Connection conn = db.getConnection()) {
                conn.setAutoCommit(false);

                int addressId = insertAddress(conn, input, audit);
                insertUser(conn, input, addressId, audit);

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

    private int insertAddress(Connection conn, JSONObject input, AuditInfo audit) throws SQLException {
    String sql = "INSERT INTO gl_address (" +
            "address_1, address_2, address_3, postcode, city_id, city_other, " +
            "district_id, district_other, state_id, state_other, country_id, " +
            "aud_add_date, aud_add_userid, aud_mod_date, aud_mod_userid, " +
            "aud_action_date, aud_action) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    System.out.println(sql);
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, input.optString("address1", null));
            stmt.setString(2, input.optString("address2", null));
            stmt.setString(3, input.optString("address3", null));
            stmt.setString(4, input.optString("postcode", null));
            stmt.setInt(5, input.optInt("city_id", 0));             // <-- integer
            stmt.setString(6, input.optString("city_other", null));
            stmt.setInt(7, input.optInt("district_id", 0));         // <-- integer
            stmt.setString(8, input.optString("district_other", null));
            stmt.setInt(9, input.optInt("state_id", 0));            // <-- integer
            stmt.setString(10, input.optString("state_other", null));
            stmt.setInt(11, input.optInt("country", 0));         // <-- integer

            stmt.setTimestamp(12, audit.addDate);
            stmt.setInt(13, audit.addUserId);
            stmt.setTimestamp(14, audit.modDate);
            stmt.setInt(15, audit.modUserId);
            stmt.setTimestamp(16, audit.actionDate);
            stmt.setString(17, audit.action);



            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                throw new SQLException("No address ID generated");
            }
        }
    }


    private void insertUser(Connection conn, JSONObject input, int addressId, AuditInfo audit) throws SQLException {
    String sql = "INSERT INTO gl_user (" +
                 "user_name, password, first_name, last_name, nric, email, mobile_no, gender_id, race_id, marital_status, " +
                 "address_id, role_id, " +
                 "reason, " +
                 "aud_add_date, aud_add_userid, aud_mod_date, aud_mod_userid, aud_action, aud_action_date" +
                 ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                 
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
            stmt.setInt(11, addressId);
            stmt.setInt(12, input.optInt("role_id", 0));

            // is_deleted = 0
            stmt.setString(13, input.optString("reason", null));

            stmt.setTimestamp(14, audit.addDate);
            stmt.setInt(15, audit.modUserId);
            stmt.setTimestamp(16, audit.modDate);  // or null if no modification yet
            stmt.setInt(17, audit.modUserId); // or null
            stmt.setString(18, audit.action);
            stmt.setTimestamp(19, audit.actionDate);

            stmt.executeUpdate();
        }
    }


    private String opt(JSONObject obj, String key) {
      String v = obj.optString(key, "").trim();
      return v.isEmpty() ? null : v;
    }
}
