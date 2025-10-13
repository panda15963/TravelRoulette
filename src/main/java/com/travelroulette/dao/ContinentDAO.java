package com.travelroulette.dao;

import com.travelroulette.dto.continent.ContinentDto;
import com.travelroulette.utils.ConnectionPoolHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContinentDAO {
    private static final Logger logger = LoggerFactory.getLogger(ContinentDAO.class);

    public List<ContinentDto> findAll() {
        List<ContinentDto> list = new ArrayList<>();
        String sql = "SELECT continentNumber, continentNameKor, continentNameEng FROM Continent";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                list.add(new ContinentDto(
                        rs.getInt("continentNumber"),
                        rs.getString("continentNameKor"),
                        rs.getString("continentNameEng")
                ));
            }

        } catch (SQLException e) {
            logger.error("❌ Error fetching continents", e);
        }

        return list;
    }
}