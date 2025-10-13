package com.travelroulette.Dto.Country;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CountryDto {
    private String countryCode;
    private String countryNameKor;
    private String countryNameEng;
    private String flagURL;
    private String continentNumber;
}
