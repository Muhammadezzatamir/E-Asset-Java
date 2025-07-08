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

@WebServlet("/api/category")
public class CategoryServlet extends HttpServlet{
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException{
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String query = "SELECT parameter_code, parameter_value FROM gl_parameter WHERE parameter_type = '1002'";
        
        JSONArray category = new JSONArray();
        
        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(query)) {
            while (rs.next()) {
                JSONObject categories = new JSONObject();
                categories.put("id", rs.getString("parameter_code"));
                categories.put("name", rs.getString("parameter_value"));
                category.put(categories);
            }

            out.print(category.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Database error occurred\"}");
        }
    }
}
