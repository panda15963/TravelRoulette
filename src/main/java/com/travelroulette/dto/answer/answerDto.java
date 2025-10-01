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
    private String userId;
    private String answerDescription;
    private LocalDateTime dateWritten;
    private Integer postNumber;
}
