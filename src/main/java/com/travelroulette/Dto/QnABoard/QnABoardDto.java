package com.travelroulette.Dto.QnABoard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QnABoardDto {
    private Integer qnaNumber;
    private String qnaTitle;
    private String qnaDescription;

    private LocalDateTime qnaDateWritten;
    private Integer qnaRef;
    private Integer qnaDepth;
    private Integer qnaStep;

    private String userId;

}