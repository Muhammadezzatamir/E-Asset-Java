<%@ page import="java.sql.*, org.json.JSONObject, com.mycompany.utils.DBWrapper" %>
<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%
    String id = request.getParameter("id");
    JSONObject obj = new JSONObject();

    try (DBWrapper db = new DBWrapper();
         PreparedStatement stmt = db.getConnection().prepareStatement("SELECT * FROM gl_user WHERE user_id = ?")) {
        
        stmt.setInt(1, Integer.parseInt(id));
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            obj.put("user_id", rs.getInt("user_id"));
            obj.put("user_name", rs.getString("user_name"));
            obj.put("password", rs.getString("password"));
            obj.put("first_name", rs.getString("first_name"));
            obj.put("last_name", rs.getString("last_name"));
            obj.put("nric", rs.getString("nric"));
            obj.put("email", rs.getString("email"));
            obj.put("mobile_no", rs.getString("mobile_no"));
            obj.put("gender_id", rs.getInt("gender_id"));
            obj.put("race_id", rs.getInt("race_id"));
            obj.put("marital_status", rs.getString("marital_status"));
        }
        rs.close();
    } catch (Exception e) {
        e.printStackTrace();
        obj.put("error", "Unable to fetch asset");
    }

    out.print(obj.toString());
%>
