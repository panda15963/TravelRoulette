package com.travelroulette.Dto.TotalBoard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TotalBoardDto {
    private Integer id;              // postNumber 또는 QnANumber
    private String title;            // postTitle 또는 QnATitle
    private String content;          // postDescription 또는 QnADescription
    private String userId;           // 작성자 ID
    private LocalDateTime createdAt; // 작성일
    private String boardType;        // "자유게시판" or "질의응답"
}