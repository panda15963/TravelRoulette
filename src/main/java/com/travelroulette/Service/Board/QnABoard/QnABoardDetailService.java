package com.travelroulette.Service.Board.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAAnswerDao;
import com.travelroulette.Dao.QnABoard.QnAPostDao;
import com.travelroulette.Dto.QnABoard.QnABoardDetailDto;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class QnABoardDetailService {

    public QnABoardDetailDto execute(HttpServletRequest request, HttpServletResponse response) {

        String qnaNumberStr = request.getParameter("qnaNumber");
        int qnaNumber = Integer.parseInt(qnaNumberStr);

        QnAPostDao postDao = new QnAPostDao();
        QnABoardDto post = postDao.selectOneQnAPost(qnaNumber);

        QnAAnswerDao answerDao = new QnAAnswerDao();
        QnABoardDto answer = answerDao.selectAnswerByRef(qnaNumber);

        QnABoardDetailDto detailDto = new QnABoardDetailDto(post, answer);

        return detailDto;
    }
}
