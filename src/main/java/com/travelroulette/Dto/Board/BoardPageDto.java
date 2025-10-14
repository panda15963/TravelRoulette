package com.travelroulette.Dto.Board;

import com.travelroulette.Dto.Post.PostDto;
import lombok.*;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BoardPageDto {
    private int totalPostCount; //전체 게시글 수
    private int totalPages; //전체 페이지 수
    private int currentPage; //현재 페이지 번호
    private List<PostDto> posts; //현재 페이지에 보여줄 게시글 목록

    private int startPage; //화면에 보여줄 페이지 번호 블록의 시작 번호
    private int endPage; //화면에 보여줄 페이지 번호 블록의 끝 번호
    private boolean hasPrev; //이전 버튼 활성화 여부
    private boolean hasNext; //다음 버튼 활성화 여부

    private String searchKeyword; //검색어
}