package com.travelroulette.Service.Board.Total;

import com.travelroulette.Dao.TotalBoardDAO;
import com.travelroulette.Dto.TotalBoard.TotalBoardDto;

import java.util.List;

public class TotalBoardService {
    private final TotalBoardDAO dao = new TotalBoardDAO();

    public List<TotalBoardDto> getAllBoards() {
        return dao.findAll();
    }
}