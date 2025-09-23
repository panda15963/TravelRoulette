package com.travelroulette;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/LoginList")
public class LoginList extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginList() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html; charset=utf-8");
        PrintWriter out = response.getWriter();

        //MySQL 용
        String driver = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/kosa_db?allowPublicKeyRetrieval=true&useSSL=false"; // kosa_db는 생성한 데이터베이스 이름
        String user = "kosa"; // MySQL 'kosa' 계정
        String password = "1004"; // 'kosa' 계정 비밀번호

        out.println("<html><body><div align=center>");
        out.println("<hr color=green width=400><h2> Line Memo List </h2><hr color=green width=400>");
        out.println("<table width='500' border='1'>");
        out.println("<tr bgcolor='gold'><th width='25%'>Writer</th><th width='50%'>MemoContent</th><th width='25%'>Email</th></tr>");

        try {
            Class.forName(driver);
            
            try (Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement ps = conn.prepareStatement("select * from memo");
                 ResultSet rs = ps.executeQuery()) {

                // 결과가 없을 경우를 대비한 체크
                if (!rs.isBeforeFirst()) {
                    out.println("<tr><td colspan='3'>등록된 메모가 없습니다.</td></tr>");
                } else {
                    while (rs.next()) {
                        String id = rs.getString("id");
                        String content = rs.getString("content");
                        String email = rs.getString("email");

                        out.println("<tr><td>" + id + "</td>");
                        out.println("<td>" + content + "</td>");
                        out.println("<td>" + email + "</td></tr>");
                    }
                }
            } // 자동으로 conn, ps, rs 가 .close() 됨
        } catch (ClassNotFoundException | SQLException e) {
            // 예외 처리를 좀 더 구체적으로 분리
            out.println("</table></div>");
            out.println("<hr><font color=red><h4>DB 연결 또는 SQL 처리 오류</h4>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</font>");
        }

        out.println("</table></div><center><a href='memo.html'>글쓰기</a></center></body></html>");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}