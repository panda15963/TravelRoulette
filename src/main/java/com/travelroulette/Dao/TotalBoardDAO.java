package com.travelroulette.Dao;

import com.travelroulette.Dto.TotalBoard.TotalBoardDto;
import com.travelroulette.Utils.ConnectionPoolHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TotalBoardDAO {
    private static final Logger logger = LoggerFactory.getLogger(TotalBoardDAO.class);

    public List<TotalBoardDto> findAll() {
        List<TotalBoardDto> list = new ArrayList<>();

        String sql =
                "SELECT " +
                        "   ROW_NUMBER() OVER (ORDER BY " +
                        "       CASE WHEN boardType = '자유게시판' THEN 1 ELSE 2 END, " +
                        "       createdAt DESC) AS id, " +
                        "   title, " +
                        "   content, " +
                        "   userId, " +
                        "   createdAt, " +
                        "   boardType " +
                        "FROM ( " +
                        "   SELECT " +
                        "       p.postTitle AS title, " +
                        "       p.postDescription AS content, " +
                        "       p.postDateWritten AS createdAt, " +
                        "       u.userId AS userId, " +
                        "       b.boardName AS boardType " +
                        "   FROM post p " +
                        "   JOIN user u ON p.userId = u.userId " +
                        "   JOIN board b ON p.boardNumber = b.boardNumber " +
                        "   UNION ALL " +
                        "   SELECT " +
                        "       a.QnATitle AS title, " +
                        "       a.QnADescription AS content, " +
                        "       a.QnADateWritten AS createdAt, " +
                        "       u.userId AS userId, " +
                        "       '질의응답' AS boardType " +
                        "   FROM answer a " +
                        "   JOIN user u ON a.userId = u.userId " +
                        "   WHERE a.QnADepth = 0 " +
                        ") AS combined " +
                        "ORDER BY " +
                        "   CASE WHEN boardType = '자유게시판' THEN 1 ELSE 2 END, " +
                        "   createdAt DESC";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                TotalBoardDto dto = TotalBoardDto.builder()
                        .id(rs.getInt("id"))
                        .title(rs.getString("title"))
                        .content(rs.getString("content"))
                        .userId(rs.getString("userId"))
                        .createdAt(rs.getTimestamp("createdAt"))
                        .boardType(rs.getString("boardType"))
                        .build();

                list.add(dto);
            }

            logger.info("✅ TotalBoardDAO.findAll() - {} posts fetched (게시글 + 질의응답)", list.size());

        } catch (SQLException e) {
            logger.error("❌ Error fetching total board posts", e);
        }

        return list;
    }
}