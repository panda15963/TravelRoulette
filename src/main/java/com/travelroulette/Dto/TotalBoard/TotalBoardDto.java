package com.travelroulette.Dto.TotalBoard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TotalBoardDto {
    private int id; // 통합 ID (ROW_NUMBER)
    private int originalId; // 원본 게시글 ID (postNumber 또는 qnaNumber)
    private String title;
    private String content;
    private String userId;
    private Date createdAt;
    private String boardType; // 게시판 종류 (자유게시판, 질의응답 등)
}