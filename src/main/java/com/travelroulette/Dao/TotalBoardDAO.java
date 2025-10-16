package com.travelroulette.Dao;

import com.travelroulette.Dao.QnABoard.QnAPostDao;
import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.TotalBoard.TotalBoardDto;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

public class TotalBoardDAO {

    // 각 게시판 DAO 인스턴스 생성
    private final CommunityBoardDAO communityBoardDAO = new CommunityBoardDAO();
    private final QnAPostDao qnaPostDao = new QnAPostDao();

    public List<TotalBoardDto> findAll() {
        List<TotalBoardDto> combinedList = new ArrayList<>();

        // 1. 자유게시판(보드번호 1)과 여행후기(보드번호 2) 게시글 가져오기
        // 페이지네이션 없이 모든 글을 가져오기 위해 큰 pageSize 값을 사용합니다.
        List<PostDto> communityPosts1 = communityBoardDAO.selectAllPosts(1, 1, 1000, false, null);
        List<PostDto> communityPosts2 = communityBoardDAO.selectAllPosts(2, 1, 1000, false, null);

        communityPosts1.forEach(p -> combinedList.add(TotalBoardDto.builder()
                .originalId(p.getPostNumber())
                .title(p.getPostTitle())
                .content(p.getPostDescription())
                .userId(p.getUserId())
                .createdAt(java.sql.Timestamp.valueOf(p.getPostDateWritten()))
                .boardType("자유게시판")
                .build()));

        communityPosts2.forEach(p -> combinedList.add(TotalBoardDto.builder()
                .originalId(p.getPostNumber())
                .title(p.getPostTitle())
                .content(p.getPostDescription())
                .userId(p.getUserId())
                .createdAt(java.sql.Timestamp.valueOf(p.getPostDateWritten()))
                .boardType("여행후기")
                .build()));

        // 2. 질의응답(Q&A) 게시글 가져오기 (원글만)
        List<QnABoardDto> qnaPosts = qnaPostDao.selectAllQnAPosts(1, 1000, false, null);
        qnaPosts.stream()
                .filter(q -> q.getQnaDepth() == 0) // 원글(질문)만 필터링
                .forEach(q -> combinedList.add(TotalBoardDto.builder()
                        .originalId(q.getQnaNumber())
                        .title(q.getQnaTitle())
                        .content(q.getQnaDescription())
                        .userId(q.getUserId())
                        .createdAt(java.sql.Timestamp.valueOf(q.getQnaDateWritten()))
                        .boardType("질의응답")
                        .build()));

        // 3. 모든 게시글을 최신순으로 정렬
        combinedList.sort(Comparator.comparing(TotalBoardDto::getCreatedAt).reversed());

        // 4. 정렬된 리스트에 순서대로 ID 부여
        AtomicInteger counter = new AtomicInteger(1);
        return combinedList.stream()
                .peek(dto -> dto.setId(counter.getAndIncrement()))
                .collect(Collectors.toList());
    }
}