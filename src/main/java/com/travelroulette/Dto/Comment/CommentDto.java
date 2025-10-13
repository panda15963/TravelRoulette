package com.travelroulette.Dto.Comment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CommentDto {
    private Integer commentNumber;
    private String commentDescription;
    private LocalDateTime dateWritten;
    private String userId;
    private Integer postNumber;
}
