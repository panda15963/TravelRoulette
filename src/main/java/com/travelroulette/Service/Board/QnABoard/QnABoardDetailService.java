package com.travelroulette.Service.Board.QnABoard;

import com.travelroulette.Dao.QnABoard.QnAAnswerDao;
import com.travelroulette.Dao.QnABoard.QnAPostDao;
import com.travelroulette.Dto.QnABoard.QnABoardDetailDto;
import com.travelroulette.Dto.QnABoard.QnABoardDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class QnABoardDetailService {

    public QnABoardDetailDto execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            String qnaNumberStr = request.getParameter("qnaNumber");
            System.out.println("🔍 QnABoardDetailService - qnaNumber 파라미터: '" + qnaNumberStr + "'");
            System.out.println("🔍 요청 URI: " + request.getRequestURI());
            System.out.println("🔍 쿼리 스트링: " + request.getQueryString());

            if (qnaNumberStr == null || qnaNumberStr.trim().isEmpty()) {
                System.out.println("❌ qnaNumber 파라미터가 없거나 비어있습니다.");
                // qnaNumber 파라미터가 없는 경우, 비어있는 DTO 반환
                return new QnABoardDetailDto(null, null);
            }
            int qnaNumber = Integer.parseInt(qnaNumberStr);
            System.out.println("✅ qnaNumber 파싱 성공: " + qnaNumber);

            QnAPostDao postDao = new QnAPostDao();
            QnABoardDto post = postDao.selectOneQnAPost(qnaNumber);

            if (post != null) {
                System.out.println("✅ 게시글 조회 성공 - qnaNumber: " + qnaNumber + ", 제목: " + post.getQnaTitle());
            } else {
                System.out.println("❌ 게시글을 찾을 수 없습니다 - qnaNumber: " + qnaNumber);
            }

            QnAAnswerDao answerDao = new QnAAnswerDao();
            QnABoardDto answer = null;
            if (post != null) { // 질문 게시물이 존재할 때만 답변을 찾음
                 answer = answerDao.selectAnswerByRef(post.getQnaNumber());
                 if (answer != null) {
                     System.out.println("✅ 답글 조회 성공");
                 } else {
                     System.out.println("ℹ️ 답글이 없습니다.");
                 }
            }

            return new QnABoardDetailDto(post, answer);

        } catch (NumberFormatException e) {
            System.out.println("❌ 잘못된 qnaNumber 파라미터입니다: " + request.getParameter("qnaNumber"));
            e.printStackTrace();
            // 숫자 변환 실패 시, 비어있는 DTO 반환
            return new QnABoardDetailDto(null, null);
        } catch (Exception e) {
            System.out.println("❌ QnABoardDetailService에서 예외 발생");
            e.printStackTrace();
            // 그 외 모든 예외 발생 시, 비어있는 DTO를 반환하여 500 에러 방지
            return new QnABoardDetailDto(null, null);
        }
    }
}
