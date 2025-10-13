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

        System.out.println("===== 3. DAO: selectAllPosts 시작 =====");


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






}
