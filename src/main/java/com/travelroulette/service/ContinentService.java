package com.travelroulette.Service;

import com.travelroulette.Dao.ContinentDAO;
import com.travelroulette.Dto.Continent.ContinentDto;

import java.util.List;

public class ContinentService {
    private final ContinentDAO continentDAO;

    public ContinentService() {
        this.continentDAO = new ContinentDAO();
    }

    public List<ContinentDto> getAllContinents() {
        // 이곳에서 추후 로직(필터링, 정렬 등)을 추가 가능
        return continentDAO.findAll();
    }
}