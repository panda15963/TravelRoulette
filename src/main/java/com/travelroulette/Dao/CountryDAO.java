package com.travelroulette.Dao;

import com.travelroulette.Dto.Country.CountryDto;
import com.travelroulette.Utils.ConnectionPoolHelper;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CountryDAO {

    public List<CountryDto> getCountriesByContinent(int continentNumber) {
        List<CountryDto> countries = new ArrayList<>();

        // ✅ continentNumber 로 직접 필터링
        String sql =
                "SELECT countryCode, countryNameKor, countryNameEng, flagURL, continentNumber " +
                        "FROM country WHERE continentNumber = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionPoolHelper.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, continentNumber);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                CountryDto dto = CountryDto.builder()
                        .countryCode(rs.getString("countryCode"))
                        .countryNameKor(rs.getString("countryNameKor"))
                        .countryNameEng(rs.getString("countryNameEng"))
                        .flagURL(rs.getString("flagURL"))
                        .continentNumber(rs.getInt("continentNumber"))
                        .build();
                countries.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPoolHelper.close(rs);
            ConnectionPoolHelper.close(pstmt);
            ConnectionPoolHelper.close(conn);
        }

        return countries;
    }
}