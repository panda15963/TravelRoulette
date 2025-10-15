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
                        "   p.postNumber AS id, " +
                        "   p.postTitle AS title, " +
                        "   p.postDescription AS content, " +
                        "   p.postDateWritten AS createdAt, " +
                        "   u.userId AS userId, " +
                        "   CASE " +
                        "       WHEN p.postType = 'question' THEN '질의응답' " +
                        "       ELSE '자유게시판' " +
                        "   END AS boardType " +
                        "FROM post p " +
                        "JOIN user u ON p.userId = u.userId " +
                        "ORDER BY createdAt DESC";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                TotalBoardDto dto = TotalBoardDto.builder()
                        .id(rs.getInt("id"))
                        .title(rs.getString("title"))
                        .content(rs.getString("content"))
                        .userId(rs.getString("userId"))
                        .createdAt(rs.getTimestamp("createdAt").toLocalDateTime())
                        .boardType(rs.getString("boardType"))
                        .build();

                list.add(dto);
            }

        } catch (SQLException e) {
            logger.error("❌ Error fetching total board posts", e);
        }

        return list;
    }
}