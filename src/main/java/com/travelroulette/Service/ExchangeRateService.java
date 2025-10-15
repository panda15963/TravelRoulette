package com.travelroulette.Service;

import com.travelroulette.Dao.CountryDAO;
import com.travelroulette.Dto.Country.CountryDto;

import java.util.List;

public class ExchangeRateService {

    private final CountryDAO countryDAO;

    public ExchangeRateService() {
        this.countryDAO = new CountryDAO();
    }

    //전체 국가 조회
    public List<CountryDto> getAllCountries() {
        return countryDAO.getAllCountries(); // CountryDAO에 finally 방식으로 추가한 메서드 사용
    }
    
    //대륙별 국가 조회
    public List<CountryDto> getCountriesByContinent(int continentNumber) {
        return countryDAO.getCountriesByContinent(continentNumber);
    }
}
