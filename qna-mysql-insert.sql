-- MySQL Schema for Q&A Board (Answer Table)

-- -----------------------------------------------------
-- Table `User` (Placeholder)
-- -----------------------------------------------------
-- Answer 테이블이 User 테이블에 외래 키를 참조하므로, User 테이블이 먼저 존재해야 합니다.
-- 실제 프로젝트의 User 테이블 스키마에 맞게 수정해주세요.
CREATE TABLE IF NOT EXISTS User (
    userId VARCHAR(20) PRIMARY KEY,
    userPassword VARCHAR(255) NOT NULL,
    userName VARCHAR(50) NOT NULL,
    userEmail VARCHAR(100)
);

-- -----------------------------------------------------
-- Table `Answer`
-- -----------------------------------------------------
-- Answer 테이블이 이미 존재한다면 삭제하여 깨끗하게 다시 생성할 수 있도록 합니다.
DROP TABLE IF EXISTS Answer;

CREATE TABLE Answer (
    qnaNumber INT PRIMARY KEY AUTO_INCREMENT,
    qnaTitle VARCHAR(300) NOT NULL,
    qnaDescription VARCHAR(3000),
    qnaDateWritten DATETIME NOT NULL,
    qnaRef INT NOT NULL,
    qnaDepth INT NOT NULL,
    qnaStep INT NOT NULL,
    userId VARCHAR(20) NOT NULL,
    FOREIGN KEY (userId) REFERENCES User(userId)
);

-- -----------------------------------------------------
-- Example Data Insertion
-- -----------------------------------------------------

-- User 테이블에 예시 데이터 삽입 (외래 키 제약 조건을 위해 필요)
INSERT INTO User (userId, userPassword, userName, userEmail) VALUES ('user_id_example', 'password123', '예시 사용자', 'user@example.com');
INSERT INTO User (userId, userPassword, userName, userEmail) VALUES ('admin_id_example', 'adminpass', '관리자', 'admin@example.com');

-- -----------------------------------------------------
-- 1. 새로운 질문 삽입 (qnaDepth = 0)
-- -----------------------------------------------------
INSERT INTO Answer (qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId)
VALUES ('첫 번째 질문입니다.', '이것은 첫 번째 질문의 상세 내용입니다. 궁금한 점을 여기에 작성하세요.', NOW(), 0, 0, 0, 'user_id_example');

-- 방금 삽입된 질문의 qnaNumber를 qnaRef로 업데이트합니다.
-- 질문글의 qnaRef는 자기 자신의 qnaNumber와 동일해야 합니다.
UPDATE Answer
SET qnaRef = LAST_INSERT_ID()
WHERE qnaNumber = LAST_INSERT_ID();

-- -----------------------------------------------------
-- 2. 기존 질문에 대한 답변 삽입 (qnaDepth = 1)
-- -----------------------------------------------------
-- 답변할 질문의 qnaNumber를 가져옵니다. (예시에서는 '첫 번째 질문입니다.' 제목의 질문을 찾습니다.)
SET @question_qna_number = (SELECT qnaNumber FROM Answer WHERE qnaTitle = '첫 번째 질문입니다.' AND qnaDepth = 0 ORDER BY qnaDateWritten DESC LIMIT 1);

-- 답변을 삽입합니다. qnaRef는 질문의 qnaNumber를 참조합니다.
-- qnaDepth는 1 (답변), qnaStep은 1 (첫 번째이자 유일한 답변)로 설정합니다.
INSERT INTO Answer (qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId)
VALUES ('RE: 첫 번째 질문입니다.', '첫 번째 질문에 대한 답변 내용입니다. 자세한 설명을 여기에 작성합니다.', NOW(), @question_qna_number, 1, 1, 'admin_id_example');

-- -----------------------------------------------------
-- 3. 두 번째 질문 삽입 및 답변 (qnaDepth = 0, 1)
-- -----------------------------------------------------
INSERT INTO Answer (qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId)
VALUES ('두 번째 질문입니다.', '이것은 두 번째 질문의 상세 내용입니다. 여행지에 대한 문의입니다.', NOW(), 0, 0, 0, 'user_id_example');

UPDATE Answer
SET qnaRef = LAST_INSERT_ID()
WHERE qnaNumber = LAST_INSERT_ID();

SET @question_qna_number_2 = (SELECT qnaNumber FROM Answer WHERE qnaTitle = '두 번째 질문입니다.' AND qnaDepth = 0 ORDER BY qnaDateWritten DESC LIMIT 1);

INSERT INTO Answer (qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId)
VALUES ('RE: 두 번째 질문입니다.', '두 번째 질문에 대한 답변입니다. 해당 여행지에 대한 정보를 제공합니다.', NOW(), @question_qna_number_2, 1, 1, 'admin_id_example');

-- -----------------------------------------------------
-- 4. 답변이 없는 질문 삽입 (qnaDepth = 0)
-- -----------------------------------------------------
INSERT INTO Answer (qnaTitle, qnaDescription, qnaDateWritten, qnaRef, qnaDepth, qnaStep, userId)
VALUES ('답변이 아직 없는 질문입니다.', '이 질문은 아직 답변이 달리지 않았습니다. 빠른 답변 부탁드립니다.', NOW(), 0, 0, 0, 'user_id_example');

UPDATE Answer
SET qnaRef = LAST_INSERT_ID()
WHERE qnaNumber = LAST_INSERT_ID();
