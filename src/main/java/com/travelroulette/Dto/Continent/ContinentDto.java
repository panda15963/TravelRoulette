package com.travelroulette.Dto.Continent;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContinentDto {
    private String continentNumber;
    private String continentNameKor;
    private String continentNameEng;
}
