package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.AuditUtil;
import com.mycompany.utils.DBWrapper;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;

@WebServlet("/api/addtransaction")
public class TransactionServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        
        
        response.setContentType("application/json");
        JSONObject result = new JSONObject();
        
        HttpSession session = request.getSession(false);
        String userId = null;
        if (session != null) {
            userId = (String) session.getAttribute("user_id");
            System.out.println("Session found. userId: " + userId);
        } else {
            System.out.println("Session is null.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Not logged in.\"}");
            return;
        }

        if (userId == null) {
            System.out.println("user_id not set in session.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"User ID missing from session.\"}");
            return;
        }
        System.out.println("userId: " + userId);
        
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
                insertTrans(conn, userId, input, audit);
                
                conn.commit();
                
                result.put("success", true);
                result.put("message", "Asset has be add");
            }
        } 
        catch (Exception e)
        {
            e.printStackTrace();;
            result.put("success", false);
            result.put("message", "Failed to add new transation: " + e.getMessage());
        }
        response.getWriter().write(result.toString());
    }
    
    private void insertTrans(Connection conn, String userId, JSONObject input, AuditUtil.AuditInfo audit) throws SQLException{
        String strsql = "INSERT INTO [transaction] " +
                " (trans_userid, trans_stockid, trans_date, trans_stockout, tans_status, aud_add_date, aud_add_userid, aud_mod_date, aud_mod_userid, aud_action_date, aud_action) " +
                " VALUES " +
                " (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        
       try (PreparedStatement stmt = conn.prepareStatement(strsql)) {
           stmt.setString(1, userId);
           stmt.setString(2, "1");
           stmt.setDate(3, java.sql.Date.valueOf(LocalDate.now())); // ← today’s date
           stmt.setInt(4, input.optInt("quantity", 0));
           stmt.setString(5, "Stock Out");
           
           stmt.setTimestamp(6, audit.addDate);
           stmt.setInt(7, audit.modUserId);
           stmt.setTimestamp(8, audit.modDate);  // or null if no modification yet
           stmt.setInt(9, audit.modUserId); // or null
           stmt.setTimestamp(10, audit.actionDate);
           stmt.setString(11, audit.action);
           
            System.out.println(stmt);
           stmt.executeUpdate();
       }  
    }
    
    private String opt(JSONObject obj, String key) {
        String v = obj.optString(key, "").trim();
        return v.isEmpty()? null : v;
    }
}
