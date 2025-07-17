<%@ page import="java.sql.*, org.json.JSONObject, com.mycompany.utils.DBWrapper" %>
<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%
    String id = request.getParameter("id");
    JSONObject obj = new JSONObject();

    try (DBWrapper db = new DBWrapper();
         PreparedStatement stmt = db.getConnection().prepareStatement(
             "SELECT * FROM [transaction] WHERE trans_id = ?")) {
        
        stmt.setInt(1, Integer.parseInt(id));
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            obj.put("trans_stockid", rs.getString("trans_stockid"));
            obj.put("trans_stockout", rs.getInt("trans_stockout"));
        }
        rs.close();
    } catch (Exception e) {
        e.printStackTrace();
        obj.put("error", "Unable to fetch transaction");
    }

    out.print(obj.toString());
%>
