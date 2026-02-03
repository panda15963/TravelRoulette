package com.travelroulette.Dto.Listofcountries;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ListOfCountriesDto {
    private String countryCode;
    private String userId;
    private String ContinentNumber;
    private String checkContWishList;
}