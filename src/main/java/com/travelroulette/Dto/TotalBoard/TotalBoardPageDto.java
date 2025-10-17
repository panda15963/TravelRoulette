package com.travelroulette.Dto.TotalBoard;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TotalBoardPageDto {
    private int totalPostCount;   // 전체 게시글 수
    private int totalPages;       // 전체 페이지 수
    private int currentPage;      // 현재 페이지 번호
    private List<TotalBoardDto> posts;

    private int startPage;        // 화면에 보여줄 페이지 블록 시작 번호
    private int endPage;          // 화면에 보여줄 페이지 블록 끝 번호
    private boolean hasPrev;      // 이전 버튼 활성화 여부
    private boolean hasNext;      // 다음 버튼 활성화 여부
}