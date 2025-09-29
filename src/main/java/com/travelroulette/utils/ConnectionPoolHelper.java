package com.travelroulette.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ConnectionPoolHelper {
    private static DataSource ds;

    static {
        try {
            Context context = new InitialContext();
            //ds =  (DataSource)context.lookup("java:comp/env/jdbc/oracle");
            ds = (DataSource) context.lookup("java:comp/env/jdbc/mysql");
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection(); //연결 객체 하나 빌려주
    }


    public static void close(Connection conn) {
        if(conn != null) {
            try {
                conn.close(); //반환하기
            } catch (Exception e) {
                // TODO: handle exception
            }
        }
    }

    public static void close(ResultSet rs) {
        if(rs != null) {
            try {
                rs.close();
            } catch (Exception e) {
                // TODO: handle exception
            }
        }
    }
    public static void close(Statement stmt) {
        if(stmt != null) {
            try {
                stmt.close();
            } catch (Exception e) {
                // TODO: handle exception
            }
        }
    }

    public static void close(PreparedStatement pstmt) {
        if(pstmt != null) {
            try {
                pstmt.close();
            } catch (Exception e) {
                // TODO: handle exception
            }
        }
    }
}