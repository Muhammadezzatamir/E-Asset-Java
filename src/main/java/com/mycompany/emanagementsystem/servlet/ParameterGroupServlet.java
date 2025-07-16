package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.AuditUtil;
import com.mycompany.utils.AuditUtil.AuditInfo;
import com.mycompany.utils.DBWrapper;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/api/addparametergroup")
public class ParameterGroupServlet extends HttpServlet{
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
            AuditInfo audit = AuditUtil.generateCreateAudit(auditUser);
            
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
        String strsql = "INSERT INTO gl_parameter_type " +
                " (parameter_type_value, aud_add_date, aud_add_userid, aud_mod_date, aud_mod_userid, aud_action_date, aud_action) " +
                " VALUES " +
                " (?, ?, ?, ?, ?, ?, ?) ";
        
       try (PreparedStatement stmt = conn.prepareStatement(strsql)) {
           stmt.setString(1, input.optString("parameter_type_value", null));
           
           stmt.setTimestamp(2, audit.addDate);
           stmt.setInt(3, audit.modUserId);
           stmt.setTimestamp(4, audit.modDate);  // or null if no modification yet
           stmt.setInt(5, audit.modUserId); // or null
           stmt.setTimestamp(6, audit.actionDate);
           stmt.setString(7, audit.action);
           
            
           stmt.executeUpdate();
       }  
    }
    
    private String opt(JSONObject obj, String key) {
        String v = obj.optString(key, "").trim();
        return v.isEmpty()? null : v;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException{
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String query = "select parameter_type_id, parameter_type_value from gl_parameter_type where is_deleted = 0";
        
        JSONArray category = new JSONArray();
        
        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(query)) {
            while (rs.next()) {
                JSONObject categories = new JSONObject();
                categories.put("id", rs.getString("parameter_type_id"));
                categories.put("name", rs.getString("parameter_type_value"));
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
