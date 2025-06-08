package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.CryptoUtil;
import com.mycompany.utils.DBWrapper;
import org.json.JSONObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.*;

import java.sql.ResultSet;

@WebServlet("/api/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Read raw JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JSONObject input = new JSONObject(sb.toString());
            String username = input.optString("username", null);
            String password = input.optString("password", null);

            if (username == null || password == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Username and password required.\"}");
                return;
            }

            // Encrypt password
            String encrypted = CryptoUtil.encrypt(password);

            DBWrapper db = new DBWrapper();
            String sql = "SELECT * FROM gl_user WHERE user_name = ? AND password = ?";
            ResultSet rs = db.executePreparedQuery(sql, username, encrypted);

            if (rs != null && rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("fullname", rs.getString("first_name") + " " + rs.getString("last_name"));

                response.getWriter().write("{\"success\": true, \"message\": \"Login successful.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid username or password.\"}");
            }

            if (rs != null) rs.close();
            db.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Internal server error.\"}");
        }
    }
}
