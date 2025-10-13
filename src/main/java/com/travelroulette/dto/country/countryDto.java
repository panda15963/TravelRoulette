package com.travelroulette.dto.country;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class countryDto {
    private String countryCode;
    private String countryNameKor;
    private String countryNameEng;
    private String flagURL;
    private String continentNumber;
}
