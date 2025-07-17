<%@ page import="java.sql.*, org.json.JSONObject, com.mycompany.utils.DBWrapper" %>
<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%
    String code = request.getParameter("code");
    JSONObject obj = new JSONObject();

    try (DBWrapper db = new DBWrapper();
         PreparedStatement stmt = db.getConnection().prepareStatement(
             "SELECT parameter_code, parameter_parent_code, parameter_value, parameter_type FROM gl_parameter WHERE parameter_id = ? AND is_deleted = 0")) {

        stmt.setString(1, code);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            obj.put("parameter_code", rs.getString("parameter_code"));
            obj.put("parameter_parent_code", rs.getString("parameter_parent_code"));
            obj.put("parameter_value", rs.getString("parameter_value"));
            obj.put("parameter_type", rs.getString("parameter_type"));
        } else {
            obj.put("error", "Parameter not found");
        }
        rs.close();
    } catch (Exception e) {
        e.printStackTrace();
        obj.put("error", "Unable to fetch parameter");
    }

    out.print(obj.toString());
%>
