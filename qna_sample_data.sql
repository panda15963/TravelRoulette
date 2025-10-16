-- ======================================================
-- QnA Board (Answer Table) Sample Data
-- ======================================================

-- To avoid conflicts, it's recommended to clear the table first.
-- This will delete all existing Q&A posts and answers.
DELETE FROM Answer;

-- Reset the auto-increment counter to start from 1
ALTER TABLE Answer AUTO_INCREMENT = 1;

-- ------------------------------------------------------
-- Sample Questions (qnaDepth = 0)
-- For questions, qnaRef should be the same as qnaNumber.
-- ------------------------------------------------------

INSERT INTO Answer (qnaNumber, qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId)
VALUES
(1, '프랑스 파리 여행 질문입니다!', '파리에서 3일 동안 머무는데, 꼭 가봐야 할 곳 추천해주세요. 루브르 박물관은 꼭 갈 예정입니다.', NOW() - INTERVAL 10 DAY, 1, 0, 0, 'ryeol3'),
(2, '일본 도쿄 교통패스 질문', '도쿄 여행 일주일 예정인데, 스이카, 파스모, JR패스 중에 어떤게 가장 효율적일까요? 주로 시내 위주로 다닐 것 같아요.', NOW() - INTERVAL 9 DAY, 2, 0, 0, 'dohee'),
(3, '미국 서부 렌트카 여행 팁 있을까요?', 'LA에서 출발해서 샌프란시스코까지 1번 국도 타고 올라가려고 합니다. 운전 시간이나 중간에 들를만한 곳 조언 부탁드립니다.', NOW() - INTERVAL 8 DAY, 3, 0, 0, 'seong'),
(4, '태국 방콕 숙소 위치 고민', '방콕에 처음 가보는데, 숙소를 카오산로드 근처로 잡는게 좋을까요, 아니면 스쿰빗 지역이 나을까요? 20대이고 밤에 노는 것도 좋아합니다.', NOW() - INTERVAL 7 DAY, 4, 0, 0, 'ryeol3'),
(5, '이탈리아 남부 여행 문의', '로마, 피렌체는 가봤는데 남부 쪽은 처음입니다. 포지타노, 아말피 이쪽 교통편이 많이 안좋다고 들었는데 사실인가요? 뚜벅이 여행자입니다.', NOW() - INTERVAL 6 DAY, 5, 0, 0, 'admin'),
(6, '겨울에 가기 좋은 따뜻한 나라 추천해주세요', '12월에 연차를 길게 쓸 수 있을 것 같은데, 너무 춥지 않고 물가도 저렴한 곳으로 추천 부탁드립니다. 휴양 목적입니다!', NOW() - INTERVAL 5 DAY, 6, 0, 0, 'dohee'),
(7, '스위스 융프라우 날씨 관련', '8월 초에 융프라우 올라갈 계획인데, 반팔만 챙겨가도 괜찮을까요? 아니면 경량패딩 같은 외투가 필수일까요?', NOW() - INTERVAL 4 DAY, 7, 0, 0, 'seong'),
(8, '혼자 떠나는 첫 해외여행, 어디가 좋을까요?', '영어는 기본적인 소통만 가능하고, 치안이 좋은 곳이었으면 좋겠습니다. 예산은 150만원 내외로 생각하고 있습니다.', NOW() - INTERVAL 3 DAY, 8, 0, 0, 'guest1'),
(9, '제주도 2박 3일 코스 추천', '부모님 모시고 가는 가족여행입니다. 너무 빡빡하지 않으면서 경치 좋은 곳들 위주로 코스 추천 부탁드려요. 운전은 제가 합니다.', NOW() - INTERVAL 2 DAY, 9, 0, 0, 'ryeol3'),
(10, '유럽 여행 시 유심 vs 이심(eSIM)', '한 달 동안 유럽 5개국 정도 돌아다닐 예정인데, 유심을 계속 갈아끼우는게 나을지, 아니면 이심을 쓰는게 나을지 고민입니다. 써보신 분들 후기 궁금해요.', NOW() - INTERVAL 1 DAY, 10, 0, 0, 'admin');


-- ------------------------------------------------------
-- Sample Answers (qnaDepth = 1)
-- qnaRef points to the qnaNumber of the question.
-- qnaNumber for answers starts after the last question number.
-- ------------------------------------------------------

INSERT INTO Answer (qnaNumber, qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId)
VALUES
(11, 'Re: 프랑스 파리 여행 질문입니다!', '루브르 외에도 오르세 미술관, 몽마르뜨 언덕, 그리고 저녁에 하는 바토무슈 유람선 투어를 추천합니다! 3일이면 충분히 즐기실 수 있어요.', NOW() - INTERVAL 9 DAY, 1, 1, 0, 'admin'),
(12, 'Re: 일본 도쿄 교통패스 질문', '시내 위주라면 스이카나 파스모 같은 충전식 카드가 편리합니다. JR패스는 장거리 이동이 많을 때 유리해요. 도쿄 메트로 패스도 고려해보세요!', NOW() - INTERVAL 8 DAY, 2, 1, 0, 'seong'),
(13, 'Re: 태국 방콕 숙소 위치 고민', '활동적인 것 좋아하시면 카오산로드 근처가 재밌고, 쇼핑이나 세련된 루프탑 바를 원하시면 스쿰빗이 더 나을 수 있습니다. 첫 여행이시면 두 군데에 나눠서 묵어보는 것도 방법이에요!', NOW() - INTERVAL 6 DAY, 4, 1, 0, 'dohee'),
(14, 'Re: 겨울에 가기 좋은 따뜻한 나라 추천해주세요', '베트남 다낭이나 나트랑, 태국 치앙마이 추천합니다. 물가 저렴하고 맛있는 음식도 많아서 휴양하기에 딱 좋아요.', NOW() - INTERVAL 4 DAY, 6, 1, 0, 'admin'),
(15, 'Re: 스위스 융프라우 날씨 관련', '무조건 외투 챙기셔야 합니다! 8월이라도 정상은 매우 춥고 바람도 많이 붑니다. 경량패딩이나 바람막이 필수입니다.', NOW() - INTERVAL 3 DAY, 7, 1, 0, 'ryeol3');


-- You can add more data following the pattern above.
-- Make sure qnaNumber is unique and qnaRef correctly points to a question for answers.

