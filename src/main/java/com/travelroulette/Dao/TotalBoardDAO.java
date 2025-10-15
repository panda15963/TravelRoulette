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
                        "   b.boardName AS boardType " +
                        "FROM post p " +
                        "JOIN user u ON p.userId = u.userId " +
                        "JOIN board b ON p.boardNumber = b.boardNumber " +
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
                        .createdAt(rs.getTimestamp("createdAt"))
                        .boardType(rs.getString("boardType"))
                        .build();

                list.add(dto);
            }

            // ✅ 데이터 수 확인 로그
            logger.info("✅ TotalBoardDAO.findAll() - {} posts fetched.", list.size());

            // ✅ 상세 데이터 확인 로그 (필요 시 주석 해제)
            for (TotalBoardDto dto : list) {
                logger.debug("📄 [Post] id={}, title={}, userId={}, boardType={}, createdAt={}",
                        dto.getId(), dto.getTitle(), dto.getUserId(), dto.getBoardType(), dto.getCreatedAt());
            }

        } catch (SQLException e) {
            logger.error("❌ Error fetching total board posts", e);
        }

        return list;
    }
}