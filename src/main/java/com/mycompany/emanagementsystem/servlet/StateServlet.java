/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.DBWrapper;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 *
 * @author Acer
 */
@WebServlet("/api/state")
public class StateServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String query = "SELECT parameter_id, parameter_value FROM gl_parameter WHERE parameter_type = '3'";
        
        JSONArray countries = new JSONArray();
        
        try (DBWrapper db = new DBWrapper(); ResultSet rs = db.executeQuery(query)) {
            while (rs.next()) {
                JSONObject country = new JSONObject();
                country.put("id", rs.getInt("parameter_id"));
                country.put("name", rs.getString("parameter_value"));
                countries.put(country);
            }

            out.print(countries.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Database error occurred\"}");
        }
    }
}
