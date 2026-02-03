package com.travelroulette.Service.Board.Total;

import com.travelroulette.Dao.TotalBoardDAO;
import com.travelroulette.Dto.TotalBoard.TotalBoardDto;
import com.travelroulette.Dto.TotalBoard.TotalBoardPageDto;
import java.util.List;

public class TotalBoardService {

    private final TotalBoardDAO totalBoardDAO = new TotalBoardDAO();

    // ✅ 전체 게시글 조회
    public List<TotalBoardDto> getAllBoards() {
        return totalBoardDAO.findAll();
    }

    // ✅ 페이지네이션된 게시글 조회
    public TotalBoardPageDto getPagedPosts(int page) {
        return totalBoardDAO.findPagedPosts(page);
    }
}