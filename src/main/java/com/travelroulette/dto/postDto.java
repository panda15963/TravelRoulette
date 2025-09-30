package com.travelroulette.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class postDto {
    private Integer id;
    private Integer board_id;
    private Integer user_id;
    private String title;
    private String content;
}
