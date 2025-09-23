package com.travelroulette;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }
    
    private void doProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 어떤 작업인지 구분
        String action = request.getParameter("action");

        if ("signup".equals(action)) {
            // 회원가입
            handleSignUp(request, response);
        } else if ("signin".equals(action)) {
            // 로그인
            handleSignIn(request, response);
        } else {
            // 잘못
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void handleSignIn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("userId");
        String userPassword = request.getParameter("userPassword");

        // DB 연결 정보 (별도 클래스로 분리하는 것이 좋음)
        String driver = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/kosa_db?allowPublicKeyRetrieval=true&useSSL=false";
     //이중도커용   String url = "jdbc:mysql://mysql-for-kosa:3306/kosa_db?allowPublicKeyRetrieval=true&useSSL=false";
        
        String user = "kosa";
        String password = "1004";
        
        String sql = "SELECT user_id, name FROM users WHERE user_id = ? AND user_password = ?";

        try {
            Class.forName(driver);
            try (Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setString(1, id);
                pstmt.setString(2, userPassword);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) { 
                        HttpSession session = request.getSession();
                        session.setAttribute("userId", rs.getString("user_id"));
                        session.setAttribute("userName", rs.getString("name"));
                        response.sendRedirect("index.jsp"); // 로그인 성공index.jsp로
                    } else { // 일치하는 사용자가 없으면
                        response.sendRedirect("pages/signIn.jsp?error=login_fail"); // 로그인 실패
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pages/signIn.jsp?error=login_fail"); // DB 오류 로그인 실패
        }
    }
    
    

    private void handleSignUp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
        // 아이디 이름 이메일 주소 입력값 제약걸
        if (id == null || userPassword == null || email == null || name == null || address == null ||
                !id.matches("^[a-zA-Z0-9]+$") ||
                !name.matches("^[a-zA-Z가-힣]+$") ||
                !email.matches(".+@.+\\..+") ||
                !address.contains("시")) {
        	response.sendRedirect("pages/signUp.jsp?error=validation_fail");
            return;
        }

        
        // 3. DB 연결 및 INSERT 처리
        String driver = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/kosa_db?allowPublicKeyRetrieval=true&useSSL=false";
        String user = "kosa";
        String password = "1004";
        
        
        try {
            Class.forName(driver);
            // DB 작업을 위해 Connection 객체를 try-with-resources로 선언
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                
                // 아이디 이메일 중복 확인
                String checkSql = "SELECT user_id FROM users WHERE user_id = ? OR email = ?";
                try (PreparedStatement pstmtCheck = conn.prepareStatement(checkSql)) {
                    pstmtCheck.setString(1, id);
                    pstmtCheck.setString(2, email);
                    
                    try (ResultSet rs = pstmtCheck.executeQuery()) {
                        if (rs.next()) {
                            if (id.equals(rs.getString("user_id"))) {
                                response.sendRedirect("pages/signUp.jsp?error=id_duplicate");
                            } else {
                                response.sendRedirect("pages/signUp.jsp?error=email_duplicate");
                            }
                            return;
                        }
                    }
                }

                // 회원가입처리
                String insertSql = "INSERT INTO users(user_id, user_password, email, name, address, gender) VALUES(?, ?, ?, ?, ?, ?)";
                try (PreparedStatement pstmtInsert = conn.prepareStatement(insertSql)) {
                    pstmtInsert.setString(1, id);
                    pstmtInsert.setString(2, userPassword);
                    pstmtInsert.setString(3, email);
                    pstmtInsert.setString(4, name);
                    pstmtInsert.setString(5, address);
                    pstmtInsert.setString(6, gender);

                    int resultRowCount = pstmtInsert.executeUpdate();

                    if (resultRowCount > 0) {
                        // 회원가입 성공: 로그인 페이지로 이동
                        response.sendRedirect("pages/signIn.jsp");
                    } else {
                        // INSERT 실패
                        response.sendRedirect("pages/signUp.jsp?error=dberror");
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace(); // 서버 콘솔로그 출력
            //DB 에러가 알림
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<h2>DB 처리 중 에러 발생</h2>");
            out.println("<p>관리자에게 문의하세요. 원인: " + e.getMessage() + "</p>");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doProcess(request, response);
    }
}