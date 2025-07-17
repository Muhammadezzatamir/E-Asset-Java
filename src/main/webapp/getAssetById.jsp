<%@ page import="java.sql.*, org.json.JSONObject, com.mycompany.utils.DBWrapper" %>
<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%
    String id = request.getParameter("id");
    JSONObject obj = new JSONObject();

    try (DBWrapper db = new DBWrapper();
         PreparedStatement stmt = db.getConnection().prepareStatement("SELECT * FROM stock WHERE stock_id = ?")) {
        
        stmt.setInt(1, Integer.parseInt(id));
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            obj.put("stock_code", rs.getString("stock_code"));
            obj.put("stock_category", rs.getString("stock_category"));
            obj.put("stock_brand", rs.getString("stock_brand"));
            obj.put("stock_model", rs.getString("stock_model"));
            obj.put("stock_desc", rs.getString("stock_desc"));
            obj.put("quantity", rs.getInt("quantity"));
        }
        rs.close();
    } catch (Exception e) {
        e.printStackTrace();
        obj.put("error", "Unable to fetch asset");
    }

    out.print(obj.toString());
%>
