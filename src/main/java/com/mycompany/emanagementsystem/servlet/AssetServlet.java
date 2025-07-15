package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.AuditUtil;
import com.mycompany.utils.AuditUtil.AuditInfo;
import com.mycompany.utils.DBWrapper;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;
import javax.json.JsonObject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet("/api/addasset")
public class AssetServlet extends HttpServlet {
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
    
    private void insertAsset(Connection conn, JSONObject input, AuditInfo audit) throws SQLException{
        String strsql = "INSERT INTO stock " +
                " (stock_code, stock_category, stock_brand, stock_model, stock_desc, quantity, aud_add_date, aud_add_userid, aud_mod_date, aud_mod_userid, aud_action_date, aud_action) " +
                " VALUES " +
                " (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        
       try (PreparedStatement stmt = conn.prepareStatement(strsql)) {
           stmt.setString(1, input.optString("stock_code", null));
           stmt.setInt(2, input.optInt("stock_category", 0));
           stmt.setInt(3, input.optInt("stock_brand", 0));
           stmt.setString(4, input.optString("stock_model", null));
           stmt.setString(5, input.optString("stock_desc", null));
           stmt.setInt(6, input.optInt("quantity", 0));
           
           stmt.setTimestamp(7, audit.addDate);
           stmt.setInt(8, audit.modUserId);
           stmt.setTimestamp(9, audit.modDate);  // or null if no modification yet
           stmt.setInt(10, audit.modUserId); // or null
           stmt.setTimestamp(11, audit.actionDate);
           stmt.setString(12, audit.action);
           
            
           stmt.executeUpdate();
       }  
    }
    
    private String opt(JSONObject obj, String key) {
        String v = obj.optString(key, "").trim();
        return v.isEmpty()? null : v;
    }
}
