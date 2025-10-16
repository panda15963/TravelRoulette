package com.travelroulette.Dao.QnABoard;

import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Utils.ConnectionPoolHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class QnAAnswerDao {

    // 특정 원글에 답글이 이미 존재하는지 확인
    public boolean hasAnswer(int qnaRef) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;

        String sql = "SELECT COUNT(*) FROM Answer WHERE qnaRef = ? AND qnaDepth = 1";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaRef);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("답글 존재 여부 확인 오류");
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return exists;
    }

    // 특정 게시글의 답글 조회 (QnADepth = 1)
    public QnABoardDto selectAnswerByRef(int qnaRef) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        QnABoardDto answer = null;

        String sql = "SELECT qnaNumber, qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId " +
                "FROM Answer " +
                "WHERE qnaRef = ? AND qnaDepth = 1 " +
                "LIMIT 1";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaRef);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                java.sql.Timestamp ts = rs.getTimestamp("qnaDateWritten");
                java.time.LocalDateTime dateWritten = (ts != null) ? ts.toLocalDateTime() : null;

                answer = QnABoardDto.builder()
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
            System.out.println("답글 조회 오류");
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return answer;
    }

    // 특정 답글 조회 (qnaNumber 기준)
    public QnABoardDto selectOneAnswer(int qnaNumber) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        QnABoardDto answer = null;

        String sql = "SELECT qnaNumber, qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId " +
                "FROM Answer " +
                "WHERE qnaNumber = ? AND qnaDepth = 1";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaNumber);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                java.sql.Timestamp ts = rs.getTimestamp("qnaDateWritten");
                java.time.LocalDateTime dateWritten = (ts != null) ? ts.toLocalDateTime() : null;

                answer = QnABoardDto.builder()
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
            System.out.println("특정 답글 조회 오류");
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return answer;
    }

    // 답글 작성
    public int insertAnswer(QnABoardDto answer) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        String sql = "INSERT INTO Answer (qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId) " +
                "VALUES (?, ?, NOW(), ?, 1, 0, ?)";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, answer.getQnaTitle());
            pstmt.setString(2, answer.getQnaDescription());
            pstmt.setInt(3, answer.getQnaRef());
            pstmt.setString(4, answer.getUserId());

            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            System.out.println("답글 저장 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return result;
    }

    // 답글 수정
    public int updateAnswer(QnABoardDto answer) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        String sql = "UPDATE Answer SET qnaTitle = ?, qnaDescription = ? WHERE qnaNumber = ?";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, answer.getQnaTitle());
            pstmt.setString(2, answer.getQnaDescription());
            pstmt.setInt(3, answer.getQnaNumber());

            result = pstmt.executeUpdate();

        } catch (SQLException e) {
            System.out.println("답글 수정 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return result;
    }

    // 답글 삭제
    public int deleteAnswer(int qnaNumber) {
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
            System.out.println("답글 삭제 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return result;
    }

    // 특정 원글의 답글 삭제 (원글 삭제 시 사용)
    public int deleteAnswersByRef(int qnaRef) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        String sql = "DELETE FROM Answer WHERE qnaRef = ? AND qnaDepth = 1";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaRef);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("원글 삭제 중 답글 삭제 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return result;
    }
}
