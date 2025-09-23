package com.travelroulette;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 한글 처리 (가장 위쪽에!)
        request.setCharacterEncoding("UTF-8");

        // 2. signUp.jsp에서 넘어온 데이터 받기
        String id = request.getParameter("userId");
        String userPassword = request.getParameter("userPassword");
        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender"); 
       
        // String terms = request.getParameter("terms"); // "on" 또는 null

        // 3. DB 연결 및 INSERT 처리
        String driver = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/kosa_db?allowPublicKeyRetrieval=true&useSSL=false";
        String user = "kosa";
        String password = "1004";
        
        
        // users 테이블에 회원 정보를 저장합니다. (DB에 users 테이블이 있어야 합니다)
        String sql = "INSERT INTO users(user_id, user_password, email, name, address, gender) VALUES(?, ?, ?, ?, ?, ?)";

        int resultRowCount = 0;
        try {
            Class.forName(driver);
            try (Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                // SQL 쿼리의 ?에 순서대로 값을 설정
                pstmt.setString(1, id);
                pstmt.setString(2, userPassword);
                pstmt.setString(3, email);
                pstmt.setString(4, name);
                pstmt.setString(5, address);
                pstmt.setString(6, gender);

                resultRowCount = pstmt.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            // 서버 콘솔에 에러 로그 출력
            e.printStackTrace();
            
            // 사용자에게 에러 페이지를 보여줌
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<h2>DB 처리 중 에러 발생</h2>");
            out.println("<p>관리자에게 문의하세요. (DB에 users 테이블이 있는지 확인하세요)</p>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            return;
        }

            if (resultRowCount > 0) {
            // 회원가입 성공: 로그인 페이지로 이동
        	response.sendRedirect("pages/signIn.jsp");
        } else {
            // 회원가입 실패: 다시 회원가입 페이지로 이동
            response.sendRedirect("signUp.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}