package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.DBWrapper;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/api/brand")
public class BrandServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String categoryId = request.getParameter("categoryId");
        System.out.println("Received categoryId: " + categoryId);  // Server-side log, won't interfere with response

        if (categoryId == null || categoryId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing categoryId parameter\"}");
            return;
        }

        String query = "SELECT parameter_code, parameter_value FROM gl_parameter WHERE parameter_type = '1003' and parameter_parent_code = ?";

        JSONArray brandList = new JSONArray();

        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executePreparedQuery(query, categoryId)) {

            while (rs.next()) {
                JSONObject brand = new JSONObject();
                brand.put("id", rs.getString("parameter_code"));
                brand.put("name", rs.getString("parameter_value"));
                brandList.put(brand);
            }

            System.out.println("Brands JSON: " + brandList.toString());
            out.print(brandList.toString());

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Database error occurred\"}");
        }
    }
}
