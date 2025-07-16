package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.AuditUtil;
import com.mycompany.utils.DBWrapper;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/api/parameter")
public class ParameterServlet extends HttpServlet{
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

        String query = "select parameter_code, parameter_value from gl_parameter where is_deleted = 0 and parameter_type = ?";
        System.out.println(query);
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
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("application/json");
        JSONObject result = new JSONObject();
        
        try (BufferedReader reader = request.getReader())
        {
            StringBuilder jb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) jb.append(line);
            JSONObject input = new JSONObject(jb.toString());
            int auditUser = input.optInt("aud_add_userid", 0);
            AuditUtil.AuditInfo audit = AuditUtil.generateCreateAudit(auditUser);
            
            try (DBWrapper db = new DBWrapper(); Connection conn = db.getConnection())
            {
                conn.setAutoCommit(false);
                insertAsset(conn, input, audit);
                
                conn.commit();
                
                result.put("success", true);
                result.put("message", "Asset has be add");
            }
        } 
        catch (Exception e)
        {
            e.printStackTrace();;
            result.put("success", false);
            result.put("message", "Failed to add new asset: " + e.getMessage());
        }
        response.getWriter().write(result.toString());
    }
    
    private void insertAsset(Connection conn, JSONObject input, AuditUtil.AuditInfo audit) throws SQLException{
        String strsql = "INSERT INTO gl_parameter " +
                " (parameter_code, parameter_parent_code, parameter_value, parameter_type, aud_add_date, aud_add_userid, aud_mod_date, aud_mod_userid, aud_action_date, aud_action) " +
                " VALUES " +
                " (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        
       try (PreparedStatement stmt = conn.prepareStatement(strsql)) {
           stmt.setString(1, input.optString("parameter_code", null));
           stmt.setString(2, input.optString("parameter_parent_code", null));
           stmt.setString(3, input.optString("parameter_value", null));
           stmt.setString(4, input.optString("parameter_type", null));
           
           stmt.setTimestamp(5, audit.addDate);
           stmt.setInt(6, audit.modUserId);
           stmt.setTimestamp(7, audit.modDate);  // or null if no modification yet
           stmt.setInt(8, audit.modUserId); // or null
           stmt.setTimestamp(9, audit.actionDate);
           stmt.setString(10, audit.action);
           
            
           stmt.executeUpdate();
       }  
    }
    
    private String opt(JSONObject obj, String key) {
        String v = obj.optString(key, "").trim();
        return v.isEmpty()? null : v;
    }
}
