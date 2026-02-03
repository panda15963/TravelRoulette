package com.travelroulette.Dao;

import com.travelroulette.Dao.QnABoard.QnAPostDao;
import com.travelroulette.Dto.Post.PostDto;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import com.travelroulette.Dto.TotalBoard.TotalBoardDto;
import com.travelroulette.Dto.TotalBoard.TotalBoardPageDto;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

public class TotalBoardDAO {
    private final CommunityBoardDAO communityBoardDAO = new CommunityBoardDAO();
    private final QnAPostDao qnaPostDao = new QnAPostDao();

    // ✅ 전체 게시글 조회 (LocalDateTime 사용)
    public List<TotalBoardDto> findAll() {
        List<TotalBoardDto> combinedList = new ArrayList<>();

        // 자유게시판(1), 여행후기게시판(3)
        List<PostDto> communityPosts1 = communityBoardDAO.selectAllPosts(1, 1, 1000, false, null);
        List<PostDto> communityPosts3 = communityBoardDAO.selectAllPosts(3, 1, 1000, false, null);

        // 자유게시판
        communityPosts1.forEach(p -> combinedList.add(TotalBoardDto.builder()
                .originalId(p.getPostNumber())
                .title(p.getPostTitle())
                .content(p.getPostDescription())
                .userId(p.getUserId())
                .createdAt(toDate(p.getPostDateWritten()))
                .boardType("자유게시판")
                .build()));

        // 여행후기게시판
        communityPosts3.forEach(p -> combinedList.add(TotalBoardDto.builder()
                .originalId(p.getPostNumber())
                .title(p.getPostTitle())
                .content(p.getPostDescription())
                .userId(p.getUserId())
                .createdAt(toDate(p.getPostDateWritten()))
                .boardType("여행후기게시판")
                .build()));

        // QnA 게시판 (원글만)
        List<QnABoardDto> qnaPosts = qnaPostDao.selectAllQnAPosts(1, 1000, false, null);
        qnaPosts.stream()
                .filter(q -> q.getQnaDepth() == 0)
                .forEach(q -> combinedList.add(TotalBoardDto.builder()
                        .originalId(q.getQnaNumber())
                        .title(q.getQnaTitle())
                        .content(q.getQnaDescription())
                        .userId(q.getUserId())
                        .createdAt(toDate(q.getQnaDateWritten()))
                        .boardType("질의응답")
                        .build()));

        // 최신순 정렬
        combinedList.sort(Comparator.comparing(TotalBoardDto::getCreatedAt).reversed());

        // ID 부여
        AtomicInteger counter = new AtomicInteger(1);
        return combinedList.stream()
                .peek(dto -> dto.setId(counter.getAndIncrement()))
                .collect(Collectors.toList());
    }

    // ✅ 페이지네이션 (10개씩)
    public TotalBoardPageDto findPagedPosts(int page) {
        int pageSize = 10;
        List<TotalBoardDto> allPosts = findAll();
        int totalPostCount = allPosts.size();

        int totalPages = (int) Math.ceil((double) totalPostCount / pageSize);
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages == 0 ? 1 : totalPages;

        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalPostCount);
        List<TotalBoardDto> pageList = new ArrayList<>();
        if (startIndex < totalPostCount) pageList = allPosts.subList(startIndex, endIndex);

        // 페이지 블록 계산
        int blockSize = 5;
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPages);
        boolean hasPrev = startPage > 1;
        boolean hasNext = endPage < totalPages;

        // ✅ DTO 세팅
        TotalBoardPageDto dto = new TotalBoardPageDto();
        dto.setTotalPostCount(totalPostCount);
        dto.setTotalPages(totalPages);
        dto.setCurrentPage(page);
        dto.setPosts(pageList); // ✅ 변경됨 (PostDto 변환 없이 TotalBoardDto 그대로)
        dto.setStartPage(startPage);
        dto.setEndPage(endPage);
        dto.setHasPrev(hasPrev);
        dto.setHasNext(hasNext);

        return dto;
    }

    // ✅ LocalDateTime → Date 변환 유틸리티
    private Date toDate(LocalDateTime localDateTime) {
        if (localDateTime == null) return new Date();
        return java.sql.Timestamp.valueOf(localDateTime);
    }
}