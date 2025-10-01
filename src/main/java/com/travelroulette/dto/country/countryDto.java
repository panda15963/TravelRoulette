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
    private String countryName;
    private String flagURL;
    private String continentId;
}
