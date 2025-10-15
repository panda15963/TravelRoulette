package com.travelroulette.Dto.QnABoard;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class
QnABoardDetailDto {
    private QnABoardDto post;
    private QnABoardDto answer;
}
