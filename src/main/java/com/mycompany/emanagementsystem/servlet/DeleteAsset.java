package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.AuditUtil;
import com.mycompany.utils.DBWrapper;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet("/api/deletestock")
public class DeleteAsset extends HttpServlet{
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
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
                DeleteAsset(conn, input, audit);
                
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
    
    private void DeleteAsset(Connection conn, JSONObject input, AuditUtil.AuditInfo audit) throws SQLException{
        String strsql = "UPDATE stock SET " +
        "is_deleted = 1, " +
        "aud_mod_date = ?, " +
        "aud_mod_userid = ?, " +
        "aud_action_date = ?, " +
        "aud_action = ? " +
        "WHERE stock_id = ?";

        System.out.println(input.getInt("stock_id"));
       try (PreparedStatement stmt = conn.prepareStatement(strsql)) {
            stmt.setTimestamp(1, audit.modDate);         // last modified date
            stmt.setInt(2, audit.modUserId);             // last modified user
            stmt.setTimestamp(3, audit.actionDate);      // last action timestamp
            stmt.setString(4, audit.action);            // action description like "UPDATE"

            stmt.setInt(5, input.getInt("stock_id"));   // primary key for WHERE
            stmt.executeUpdate();
       }  
    }
    
    private String opt(JSONObject obj, String key) {
        String v = obj.optString(key, "").trim();
        return v.isEmpty()? null : v;
    }
}
