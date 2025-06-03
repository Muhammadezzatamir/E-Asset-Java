package com.mycompany.utils;

import java.sql.*;

public class DBWrapper implements AutoCloseable {
    private static final String Desc_URL = "g+LvvBZMy9etIGmCqJuHEF0ArSNMUHm3ehcbDiSQp/o36e/9PBr/kmFGkPkTEHQqsc70xqO+0MKknv4wJlTfYF9GEf++GC4VqcCnPiUb76JPkyzbANngTn/3yE0ueSquVBtmxYCA8Y2zPhpIMP+NzNRc4zh1O4F4O3M+++hN2SeDZWQN6mcRXvVwPcNmGKoF";
    private static final String URL;

    static {
        String tempUrl = null;
        try {
            tempUrl = CryptoUtil.decrypt(Desc_URL);
            System.out.println("Decrypted password: " + tempUrl);
        } catch (Exception e) {
            e.printStackTrace();
        }
        URL = tempUrl;
    }

    private Connection conn;

    public Connection getConnection() {
        return this.conn;
    }

    public DBWrapper() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(URL);
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server JDBC Driver not found", e);
        }
    }

    public ResultSet executeQuery(String query) throws SQLException {
        Statement stmt = conn.createStatement();
        return stmt.executeQuery(query);
    }

    public int executeUpdate(String query) throws SQLException {
        Statement stmt = conn.createStatement();
        return stmt.executeUpdate(query);
    }

    public ResultSet executePreparedQuery(String query, Object... params) throws SQLException {
        PreparedStatement pstmt = conn.prepareStatement(query);
        setParameters(pstmt, params);
        return pstmt.executeQuery();
    }

    public int executePreparedUpdate(String query, Object... params) throws SQLException {
        PreparedStatement pstmt = conn.prepareStatement(query);
        setParameters(pstmt, params);
        return pstmt.executeUpdate();
    }

    private void setParameters(PreparedStatement pstmt, Object... params) throws SQLException {
        for (int i = 0; i < params.length; i++) {
            pstmt.setObject(i + 1, params[i]);
        }
    }

    @Override
    public void close() {
        try {
            if (conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
