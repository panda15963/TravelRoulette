package com.travelroulette.Dao.QnABoard;

import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Utils.ConnectionPoolHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QnAPostDao {

    // 질의응답 게시글 목록 불러오기 (페이지네이션 + 검색)
    // 원글과 답글 모두 조회
    public List<QnABoardDto> selectAllQnAPosts(int page, int pageSize, boolean asc, String searchKeyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<QnABoardDto> qnaList = new ArrayList<>();

        // 정렬 방향
        String order = asc ? "ASC" : "DESC";

        // MySQL 쿼리 - 원글과 답글 모두 조회, qnaRef와 qnaDepth로 정렬
        StringBuilder sql = new StringBuilder("SELECT qnaNumber, qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId ")
                .append("FROM Answer ");

        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append("WHERE qnaTitle LIKE ? ");
        }

        // 정렬: qnaRef로 묶고, depth로 원글(0) 먼저, 답글(1) 나중에
        sql.append("ORDER BY qnaRef ").append(order).append(", qnaDepth ASC ")
                .append("LIMIT ? OFFSET ?");

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            int parameterIndex = 1;

            // 검색어 값
            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                pstmt.setString(parameterIndex++, "%" + searchKeyword + "%");
            }

            int offset = (page - 1) * pageSize;
            pstmt.setInt(parameterIndex++, pageSize);
            pstmt.setInt(parameterIndex++, offset);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                java.sql.Timestamp ts = rs.getTimestamp("qnaDateWritten");
                java.time.LocalDateTime dateWritten = (ts != null) ? ts.toLocalDateTime() : null;

                QnABoardDto qna = QnABoardDto.builder()
                        .qnaNumber(rs.getInt("qnaNumber"))
                        .qnaTitle(rs.getString("qnaTitle"))
                        .qnaDescription(rs.getString("qnaDescription"))
                        .qnaDateWritten(dateWritten)
                        .qnaRef(rs.getInt("qnaRef"))
                        .qnaDepth(rs.getInt("qnaDepth"))
                        .qnaStep(rs.getInt("qnaStep"))
                        .userId(rs.getString("userId"))
                        .build();

                qnaList.add(qna);
            }

        } catch (SQLException e) {
            System.out.println("QnA 게시글 목록 조회 중 오류 발생");
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return qnaList;
    }

    // 질의응답 게시글 작성 (원글)
    public int insertQnAPost(QnABoardDto qna) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int result = 0;

        // SQL 쿼리 - QnAref는 게시글 번호로 자동 설정
        String sql = "INSERT INTO Answer (qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId) " +
                "VALUES (?, ?, NOW(), 0, 0, 0, ?)";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            pstmt.setString(1, qna.getQnaTitle());
            pstmt.setString(2, qna.getQnaDescription());
            pstmt.setString(3, qna.getUserId());

            result = pstmt.executeUpdate();

            // 생성된 QnANumber를 가져와서 QnAref로 업데이트
            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    updateQnARef(conn, generatedId);
                }
            }

        } catch (SQLException e) {
            System.out.println("QnA 게시글 저장 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return result;
    }

    // QnAref 업데이트 (원글의 경우 자기 자신을 참조)
    private void updateQnARef(Connection conn, int qnaNumber) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE Answer SET qnaRef = ? WHERE qnaNumber = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaNumber);
            pstmt.setInt(2, qnaNumber);
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) {
                pstmt.close();
            }
        }
    }

    // 질의응답 게시글 상세 보기
    public QnABoardDto selectOneQnAPost(int qnaNumber) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        QnABoardDto qna = null;

        String sql = "SELECT qnaNumber, qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId " +
                "FROM Answer " +
                "WHERE qnaNumber = ?";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaNumber);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                java.sql.Timestamp ts = rs.getTimestamp("qnaDateWritten");
                java.time.LocalDateTime dateWritten = (ts != null) ? ts.toLocalDateTime() : null;

                qna = QnABoardDto.builder()
                        .qnaNumber(rs.getInt("qnaNumber"))
                        .qnaTitle(rs.getString("qnaTitle"))
                        .qnaDescription(rs.getString("qnaDescription"))
                        .qnaDateWritten(dateWritten)
                        .qnaRef(rs.getInt("qnaRef"))
                        .qnaDepth(rs.getInt("qnaDepth"))
                        .qnaStep(rs.getInt("qnaStep"))
                        .userId(rs.getString("userId"))
                        .build();
            }
        } catch (SQLException e) {
            System.out.println("QnA 게시글 상세 보기 오류 발생");
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return qna;
    }

    // 질의응답 게시글 수정
    public int updateQnAPost(QnABoardDto qna) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        String sql = "UPDATE Answer SET qnaTitle = ?, qnaDescription = ? WHERE qnaNumber = ?";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, qna.getQnaTitle());
            pstmt.setString(2, qna.getQnaDescription());
            pstmt.setInt(3, qna.getQnaNumber());

            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            System.out.println("QnA 게시글 수정 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return result;
    }

    // 질의응답 게시글 삭제
    public int deleteQnAPost(int qnaNumber) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        String sql = "DELETE FROM Answer WHERE qnaNumber = ?";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaNumber);

            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            System.out.println("QnA 게시글 삭제 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return result;
    }

    // 총 질의응답 게시글 수 (원글과 답글 모두)
    public int getQnAPostCount(String searchKeyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int totalCount = 0;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Answer");

        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append(" WHERE qnaTitle LIKE ?");
        }

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql.toString());

            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                pstmt.setString(1, "%" + searchKeyword + "%");
            }

            rs = pstmt.executeQuery();

            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("총 QnA 게시글 개수 조회 오류");
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return totalCount;
    }
}
