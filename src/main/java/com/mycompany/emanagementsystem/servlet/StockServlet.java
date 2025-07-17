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

@WebServlet("/api/stock")
public class StockServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException{
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String query = " select stock_id, CONCAT(b.parameter_value, ' ', c.parameter_value, ' ', a.stock_model) as stock_value " +
                        " from stock a " +
                        " left join gl_parameter b on a.stock_category = b.parameter_code and b.parameter_type = '1002' " +
                        " left join gl_parameter c on a.stock_brand = c.parameter_code and c.parameter_type = '1003' " +
                        " where a.is_deleted = 0 ";
        
        JSONArray category = new JSONArray();
        
        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(query)) {
            while (rs.next()) {
                JSONObject categories = new JSONObject();
                categories.put("id", rs.getString("stock_id"));
                categories.put("name", rs.getString("stock_value"));
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
