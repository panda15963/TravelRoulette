package com.travelroulette.dto.continent;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class continentDto {
    private String continentNumber;
    private String continentNameKor;
    private String continentNameEng;
}
