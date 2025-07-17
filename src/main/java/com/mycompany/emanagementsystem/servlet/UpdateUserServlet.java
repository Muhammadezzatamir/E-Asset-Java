package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.DBWrapper;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet("/api/updateuser")
public class UpdateUserServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        JSONObject result = new JSONObject();

        try (BufferedReader reader = request.getReader()) {
            StringBuilder jb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) jb.append(line);
            JSONObject input = new JSONObject(jb.toString());

            try (DBWrapper db = new DBWrapper(); Connection conn = db.getConnection()) {
                conn.setAutoCommit(false);

                String sql = "UPDATE gl_user SET user_name = ?, password = ?, first_name = ?, last_name = ?, nric = ?, email = ?, mobile_no = ?, gender_id = ?, race_id = ?, marital_status = ? WHERE user_id = ? AND is_deleted = 0";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, input.optString("user_name"));
                    stmt.setString(2, input.optString("password"));
                    stmt.setString(3, input.optString("first_name"));
                    stmt.setString(4, input.optString("last_name"));
                    stmt.setString(5, input.optString("nric"));
                    stmt.setString(6, input.optString("email"));
                    stmt.setString(7, input.optString("mobile_no"));
                    stmt.setString(8, input.optString("gender_id"));
                    stmt.setString(9, input.optString("race_id"));
                    stmt.setString(10, input.optString("marital_status"));
                    stmt.setInt(11, input.optInt("user_id"));

                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        result.put("success", true);
                        result.put("message", "User updated successfully.");
                    } else {
                        result.put("success", false);
                        result.put("message", "No user updated. Check ID.");
                    }
                }

                conn.commit();
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Error updating user: " + e.getMessage());
        }

        response.getWriter().write(result.toString());
    }
}
