package com.travelroulette.dto.answer;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class answerDto {
    private Integer QnQNumber;
    private String QnATitle;
    private String QnADescription;
    
    private LocalDateTime QnADateWritten;
    private Integer QnAref;
    private Integer QnADepth;
    private Integer QnAStep;

    private String userId;
    
}