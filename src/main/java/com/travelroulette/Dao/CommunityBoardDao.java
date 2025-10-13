package com.travelroulette.Dao;


import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Utils.ConnectionPoolHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommunityBoardDao {

    //게시글 목록 불러오기
    public List<PostDto> selectAllPosts(int boardNumber) {


        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<PostDto> postList = new ArrayList<>(); //게시글 목록 리스트

        //MySQL 쿼리
        String sql = "SELECT postNumber, postTitle, postDescription, postDateWritten, userId " +
                "FROM post " +
                "WHERE boardNumber = ? " +
                "ORDER BY postNumber DESC";
        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardNumber);
            rs = pstmt.executeQuery();


            while (rs.next()) {
                //postDto 객체 생성
                PostDto post = PostDto.builder()
                        .postNumber(rs.getInt("postNumber"))
                        .postTitle(rs.getString("postTitle"))
                        .postDescription(rs.getString("postDescription"))
                        //작성일자를 자바 객체로 변환
                        .postDateWritten(rs.getTimestamp("postDateWritten").toLocalDateTime())
                        .userId(rs.getString("userId"))
                        .boardNumber(boardNumber)
                        .build();
                //목록에 추가
                postList.add(post);
            }

        } catch (SQLException e) {
            //DB 오류 발생 시 오류 메시지를 출력
            System.out.println("게시글 목록 조회 중 오류 발생");
            e.printStackTrace();
        } finally {
            //자원 닫기
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        //게시글 목록 리스트 반환
        return postList;
    }


    //글쓰기
    public int insertPost(PostDto post) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        //SQL 쿼리
        String sql = "INSERT INTO post (postTitle, postDescription, postDateWritten, boardNumber, userId) " +
                "VALUES (?, ?, NOW(), ?, ?)";

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);

            //SQL 쿼리에 실제 값 채우기
            pstmt.setString(1, post.getPostTitle()); //1. 제목
            pstmt.setString(2, post.getPostDescription()); //2. 내용
            pstmt.setInt(3, post.getBoardNumber()); //3. 게시판 번호
            pstmt.setString(4, post.getUserId()); //4. 작성자 ID

            //행의 수를 result에 저장
            result = pstmt.executeUpdate();
            //conn.commit();

        } catch (SQLException e) {
            System.out.println("게시글 저장 오류: " + e.getMessage());
            e.printStackTrace();
        } finally {
            //자원 닫기
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return result;
    }


    //게시글 상세 보기
    public PostDto selectOnePost(int postNumber) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PostDto post = null; //결과

        //MySQL 쿼리
        String sql = "SELECT postNumber, postTitle, postDescription, postDateWritten, userId, boardNumber " +
                "FROM post " +
                "WHERE postNumber = ?";
        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            //글 번호 채워넣기
            pstmt.setInt(1, postNumber);
            rs = pstmt.executeQuery();

            //글 찾기 성공 시
            if (rs.next()) { 
                //날짜 값이 NULL일 경우 대비
                java.sql.Timestamp ts = rs.getTimestamp("postDateWritten");
                java.time.LocalDateTime dateWritten = (ts != null) ? ts.toLocalDateTime() : null;

                //PostDto 객체를 생성 후 조회된 데이터로 속성 채우기
                post = PostDto.builder()
                        .postNumber(rs.getInt("postNumber"))
                        .postTitle(rs.getString("postTitle"))
                        .postDescription(rs.getString("postDescription"))
                        .postDateWritten(dateWritten)
                        .userId(rs.getString("userId"))
                        .boardNumber(rs.getInt("boardNumber"))
                        .build();
            }
        } catch (SQLException e) {
            System.out.println("게시글 상세 보기 오류 발생");
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return post; //PostDto 객체 반환
    }






}
