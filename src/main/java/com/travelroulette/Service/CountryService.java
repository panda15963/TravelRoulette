package com.travelroulette.Service;

import com.travelroulette.Dao.CountryDAO;
import com.travelroulette.Dto.Country.CountryDto;

import java.util.List;

public class CountryService {
    private final CountryDAO dao = new CountryDAO();

    public List<CountryDto> getCountriesByContinent(int continentNumber) {
        return dao.getCountriesByContinent(continentNumber);
    }
}