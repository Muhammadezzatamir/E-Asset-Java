package com.mycompany.emanagementsystem.servlet;

import com.mycompany.utils.DBWrapper;
import java.sql.*;

public class AssetDAO {
    public static int getAssignedAssetCount(String userId) {
        int count = 0;
        try (DBWrapper db = new DBWrapper();
             PreparedStatement stmt = db.getConnection().prepareStatement(
                 "SELECT COUNT(quantity) FROM stock where is_deleted = 0"
             )) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public static int getAssignedTransCount(String userId) {
        int tran_count = 0;
        try (DBWrapper db = new DBWrapper();
                PreparedStatement stmt = db.getConnection().prepareStatement(
                        "select count(*) from [transaction] where is_deleted = 0"
                )) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                tran_count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tran_count;
    }
    
    public static int getAssignedUserCount(String userId) {
        int tran_count = 0;
        try (DBWrapper db = new DBWrapper();
                PreparedStatement stmt = db.getConnection().prepareStatement(
                        "select count(*) from gl_user where is_deleted = 0"
                )) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                tran_count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tran_count;
    }
    
    public static int getAssignedAssetCount_USER(String userId) {
        int count = 0;
        try (DBWrapper db = new DBWrapper();
             PreparedStatement stmt = db.getConnection().prepareStatement(
                 "SELECT COUNT(quantity) FROM stock where is_deleted = 0"
             )) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public static int getAssignedTransCount_USER(String userId) {
        int tran_count = 0;
        try (DBWrapper db = new DBWrapper();
                PreparedStatement stmt = db.getConnection().prepareStatement(
                        "select count(*) from [transaction] where is_deleted = 0 AND trans_userid = ?"
                )) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                tran_count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tran_count;
    }
}
