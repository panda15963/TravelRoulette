-- =====================================================================================
-- TravelRoulette Complete Database Initialization Script
-- =====================================================================================
-- 사용법: mysql -u kosa -p1004 kosa_db < sql/init_database.sql
-- 이 스크립트 하나로 전체 데이터베이스를 초기화하고 목업 데이터를 적재합니다.
-- =====================================================================================

SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- =====================================================================================
-- 1. 기존 테이블 삭제
-- =====================================================================================

DROP TABLE IF EXISTS `comment`;
DROP TABLE IF EXISTS `post`;
DROP TABLE IF EXISTS `board`;
DROP TABLE IF EXISTS `kanban`;
DROP TABLE IF EXISTS `list_of_countries`;
DROP TABLE IF EXISTS `country`;
DROP TABLE IF EXISTS `continent`;
DROP TABLE IF EXISTS `Answer`;
DROP TABLE IF EXISTS `User`;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================================================
-- 2. 테이블 생성
-- =====================================================================================

-- User 테이블
CREATE TABLE IF NOT EXISTS `User` (
  `userId` VARCHAR(20) NOT NULL,
  `pwd` VARCHAR(255) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `gender` VARCHAR(10) NULL,
  `salt` VARCHAR(64) NOT NULL,
  `hashIterations` INT NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `uk_user_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Continent 테이블
CREATE TABLE IF NOT EXISTS `Continent` (
  `continentNumber` INT NOT NULL,
  `continentNameKor` VARCHAR(45) NOT NULL,
  `continentNameEng` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`continentNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Country 테이블
CREATE TABLE IF NOT EXISTS `Country` (
  `countryCode` VARCHAR(10) NOT NULL,
  `countryNameKor` VARCHAR(100) NOT NULL,
  `countryNameEng` VARCHAR(100) NOT NULL,
  `flagURL` VARCHAR(255) NOT NULL,
  `continentNumber` INT NOT NULL,
  `currency` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`countryCode`),
  KEY `idx_country_continent` (`continentNumber`),
  CONSTRAINT `fk_country_continent`
    FOREIGN KEY (`continentNumber`) REFERENCES `Continent` (`continentNumber`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- list_of_countries 테이블 (Wishlist)
CREATE TABLE IF NOT EXISTS `list_of_countries` (
  `countryCode` VARCHAR(10) NOT NULL,
  `userId` VARCHAR(20) NOT NULL,
  `checkContWishList` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`countryCode`, `userId`),
  CONSTRAINT `fk_list_country`
    FOREIGN KEY (`countryCode`) REFERENCES `Country` (`countryCode`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_list_user`
    FOREIGN KEY (`userId`) REFERENCES `User` (`userId`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Board 테이블
CREATE TABLE IF NOT EXISTS `board` (
  `boardNumber` INT NOT NULL AUTO_INCREMENT,
  `boardName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`boardNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Post 테이블
CREATE TABLE IF NOT EXISTS `post` (
  `postNumber` INT NOT NULL AUTO_INCREMENT,
  `postTitle` VARCHAR(255) NOT NULL,
  `postDescription` MEDIUMTEXT NOT NULL,
  `postDateWritten` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `boardNumber` INT NOT NULL,
  `userId` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`postNumber`),
  KEY `idx_post_board` (`boardNumber`),
  KEY `idx_post_user` (`userId`),
  CONSTRAINT `fk_post_board`
    FOREIGN KEY (`boardNumber`) REFERENCES `board` (`boardNumber`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_post_user`
    FOREIGN KEY (`userId`) REFERENCES `User` (`userId`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Comment 테이블
CREATE TABLE IF NOT EXISTS `comment` (
  `commentNumber` INT NOT NULL AUTO_INCREMENT,
  `commentDescription` VARCHAR(1000) NOT NULL,
  `commentDateWritten` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `userId` VARCHAR(20) NOT NULL,
  `postNumber` INT NOT NULL,
  PRIMARY KEY (`commentNumber`),
  KEY `idx_comment_user` (`userId`),
  KEY `idx_comment_post` (`postNumber`),
  CONSTRAINT `fk_comment_user`
    FOREIGN KEY (`userId`) REFERENCES `User` (`userId`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_post`
    FOREIGN KEY (`postNumber`) REFERENCES `post` (`postNumber`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Kanban 테이블
CREATE TABLE IF NOT EXISTS `kanban` (
  `taskId` INT NOT NULL AUTO_INCREMENT,
  `userId` VARCHAR(20) NOT NULL,
  `taskDescription` VARCHAR(500) NOT NULL,
  `taskStatus` ENUM('todo', 'inprogress', 'done') NOT NULL,
  `taskOrder` INT NOT NULL,
  `priority` ENUM('high', 'medium', 'low') DEFAULT 'medium',
  `dueDate` DATETIME NULL,
  `createdDate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`taskId`),
  KEY `idx_kanban_user_status` (`userId`, `taskStatus`),
  CONSTRAINT `fk_kanban_user`
    FOREIGN KEY (`userId`) REFERENCES `User` (`userId`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Answer 테이블 (Q&A Board)
CREATE TABLE IF NOT EXISTS `Answer` (
  `qnaNumber` INT NOT NULL AUTO_INCREMENT,
  `qnaTitle` VARCHAR(300) NOT NULL,
  `qnaDescription` VARCHAR(3000) NULL,
  `qnaDateWritten` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `qnaRef` INT NOT NULL,
  `qnaDepth` INT NOT NULL,
  `qnaStep` INT NOT NULL DEFAULT 0,
  `userId` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`qnaNumber`),
  KEY `idx_answer_ref_depth` (`qnaRef`, `qnaDepth`),
  CONSTRAINT `fk_answer_user`
    FOREIGN KEY (`userId`) REFERENCES `User` (`userId`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================================================
-- 3. 사용자 데이터 삽입 (비밀번호: 1234, PBKDF2 해시 적용)
-- =====================================================================================

INSERT INTO `User` (`userId`, `pwd`, `email`, `gender`, `salt`, `hashIterations`) VALUES
('msa1', 'c915d170cd8d53f898d846c5af29674e2924f88f850e1e9b651c7a4082a75ccb', 'msa1@msa.com', 'male', '70ceff70399dbe3b47a42f4b1d62853e017f9ba4525dfe9ac654b3ffddf9b6f4', 120000),
('msa2', '0e8175542825e5f0c8e9a777eb33feee3b35318eb39bf63bb610ef0bc41aaf53', 'msa2@msa.com', 'female', 'b3238a99c82530d0cb822629dc989c0bb016e49c4d076c9f5b5823302c5ecdc9', 120000),
('msa3', '5b74fee06c6c0adb3b3a36cfa939de3c01f47e9e61d0893ccf91401a27a72e83', 'msa3@msa.com', 'male', '76881d705aecd8fa3b03cf32da27427cf950d0d7822e3306be10cbdc117064f5', 120000),
('msa4', '61e87b2bbb8af8ea6aa181de23ce73d2467286642495ffbdf502ba87690f2e43', 'msa4@msa.com', 'female', 'cc928edff3214c34930f570ae16f0b1914e4101e95bfaf587a1d2185b5bee01e', 120000),
('msa5', '1f72db8716a0eea876b6c7618a2b288e77a6893f2c2c9c8d5352581f44f974d5', 'msa5@msa.com', 'male', '489bc9c1954bb774f5a387737e3ed58c94f1148570074ab47bbac0968ccdd4a2', 120000),
('msa6', 'b9a6b323d7794b4c5c062d88c6f1a9750856563f474d3ca2f798972d7e051a77', 'msa6@msa.com', 'female', 'c2449e96991f4b749f41fc9976386c557eb9a8089f020aabd802ffd0ad7f8377', 120000);

-- =====================================================================================
-- 4. 대륙 데이터 삽입
-- =====================================================================================

INSERT INTO `Continent` (`continentNumber`, `continentNameKor`, `continentNameEng`) VALUES
(1, '아시아', 'Asia'),
(2, '유럽', 'Europe'),
(3, '아프리카', 'Africa'),
(4, '북아메리카', 'NorthAmerica'),
(5, '남아메리카', 'SouthAmerica'),
(6, '오세아니아', 'Oceania');

-- =====================================================================================
-- 5. 국가 데이터 삽입 (기존 country.sql 내용 그대로)
-- =====================================================================================
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AD', 2, '안도라', 'Andorra', 'https://flagcdn.com/w40/ad.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AE', 1, '아랍에미리트', 'United Arab Emirates', 'https://flagcdn.com/w40/ae.png', 'AED');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AF', 1, '아프가니스탄', 'Afghanistan', 'https://flagcdn.com/w40/af.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AG', 4, '앤티가 바부다', 'Antigua and Barbuda', 'https://flagcdn.com/w40/ag.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AI', 4, '앵귈라', 'Anguilla', 'https://flagcdn.com/w40/ai.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AL', 2, '알바니아', 'Albania', 'https://flagcdn.com/w40/al.png', 'ALL');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AM', 1, '아르메니아', 'Armenia', 'https://flagcdn.com/w40/am.png', 'AMD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AO', 3, '앙골라', 'Angola', 'https://flagcdn.com/w40/ao.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AQ', 6, '남극', 'Antarctica', 'https://flagcdn.com/w40/aq.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AR', 5, '아르헨티나', 'Argentina', 'https://flagcdn.com/w40/ar.png', 'ARS');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AS', 6, '아메리칸 사모아', 'American Samoa', 'https://flagcdn.com/w40/as.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AT', 2, '오스트리아', 'Austria', 'https://flagcdn.com/w40/at.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AU', 6, '호주', 'Australia', 'https://flagcdn.com/w40/au.png', 'AUD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AW', 4, '아루바', 'Aruba', 'https://flagcdn.com/w40/aw.png', 'AWG');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AX', 2, '올란드 제도', 'Åland Islands', 'https://flagcdn.com/w40/ax.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('AZ', 1, '아제르바이잔', 'Azerbaijan', 'https://flagcdn.com/w40/az.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BA', 2, '보스니아 헤르체고비나', 'Bosnia and Herzegovina', 'https://flagcdn.com/w40/ba.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BB', 4, '바베이도스', 'Barbados', 'https://flagcdn.com/w40/bb.png', 'BBD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BD', 1, '방글라데시', 'Bangladesh', 'https://flagcdn.com/w40/bd.png', 'BDT');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BE', 2, '벨기에', 'Belgium', 'https://flagcdn.com/w40/be.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BF', 3, '부르키나파소', 'Burkina Faso', 'https://flagcdn.com/w40/bf.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BG', 2, '불가리아', 'Bulgaria', 'https://flagcdn.com/w40/bg.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BH', 1, '바레인', 'Bahrain', 'https://flagcdn.com/w40/bh.png', 'BHD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BI', 3, '부룬디', 'Burundi', 'https://flagcdn.com/w40/bi.png', 'BIF');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BJ', 3, '베냉', 'Benin', 'https://flagcdn.com/w40/bj.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BL', 4, '생바르텔레미', 'Saint Barthélemy', 'https://flagcdn.com/w40/bl.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BM', 4, '버뮤다', 'Bermuda', 'https://flagcdn.com/w40/bm.png', 'BMD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BN', 1, '브루나이', 'Brunei Darussalam', 'https://flagcdn.com/w40/bn.png', 'BND');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BO', 5, '볼리비아', 'Plurinational State of', 'https://flagcdn.com/w40/bo.png', 'BOB');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BQ', 6, '신트외스타티우스 사바', 'Sint Eustatius and Saba', 'https://flagcdn.com/w40/bq.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BR', 5, '브라질', 'Brazil', 'https://flagcdn.com/w40/br.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BS', 4, '바하마', 'Bahamas', 'https://flagcdn.com/w40/bs.png', 'BSD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BT', 1, '부탄', 'Bhutan', 'https://flagcdn.com/w40/bt.png', 'BTN');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BV', 6, '부베 섬', 'Bouvet Island', 'https://flagcdn.com/w40/bv.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BW', 3, '보츠와나', 'Botswana', 'https://flagcdn.com/w40/bw.png', 'BWP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BY', 2, '벨라루스', 'Belarus', 'https://flagcdn.com/w40/by.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('BZ', 4, '벨리즈', 'Belize', 'https://flagcdn.com/w40/bz.png', 'BZD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CA', 4, '캐나다', 'Canada', 'https://flagcdn.com/w40/ca.png', 'CAD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CC', 6, '코코스(킬링) 제도', 'Cocos (Keeling) Islands', 'https://flagcdn.com/w40/cc.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CD', 3, '콩고민주공화국', 'The Democratic Republic of the', 'https://flagcdn.com/w40/cd.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CF', 3, '중앙아프리카공화국', 'Central African Republic', 'https://flagcdn.com/w40/cf.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CG', 3, '콩고공화국', 'Congo', 'https://flagcdn.com/w40/cg.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CH', 2, '스위스', 'Switzerland', 'https://flagcdn.com/w40/ch.png', 'CHF');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CI', 3, '코트디부아르', 'Côte d\'Ivoire', 'https://flagcdn.com/w40/ci.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CK', 6, '쿡 제도', 'Cook Islands', 'https://flagcdn.com/w40/ck.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CL', 5, '칠레', 'Chile', 'https://flagcdn.com/w40/cl.png', 'CLP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CM', 3, '카메룬', 'Cameroon', 'https://flagcdn.com/w40/cm.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CN', 1, '중국', 'China', 'https://flagcdn.com/w40/cn.png', 'CNY');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CO', 5, '콜롬비아', 'Colombia', 'https://flagcdn.com/w40/co.png', 'COP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CR', 4, '코스타리카', 'Costa Rica', 'https://flagcdn.com/w40/cr.png', 'CRC');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CU', 4, '쿠바', 'Cuba', 'https://flagcdn.com/w40/cu.png', 'CUP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CV', 3, '카보베르데', 'Cabo Verde', 'https://flagcdn.com/w40/cv.png', 'CVE');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CW', 4, '퀴라소', 'Curaçao', 'https://flagcdn.com/w40/cw.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CX', 1, '크리스마스 섬', 'Christmas Island', 'https://flagcdn.com/w40/cx.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CY', 2, '키프로스', 'Cyprus', 'https://flagcdn.com/w40/cy.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('CZ', 2, '체코', 'Czechia', 'https://flagcdn.com/w40/cz.png', 'CZK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('DE', 2, '독일', 'Germany', 'https://flagcdn.com/w40/de.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('DJ', 3, '지부티', 'Djibouti', 'https://flagcdn.com/w40/dj.png', 'DJF');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('DK', 2, '덴마크', 'Denmark', 'https://flagcdn.com/w40/dk.png', 'DKK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('DM', 4, '도미니카연방', 'Dominica', 'https://flagcdn.com/w40/dm.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('DO', 4, '도미니카공화국', 'Dominican Republic', 'https://flagcdn.com/w40/do.png', 'DOP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('DZ', 3, '알제리', 'Algeria', 'https://flagcdn.com/w40/dz.png', 'DZD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('EC', 5, '에콰도르', 'Ecuador', 'https://flagcdn.com/w40/ec.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('EE', 2, '에스토니아', 'Estonia', 'https://flagcdn.com/w40/ee.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('EG', 3, '이집트', 'Egypt', 'https://flagcdn.com/w40/eg.png', 'EGP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('EH', 3, '서사하라', 'Western Sahara', 'https://flagcdn.com/w40/eh.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ER', 3, '에리트레아', 'Eritrea', 'https://flagcdn.com/w40/er.png', 'ERN');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ES', 2, '스페인', 'Spain', 'https://flagcdn.com/w40/es.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ET', 3, '에티오피아', 'Ethiopia', 'https://flagcdn.com/w40/et.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('FI', 2, '핀란드', 'Finland', 'https://flagcdn.com/w40/fi.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('FJ', 6, '피지', 'Fiji', 'https://flagcdn.com/w40/fj.png', 'FJD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('FK', 6, '포클랜드 제도', 'Falkland Islands (Malvinas)', 'https://flagcdn.com/w40/fk.png', 'FKP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('FM', 6, '미크로네시아', 'Federated States of', 'https://flagcdn.com/w40/fm.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('FO', 6, '페로 제도', 'Faroe Islands', 'https://flagcdn.com/w40/fo.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('FR', 2, '프랑스', 'France', 'https://flagcdn.com/w40/fr.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GA', 3, '가봉', 'Gabon', 'https://flagcdn.com/w40/ga.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GB', 2, '영국', 'United Kingdom', 'https://flagcdn.com/w40/gb.png', 'GBP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GD', 4, '그레나다', 'Grenada', 'https://flagcdn.com/w40/gd.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GE', 1, '조지아', 'Georgia', 'https://flagcdn.com/w40/ge.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GF', 5, '프랑스령 기아나', 'French Guiana', 'https://flagcdn.com/w40/gf.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GG', 2, '건지', 'Guernsey', 'https://flagcdn.com/w40/gg.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GH', 3, '가나', 'Ghana', 'https://flagcdn.com/w40/gh.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GI', 2, '지브롤터', 'Gibraltar', 'https://flagcdn.com/w40/gi.png', 'GIP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GL', 4, '그린란드', 'Greenland', 'https://flagcdn.com/w40/gl.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GM', 3, '감비아', 'Gambia', 'https://flagcdn.com/w40/gm.png', 'GMD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GN', 3, '기니', 'Guinea', 'https://flagcdn.com/w40/gn.png', 'GNF');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GP', 4, '과들루프', 'Guadeloupe', 'https://flagcdn.com/w40/gp.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GQ', 3, '적도기니', 'Equatorial Guinea', 'https://flagcdn.com/w40/gq.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GR', 2, '그리스', 'Greece', 'https://flagcdn.com/w40/gr.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GS', 6, '사우스조지아 사우스샌드위치 제도', 'South Georgia and the South Sandwich Islands', 'https://flagcdn.com/w40/gs.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GT', 4, '과테말라', 'Guatemala', 'https://flagcdn.com/w40/gt.png', 'GTQ');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GU', 6, '괌', 'Guam', 'https://flagcdn.com/w40/gu.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GW', 6, '기니비사우', 'Guinea-Bissau', 'https://flagcdn.com/w40/gw.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('GY', 5, '가이아나', 'Guyana', 'https://flagcdn.com/w40/gy.png', 'GYD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('HK', 1, '홍콩', 'Hong Kong', 'https://flagcdn.com/w40/hk.png', 'HKD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('HM', 6, '허드 맥도널드 제도', 'Heard Island and McDonald Islands', 'https://flagcdn.com/w40/hm.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('HN', 4, '온두라스', 'Honduras', 'https://flagcdn.com/w40/hn.png', 'HNL');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('HR', 2, '크로아티아', 'Croatia', 'https://flagcdn.com/w40/hr.png', 'HRK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('HT', 4, '아이티', 'Haiti', 'https://flagcdn.com/w40/ht.png', 'HTG');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('HU', 2, '헝가리', 'Hungary', 'https://flagcdn.com/w40/hu.png', 'HUF');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ID', 1, '인도네시아', 'Indonesia', 'https://flagcdn.com/w40/id.png', 'IDR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IE', 2, '아일랜드', 'Ireland', 'https://flagcdn.com/w40/ie.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IL', 1, '이스라엘', 'Israel', 'https://flagcdn.com/w40/il.png', 'ILS');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IM', 2, '맨섬', 'Isle of Man', 'https://flagcdn.com/w40/im.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IN', 1, '인도', 'India', 'https://flagcdn.com/w40/in.png', 'INR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IO', 1, '영국령 인도양 지역', 'British Indian Ocean Territory', 'https://flagcdn.com/w40/io.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IQ', 1, '이라크', 'Iraq', 'https://flagcdn.com/w40/iq.png', 'IQD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IR', 1, '이란', 'Islamic Republic of', 'https://flagcdn.com/w40/ir.png', 'IRR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IS', 2, '아이슬란드', 'Iceland', 'https://flagcdn.com/w40/is.png', 'ISK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('IT', 2, '이탈리아', 'Italy', 'https://flagcdn.com/w40/it.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('JE', 2, '저지 섬', 'Jersey', 'https://flagcdn.com/w40/je.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('JM', 4, '자메이카', 'Jamaica', 'https://flagcdn.com/w40/jm.png', 'JMD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('JO', 1, '요르단', 'Jordan', 'https://flagcdn.com/w40/jo.png', 'JOD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('JP', 1, '일본', 'Japan', 'https://flagcdn.com/w40/jp.png', 'JPY');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KE', 3, '케냐', 'Kenya', 'https://flagcdn.com/w40/ke.png', 'KES');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KG', 1, '키르기스스탄', 'Kyrgyzstan', 'https://flagcdn.com/w40/kg.png', 'KGS');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KH', 1, '캄보디아', 'Cambodia', 'https://flagcdn.com/w40/kh.png', 'KHR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KI', 6, '키리바시', 'Kiribati', 'https://flagcdn.com/w40/ki.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KM', 3, '코모로', 'Comoros', 'https://flagcdn.com/w40/km.png', 'KMF');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KN', 4, '세인트키츠 네비스', 'Saint Kitts and Nevis', 'https://flagcdn.com/w40/kn.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KP', 1, '조선민주주의인민공화국', 'Democratic People\'s Republic of', 'https://flagcdn.com/w40/kp.png', 'KPW');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KR', 1, '대한민국', 'Republic of', 'https://flagcdn.com/w40/kr.png', 'KRW');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KW', 1, '쿠웨이트', 'Kuwait', 'https://flagcdn.com/w40/kw.png', 'KWD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KY', 4, '케이맨 제도', 'Cayman Islands', 'https://flagcdn.com/w40/ky.png', 'KYD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('KZ', 1, '카자흐스탄', 'Kazakhstan', 'https://flagcdn.com/w40/kz.png', 'KZT');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LA', 1, '라오스', 'Lao People\'s Democratic Republic', 'https://flagcdn.com/w40/la.png', 'LAK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LB', 1, '레바논', 'Lebanon', 'https://flagcdn.com/w40/lb.png', 'LBP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LC', 4, '세인트루시아', 'Saint Lucia', 'https://flagcdn.com/w40/lc.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LI', 2, '리히텐슈타인', 'Liechtenstein', 'https://flagcdn.com/w40/li.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LK', 1, '스리랑카', 'Sri Lanka', 'https://flagcdn.com/w40/lk.png', 'LKR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LR', 3, '라이베리아', 'Liberia', 'https://flagcdn.com/w40/lr.png', 'LRD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LS', 3, '레소토', 'Lesotho', 'https://flagcdn.com/w40/ls.png', 'LSL');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LT', 2, '리투아니아', 'Lithuania', 'https://flagcdn.com/w40/lt.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LU', 2, '룩셈부르크', 'Luxembourg', 'https://flagcdn.com/w40/lu.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LV', 2, '라트비아', 'Latvia', 'https://flagcdn.com/w40/lv.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('LY', 3, '리비아', 'Libya', 'https://flagcdn.com/w40/ly.png', 'LYD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MA', 3, '모로코', 'Morocco', 'https://flagcdn.com/w40/ma.png', 'MAD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MC', 2, '모나코', 'Monaco', 'https://flagcdn.com/w40/mc.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MD', 2, '몰도바', 'Republic of', 'https://flagcdn.com/w40/md.png', 'MDL');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ME', 2, '몬테네그로', 'Montenegro', 'https://flagcdn.com/w40/me.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MF', 4, '생마르탱', 'Saint Martin (French part)', 'https://flagcdn.com/w40/mf.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MG', 3, '마다가스카르', 'Madagascar', 'https://flagcdn.com/w40/mg.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MH', 6, '마셜 제도', 'Marshall Islands', 'https://flagcdn.com/w40/mh.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MK', 2, '북마케도니아', 'North Macedonia', 'https://flagcdn.com/w40/mk.png', 'MKD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ML', 3, '말리', 'Mali', 'https://flagcdn.com/w40/ml.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MM', 1, '미얀마', 'Myanmar', 'https://flagcdn.com/w40/mm.png', 'MMK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MN', 1, '몽골', 'Mongolia', 'https://flagcdn.com/w40/mn.png', 'MNT');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MO', 1, '마카오', 'Macao', 'https://flagcdn.com/w40/mo.png', 'MOP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MP', 6, '북마리아나 제도', 'Northern Mariana Islands', 'https://flagcdn.com/w40/mp.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MQ', 4, '마르티니크', 'Martinique', 'https://flagcdn.com/w40/mq.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MR', 3, '모리타니', 'Mauritania', 'https://flagcdn.com/w40/mr.png', 'MRO');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MS', 4, '몬트세라트', 'Montserrat', 'https://flagcdn.com/w40/ms.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MT', 2, '몰타', 'Malta', 'https://flagcdn.com/w40/mt.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MU', 3, '모리셔스', 'Mauritius', 'https://flagcdn.com/w40/mu.png', 'MUR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MV', 1, '몰디브', 'Maldives', 'https://flagcdn.com/w40/mv.png', 'MVR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MW', 3, '말라위', 'Malawi', 'https://flagcdn.com/w40/mw.png', 'MWK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MX', 4, '멕시코', 'Mexico', 'https://flagcdn.com/w40/mx.png', 'MXN');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MY', 1, '말레이시아', 'Malaysia', 'https://flagcdn.com/w40/my.png', 'MYR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('MZ', 3, '모잠비크', 'Mozambique', 'https://flagcdn.com/w40/mz.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NA', 3, '나미비아', 'Namibia', 'https://flagcdn.com/w40/na.png', 'NAD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NC', 6, '뉴칼레도니아', 'New Caledonia', 'https://flagcdn.com/w40/nc.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NE', 3, '니제르', 'Niger', 'https://flagcdn.com/w40/ne.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NF', 6, '노퍽 섬', 'Norfolk Island', 'https://flagcdn.com/w40/nf.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NG', 3, '나이지리아', 'Nigeria', 'https://flagcdn.com/w40/ng.png', 'NGN');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NI', 4, '니카라과', 'Nicaragua', 'https://flagcdn.com/w40/ni.png', 'NIO');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NL', 2, '네덜란드', 'Netherlands', 'https://flagcdn.com/w40/nl.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NO', 2, '노르웨이', 'Norway', 'https://flagcdn.com/w40/no.png', 'NOK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NP', 1, '네팔', 'Nepal', 'https://flagcdn.com/w40/np.png', 'NPR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NR', 6, '나우루', 'Nauru', 'https://flagcdn.com/w40/nr.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NU', 6, '니우에', 'Niue', 'https://flagcdn.com/w40/nu.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('NZ', 6, '뉴질랜드', 'New Zealand', 'https://flagcdn.com/w40/nz.png', 'NZD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('OM', 1, '오만', 'Oman', 'https://flagcdn.com/w40/om.png', 'OMR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PA', 4, '파나마', 'Panama', 'https://flagcdn.com/w40/pa.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PE', 5, '페루', 'Peru', 'https://flagcdn.com/w40/pe.png', 'PEN');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PF', 6, '프랑스령 폴리네시아', 'French Polynesia', 'https://flagcdn.com/w40/pf.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PG', 6, '파푸아뉴기니', 'Papua New Guinea', 'https://flagcdn.com/w40/pg.png', 'PGK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PH', 1, '필리핀', 'Philippines', 'https://flagcdn.com/w40/ph.png', 'PHP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PK', 1, '파키스탄', 'Pakistan', 'https://flagcdn.com/w40/pk.png', 'PKR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PL', 2, '폴란드', 'Poland', 'https://flagcdn.com/w40/pl.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PM', 4, '생피에르 미클롱', 'Saint Pierre and Miquelon', 'https://flagcdn.com/w40/pm.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PN', 6, '핏케언 제도', 'Pitcairn', 'https://flagcdn.com/w40/pn.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PR', 4, '푸에르토리코', 'Puerto Rico', 'https://flagcdn.com/w40/pr.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PS', 1, '팔레스타인', 'State of', 'https://flagcdn.com/w40/ps.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PT', 2, '포르투갈', 'Portugal', 'https://flagcdn.com/w40/pt.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PW', 6, '팔라우', 'Palau', 'https://flagcdn.com/w40/pw.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('PY', 5, '파라과이', 'Paraguay', 'https://flagcdn.com/w40/py.png', 'PYG');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('QA', 1, '카타르', 'Qatar', 'https://flagcdn.com/w40/qa.png', 'QAR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('RE', 3, '레위니옹', 'Réunion', 'https://flagcdn.com/w40/re.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('RO', 2, '루마니아', 'Romania', 'https://flagcdn.com/w40/ro.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('RS', 2, '세르비아', 'Serbia', 'https://flagcdn.com/w40/rs.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('RU', 2, '러시아', 'Russian Federation', 'https://flagcdn.com/w40/ru.png', 'RUB');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('RW', 3, '르완다', 'Rwanda', 'https://flagcdn.com/w40/rw.png', 'RWF');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SA', 1, '사우디아라비아', 'Saudi Arabia', 'https://flagcdn.com/w40/sa.png', 'SAR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SB', 6, '솔로몬 제도', 'Solomon Islands', 'https://flagcdn.com/w40/sb.png', 'SBD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SC', 3, '세이셸', 'Seychelles', 'https://flagcdn.com/w40/sc.png', 'SCR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SD', 3, '수단', 'Sudan', 'https://flagcdn.com/w40/sd.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SE', 2, '스웨덴', 'Sweden', 'https://flagcdn.com/w40/se.png', 'SEK');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SG', 1, '싱가포르', 'Singapore', 'https://flagcdn.com/w40/sg.png', 'SGD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SH', 3, '어센션 트리스탄다쿠나', 'Ascension and Tristan da Cunha', 'https://flagcdn.com/w40/sh.png', 'SHP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SI', 2, '슬로베니아', 'Slovenia', 'https://flagcdn.com/w40/si.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SJ', 2, '스발바르 얀마옌 제도', 'Svalbard and Jan Mayen', 'https://flagcdn.com/w40/sj.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SK', 2, '슬로바키아', 'Slovakia', 'https://flagcdn.com/w40/sk.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SL', 3, '시에라리온', 'Sierra Leone', 'https://flagcdn.com/w40/sl.png', 'SLL');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SM', 2, '산마리노', 'San Marino', 'https://flagcdn.com/w40/sm.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SN', 3, '세네갈', 'Senegal', 'https://flagcdn.com/w40/sn.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SO', 3, '소말리아', 'Somalia', 'https://flagcdn.com/w40/so.png', 'SOS');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SR', 5, '수리남', 'Suriname', 'https://flagcdn.com/w40/sr.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SS', 3, '남수단', 'South Sudan', 'https://flagcdn.com/w40/ss.png', 'SSP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ST', 3, '상투메 프린시페', 'Sao Tome and Principe', 'https://flagcdn.com/w40/st.png', 'STD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SV', 4, '엘살바도르', 'El Salvador', 'https://flagcdn.com/w40/sv.png', 'SVC');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SX', 4, '신트마르턴', 'Sint Maarten (Dutch part)', 'https://flagcdn.com/w40/sx.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SY', 1, '시리아', 'Syrian Arab Republic', 'https://flagcdn.com/w40/sy.png', 'SYP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('SZ', 3, '에스와티니', 'Eswatini', 'https://flagcdn.com/w40/sz.png', 'SZL');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TC', 6, '터크스 케이커스 제도', 'Turks and Caicos Islands', 'https://flagcdn.com/w40/tc.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TD', 3, '차드', 'Chad', 'https://flagcdn.com/w40/td.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TF', 6, '프랑스령 남부와 남극 지역', 'French Southern Territories', 'https://flagcdn.com/w40/tf.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TG', 3, '토고', 'Togo', 'https://flagcdn.com/w40/tg.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TH', 1, '태국', 'Thailand', 'https://flagcdn.com/w40/th.png', 'THB');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TJ', 1, '타지키스탄', 'Tajikistan', 'https://flagcdn.com/w40/tj.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TK', 6, '토켈라우', 'Tokelau', 'https://flagcdn.com/w40/tk.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TL', 1, '동티모르', 'Timor-Leste', 'https://flagcdn.com/w40/tl.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TM', 1, '투르크메니스탄', 'Turkmenistan', 'https://flagcdn.com/w40/tm.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TN', 3, '튀니지', 'Tunisia', 'https://flagcdn.com/w40/tn.png', 'TND');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TO', 6, '통가', 'Tonga', 'https://flagcdn.com/w40/to.png', 'TOP');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TR', 1, '튀르키예', 'Turkey', 'https://flagcdn.com/w40/tr.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TT', 4, '트리니다드토바고', 'Trinidad and Tobago', 'https://flagcdn.com/w40/tt.png', 'TTD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TV', 6, '투발루', 'Tuvalu', 'https://flagcdn.com/w40/tv.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TW', 1, '대만', 'Province of China', 'https://flagcdn.com/w40/tw.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('TZ', 3, '탄자니아', 'United Republic of', 'https://flagcdn.com/w40/tz.png', 'TZS');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('UA', 2, '우크라이나', 'Ukraine', 'https://flagcdn.com/w40/ua.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('UG', 3, '우간다', 'Uganda', 'https://flagcdn.com/w40/ug.png', 'UGX');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('UM', 6, '미국령 군소 제도', 'United States Minor Outlying Islands', 'https://flagcdn.com/w40/um.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('US', 4, '미국', 'United States', 'https://flagcdn.com/w40/us.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('UY', 5, '우루과이', 'Uruguay', 'https://flagcdn.com/w40/uy.png', 'UYU');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('UZ', 1, '우즈베키스탄', 'Uzbekistan', 'https://flagcdn.com/w40/uz.png', 'UZS');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('VA', 2, '바티칸 시국', 'Holy See (Vatican City State)', 'https://flagcdn.com/w40/va.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('VC', 4, '세인트빈센트 그레나딘', 'Saint Vincent and the Grenadines', 'https://flagcdn.com/w40/vc.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('VE', 5, '베네수엘라', 'Bolivarian Republic of', 'https://flagcdn.com/w40/ve.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('VG', 4, '영국령 버진아일랜드', 'British', 'https://flagcdn.com/w40/vg.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('VI', 4, '미국령 버진아일랜드', 'U.S.', 'https://flagcdn.com/w40/vi.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('VN', 1, '베트남', 'Viet Nam', 'https://flagcdn.com/w40/vn.png', 'VND');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('VU', 6, '바누아투', 'Vanuatu', 'https://flagcdn.com/w40/vu.png', 'VUV');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('WF', 6, '왈리스 퓌투나', 'Wallis and Futuna', 'https://flagcdn.com/w40/wf.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('WS', 6, '사모아', 'Samoa', 'https://flagcdn.com/w40/ws.png', 'WST');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('YE', 1, '예멘', 'Yemen', 'https://flagcdn.com/w40/ye.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('YT', 3, '마요트', 'Mayotte', 'https://flagcdn.com/w40/yt.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ZA', 3, '남아프리카공화국', 'South Africa', 'https://flagcdn.com/w40/za.png', 'ZAR');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ZM', 3, '잠비아', 'Zambia', 'https://flagcdn.com/w40/zm.png', 'USD');
INSERT INTO kosa_db.country (countryCode, continentNumber, countryNameKor, countryNameEng, flagURL, currency) VALUES ('ZW', 3, '짐바브웨', 'Zimbabwe', 'https://flagcdn.com/w40/zw.png', 'USD');

-- =====================================================================================
-- 6. 위시리스트 데이터 삽입
-- =====================================================================================

INSERT INTO `list_of_countries` (`countryCode`, `userId`, `checkContWishList`) VALUES
('JP', 'msa1', 1),
('KR', 'msa1', 1),
('FR', 'msa2', 1),
('IT', 'msa2', 1),
('US', 'msa3', 1),
('CA', 'msa3', 1),
('AU', 'msa4', 1),
('NZ', 'msa4', 1),
('ES', 'msa5', 1),
('GB', 'msa5', 1),
('TH', 'msa6', 1),
('VN', 'msa6', 1);

-- =====================================================================================
-- 7. 게시판 데이터 삽입
-- =====================================================================================

INSERT INTO `board` (`boardNumber`, `boardName`) VALUES
(1, '자유게시판'),
(2, '여행 후기'),
(3, '여행 정보');

-- =====================================================================================
-- 8. 게시글 데이터 삽입 - 자유게시판 & 여행 정보 (3페이지 분량 = 약 30개)
-- =====================================================================================

INSERT INTO `post` (`postTitle`, `postDescription`, `boardNumber`, `userId`, `postDateWritten`) VALUES
('제주도 3박4일 여행 계획 공유', '제주도 렌터카 여행을 계획중입니다. 추천 코스가 있을까요?', 1, 'msa1', DATE_SUB(NOW(), INTERVAL 1 DAY)),
('파리 자유여행 팁 공유', '파리 여행 시 꼭 알아야 할 정보들을 정리해봤습니다. 교통, 숙소, 맛집 정보 포함.', 3, 'msa2', DATE_SUB(NOW(), INTERVAL 2 DAY)),
('도쿄 5일 여행 코스 추천', '도쿄를 5일동안 여행하며 다녀온 코스를 정리했습니다. 참고하시면 도움될 거에요!', 3, 'msa1', DATE_SUB(NOW(), INTERVAL 3 DAY)),
('베트남 다낭 여행 준비중', '다낭 여행 준비중인데 필수 준비물이 뭐가 있을까요?', 1, 'msa3', DATE_SUB(NOW(), INTERVAL 4 DAY)),
('유럽 배낭여행 준비물 체크리스트', '유럽 여행 준비하시는 분들을 위한 필수 준비물 리스트입니다.', 3, 'msa4', DATE_SUB(NOW(), INTERVAL 5 DAY)),
('태국 방콕 맛집 정보', '방콕에서 꼭 가봐야 할 맛집을 공유합니다!', 1, 'msa5', DATE_SUB(NOW(), INTERVAL 6 DAY)),
('뉴욕 맨해튼 여행 가이드', '뉴욕 맨해튼의 주요 관광지와 숨은 명소를 공유합니다.', 3, 'msa6', DATE_SUB(NOW(), INTERVAL 7 DAY)),
('스페인 바르셀로나 여행 계획', '바르셀로나 여행 계획중입니다. 조언 부탁드려요!', 1, 'msa1', DATE_SUB(NOW(), INTERVAL 8 DAY)),
('싱가포르 3일 완벽 일정', '싱가포르를 3일만에 완벽하게 즐기는 방법!', 3, 'msa2', DATE_SUB(NOW(), INTERVAL 9 DAY)),
('호주 시드니 여행 준비중', '시드니 여행 준비중인데 추천 명소 있나요?', 1, 'msa3', DATE_SUB(NOW(), INTERVAL 10 DAY)),
('런던 해리포터 투어 정보', '해리포터 팬이라면 꼭 가봐야 할 장소들!', 3, 'msa4', DATE_SUB(NOW(), INTERVAL 11 DAY)),
('이탈리아 로마 여행 팁', '로마 여행시 꼭 알아야 할 팁들을 정리했습니다.', 3, 'msa5', DATE_SUB(NOW(), INTERVAL 12 DAY)),
('캐나다 밴쿠버 여행 문의', '밴쿠버에서 꼭 가봐야 할 곳이 어디인가요?', 1, 'msa6', DATE_SUB(NOW(), INTERVAL 13 DAY)),
('인도네시아 발리 여행 정보', '발리 여행 정보를 공유합니다.', 3, 'msa1', DATE_SUB(NOW(), INTERVAL 14 DAY)),
('홍콩 야경 명소 추천', '홍콩에서 가장 아름다운 야경을 볼 수 있는 장소들!', 3, 'msa2', DATE_SUB(NOW(), INTERVAL 15 DAY)),
('그리스 산토리니 여행 계획', '산토리니 여행을 계획중입니다.', 1, 'msa3', DATE_SUB(NOW(), INTERVAL 16 DAY)),
('스위스 융프라우 정보', '스위스 알프스 여행 정보를 공유합니다.', 3, 'msa4', DATE_SUB(NOW(), INTERVAL 17 DAY)),
('터키 이스탄불 여행 추천', '이스탄불 여행 추천 코스가 있을까요?', 1, 'msa5', DATE_SUB(NOW(), INTERVAL 18 DAY)),
('필리핀 세부 여행 문의', '세부 여행 준비중인데 조언 부탁드립니다.', 1, 'msa6', DATE_SUB(NOW(), INTERVAL 19 DAY)),
('미국 LA 여행 정보', 'LA 여행 정보를 공유합니다.', 3, 'msa1', DATE_SUB(NOW(), INTERVAL 20 DAY)),
('프랑스 남부 니스 여행', '니스 여행 준비중입니다.', 1, 'msa2', DATE_SUB(NOW(), INTERVAL 21 DAY)),
('체코 프라하 여행 팁', '프라하 여행시 유용한 팁들!', 3, 'msa3', DATE_SUB(NOW(), INTERVAL 22 DAY)),
('멕시코 칸쿤 여행 정보', '칸쿤 여행 정보를 공유합니다.', 3, 'msa4', DATE_SUB(NOW(), INTERVAL 23 DAY)),
('아이슬란드 오로라 여행', '오로라를 보기 좋은 시기는 언제인가요?', 1, 'msa5', DATE_SUB(NOW(), INTERVAL 24 DAY)),
('뉴질랜드 남섬 여행 계획', '뉴질랜드 남섬 여행을 계획중입니다.', 1, 'msa6', DATE_SUB(NOW(), INTERVAL 25 DAY)),
('크로아티아 두브로브니크 정보', '두브로브니크 여행 정보를 알려주세요!', 1, 'msa1', DATE_SUB(NOW(), INTERVAL 26 DAY)),
('포르투갈 리스본 여행 팁', '리스본 여행시 유용한 정보들!', 3, 'msa2', DATE_SUB(NOW(), INTERVAL 27 DAY)),
('모로코 사하라 사막 투어', '사하라 사막 투어에 대해 알고 싶습니다.', 1, 'msa3', DATE_SUB(NOW(), INTERVAL 28 DAY)),
('부산 해운대 여행 추천', '해운대 근처 맛집 추천해주세요!', 1, 'msa4', DATE_SUB(NOW(), INTERVAL 29 DAY)),
('강원도 속초 여행 정보', '속초 여행 정보를 공유합니다.', 3, 'msa5', DATE_SUB(NOW(), INTERVAL 30 DAY));

-- =====================================================================================
-- 9. 게시글 데이터 삽입 - 여행 후기 (리뷰 게시판, 1페이지 이상 = 약 12개)
-- =====================================================================================

INSERT INTO `post` (`postTitle`, `postDescription`, `boardNumber`, `userId`, `postDateWritten`) VALUES
('제주도 한달살기 후기', '제주도에서 한달을 살아본 경험을 공유합니다. 제주시 구도심에 에어비앤비를 잡고 렌터카로 섬 구석구석을 다녀왔어요.\n\n첫 주에는 동부 코스를 집중 탐방했습니다. 성산일출봉에서 일출을 보고, 섭지코지 산책로를 걸었어요. 우도에서 땅콩 아이스크림을 먹으며 자전거 투어도 했습니다.\n\n둘째 주는 서부와 중산간 지역을 다녔어요. 협재 해수욕장의 에메랄드빛 바다가 인상적이었고, 한림공원과 오설록 티뮤지엄도 방문했습니다. 저녁에는 애월 카페거리에서 노을을 보며 시간을 보냈어요.\n\n셋째 주는 올레길 완주에 도전했습니다. 7코스(외돌개-월평)와 10코스(화순-모슬포)가 특히 아름다웠어요. 걷다가 만난 현지분들이 감귤도 나눠주시고 정말 친절하셨습니다.\n\n마지막 주는 제주 로컬 맛집 투어를 했어요. 동문시장 회국수, 고기국수, 흑돼지 구이, 전복뚝배기 등 제주 음식을 실컷 먹었습니다. 날씨도 완벽했고 정말 힐링되는 한달이었어요!', 2, 'msa1', DATE_SUB(NOW(), INTERVAL 1 HOUR)),
('파리 7일 자유여행 완벽 후기', '파리 7일 여행 다녀왔습니다! 샤를 드골 공항에서 RER B선을 타고 숙소로 이동했어요. 마레 지구 근처에 숙소를 잡았는데 위치가 정말 좋았습니다.\n\n첫날은 노트르담 대성당(외부만 관람)과 생 샤펠, 셰익스피어 서점을 둘러봤어요. 저녁에는 센강변을 산책하며 에펠탑 야경을 감상했습니다.\n\n둘째날 루브르 박물관에서 하루를 보냈어요. 모나리자, 밀로의 비너스, 사모트라케의 니케 등 실제로 보니 감동이었습니다. 사전 예약 필수입니다!\n\n셋째날은 베르사유 궁전 당일치기. 정원이 너무 넓어서 전동차를 타고 다녔어요. 거울의 방은 정말 화려했습니다.\n\n넷째날 몽마르트 언덕과 사크레쾨르 성당, 물랭루즈를 방문했어요. 테르트르 광장에서 그림도 한 점 샀습니다.\n\n다섯째날은 오르세 미술관과 오랑주리 미술관 투어. 인상파 작품들을 실제로 보니 색감이 정말 아름다웠어요.\n\n여섯째날 개선문에 올라가 파리 전경을 보고, 샹젤리제 거리를 걸었습니다. 저녁에는 센강 유람선을 탔는데 야경이 환상적이었어요.\n\n마지막 날은 마레 지구 빈티지샵과 카페를 돌아다니며 여유롭게 보냈습니다. 파리는 정말 낭만의 도시네요!', 2, 'msa2', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
('도쿄 맛집 투어 후기', '도쿄에서 5일간 맛집 투어를 다녀왔습니다. 완전 미식 여행이었어요!\n\n첫날 아침은 츠키지 외시장에서 시작했어요. 스시 다이와에서 오마카세를 먹었는데 신선한 생선이 입에서 녹았습니다. 줄은 길었지만 기다릴 만한 가치가 있었어요.\n\n점심은 신주쿠 이치란 라멘 본점에서. 1인 부스 시스템이 독특했고, 돈코츠 라멘 국물이 진하고 고소했습니다. 가에다마(면 추가)도 해서 배불리 먹었어요.\n\n둘째날은 긴자에서 텐푸라 전문점 텐이치를 방문했어요. 카운터에 앉아서 셰프가 바로바로 튀겨주는 텐푸라를 먹는 경험이 특별했습니다.\n\n셋째날 하라주쿠에서 크레이프를 먹고, 시부야 이치리큐에서 츠케멘을 먹었어요. 면을 진한 국물에 찍어먹는 스타일인데 정말 맛있었습니다.\n\n넷째날은 아사쿠사 호핑요코초(술집 골목)에서 야키토리와 하이볼을 즐겼어요. 현지 분위기가 물씬 났습니다.\n\n마지막 날은 시나가와에서 규카츠(소고기 커틀릿)를 먹고 공항으로 이동했어요. 5일 내내 맛있는 것만 먹었습니다. 일본 음식 최고!', 2, 'msa1', DATE_SUB(NOW(), INTERVAL 3 HOUR)),
('베트남 다낭 가족여행 후기', '가족(부부+초등학생 2명)과 함께 다낭 5일 여행을 다녀왔습니다.\n\n인터컨티넨탈 다낭 리조트에 숙소를 잡았는데, 아이들이 수영장과 해변에서 매일 놀았어요. 키즈클럽도 있어서 부모님들이 잠깐 쉴 수 있는 시간도 있었습니다.\n\n첫날은 리조트에서 적응하며 보냈고, 둘째날 바나힐 테마파크에 갔어요. 케이블카를 타고 올라가는데 경치가 장관이었습니다. 골든 브릿지에서 가족 사진도 찍었어요. 아이들이 판타지파크 놀이기구를 정말 좋아했습니다.\n\n셋째날은 호이안 고대도시 투어를 했어요. 낮에는 고택들을 구경하고, 저녁에는 등불 축제를 즐겼습니다. 투본강에 등불을 띄우는 체험도 했어요. 아이들이 신기해하더라구요.\n\n넷째날은 오전에 미케 비치에서 놀고, 오후에는 참 조각 박물관을 방문했습니다. 저녁에는 한시장 야시장에서 쌀국수와 반쎄오를 먹었어요.\n\n마지막 날은 리조트에서 여유롭게 보내고 스파도 받았습니다. 가격도 저렴하고 시설도 좋아서 가족 여행지로 정말 추천합니다!', 2, 'msa3', DATE_SUB(NOW(), INTERVAL 4 HOUR)),
('유럽 3국 배낭여행 후기', '프랑스-이탈리아-스페인을 2주간 배낭여행 했습니다. 유레일 글로벌 패스를 끊어서 기차 여행을 했어요.\n\n파리에서 4일 머물며 주요 명소를 둘러보고, TGV로 니스로 이동했습니다. 니스 해변에서 하루를 보내고 코트다쥐르의 아름다운 풍경을 만끽했어요.\n\n니스에서 야간열차를 타고 로마로 이동. 콜로세움, 포로 로마노, 트레비 분수, 바티칸 박물관을 3일간 돌아봤습니다. 젤라또를 하루에 2-3번씩 먹었어요.\n\n로마에서 피렌체로 이동해 2일 체류. 우피치 미술관에서 르네상스 작품들을 감상하고, 두오모에 올라가 전망을 봤습니다. 비스테카 피오렌티나(티본 스테이크)가 정말 맛있었어요.\n\n피렌체에서 바르셀로나로 이동. 사그라다 파밀리아, 구엘 공원, 카사 밀라 등 가우디 건축물 투어를 했습니다. 고딕 지구를 걸으며 타파스 투어도 즐겼어요.\n\n마지막은 바르셀로나 해변에서 여유를 즐기며 마무리. 2주가 어떻게 지나갔는지 모를 정도로 알찼습니다. 유럽 배낭여행 정말 추천해요!', 2, 'msa4', DATE_SUB(NOW(), INTERVAL 5 HOUR)),
('태국 방콕 야시장 투어 후기', '방콕 5일 여행 중 야시장 투어가 하이라이트였어요!\n\n첫날은 짯짝 주말시장(Chatuchak Weekend Market)에 갔습니다. 15,000개가 넘는 상점이 있어서 하루 종일 돌아다녔어요. 빈티지 옷, 수공예품, 애완동물까지 없는 게 없었습니다. 코코넛 아이스크림과 망고 스티키 라이스를 먹으며 구경했어요.\n\n둘째날 저녁은 아시아티크 더 리버프론트(Asiatique The Riverfront)를 방문했습니다. 차오프라야강변에 위치한 야시장인데 분위기가 정말 좋았어요. 대관람차도 타고 강변 레스토랑에서 저녁도 먹었습니다.\n\n셋째날은 탈랏롯파이 라차다(Train Night Market Ratchada)에 갔어요. MRT 타이 컬쳐럴 센터역에서 가깝습니다. 에스플라네이드 주차장 4층에서 찍은 야시장 전경 사진이 인생샷이에요! 씨푸드 구이와 팟타이를 먹었는데 가격도 저렴하고 맛있었습니다.\n\n넷째날은 조드 페어스(Jodd Fairs)라는 신생 야시장을 갔어요. 최신 야시장이라 깨끗하고 인스타그래머블한 포토존이 많았습니다. 치즈볼, 크림새우, 망고빙수 등 다양한 음식을 먹었어요.\n\n방콕은 야시장만으로도 충분히 즐길 수 있는 도시예요. 물가도 저렴하고 음식도 맛있어서 정말 만족스러웠습니다!', 2, 'msa5', DATE_SUB(NOW(), INTERVAL 6 HOUR)),
('뉴욕 브로드웨이 뮤지컬 관람 후기', '뉴욕 6일 여행 중 브로드웨이 뮤지컬 3편을 봤습니다!\n\n첫 번째는 라이온킹(The Lion King)이었어요. Minskoff Theatre에서 관람했는데, 무대 세트와 의상, 퍼포먼스가 정말 대단했습니다. "Circle of Life" 오프닝 장면에서 동물들이 등장할 때 소름이 돋았어요. 아프리카 사바나를 무대에 완벽하게 재현했더라구요.\n\n두 번째는 해밀턴(Hamilton)입니다. Richard Rodgers Theatre에서 봤어요. 미국 건국의 아버지 알렉산더 해밀턴의 이야기를 힙합과 랩으로 풀어낸 게 신선했습니다. 가사가 빠르긴 했지만 에너지가 넘치는 공연이었어요. 티켓 구하기가 어려웠지만 볼만한 가치가 있었습니다.\n\n세 번째는 시카고(Chicago)를 봤어요. Ambassador Theatre에서 관람했습니다. 재즈와 탭댄스가 환상적이었고, 섹시하면서도 위트 있는 스토리가 매력적이었어요.\n\n브로드웨이 티켓은 TKTS 부스에서 당일 할인 티켓을 구매하거나, 온라인 사전 예약을 추천합니다. 공연 전후로 타임스퀘어를 걸으며 뉴욕의 활기를 느낄 수 있었어요.\n\n뉴욕에 가신다면 브로드웨이 뮤지컬은 필수 코스입니다. 평생 잊지 못할 경험이에요!', 2, 'msa6', DATE_SUB(NOW(), INTERVAL 7 HOUR)),
('스페인 바르셀로나 건축 기행 후기', '바르셀로나에서 5일간 가우디 건축물 투어를 했습니다. 건축 좋아하시는 분들께 강추!\n\n첫날은 사그라다 파밀리아(Sagrada Familia)부터 시작했어요. 1882년 착공해서 아직도 건설 중인 성당입니다. 내부에 들어가니 스테인드글라스를 통해 들어오는 빛이 정말 환상적이었어요. 나무 기둥 같은 독특한 구조도 인상적이었습니다. 오디오 가이드를 꼭 빌려서 듣는 걸 추천합니다.\n\n둘째날은 구엘 공원(Park Güell)을 방문했어요. 모자이크 타일로 장식된 벤치와 도마뱀 분수가 너무 귀여웠습니다. 언덕 위에서 바라본 바르셀로나 시내 전망도 멋있었어요. 아침 일찍 가면 사람이 적어서 사진 찍기 좋습니다.\n\n셋째날은 카사 밀라(La Pedrera)와 카사 바트요(Casa Batlló)를 봤어요. 카사 밀라는 물결치는 듯한 외관과 독특한 굴뚝이 인상적이었고, 카사 바트요는 바다를 모티브로 한 실내 디자인이 환상적이었습니다. 둘 다 내부 투어를 해서 가우디의 천재성을 느낄 수 있었어요.\n\n넷째날은 구엘 저택(Palau Güell)과 카사 비센스(Casa Vicens)를 방문했습니다. 상대적으로 덜 알려진 곳이지만 가우디 초기 작품을 볼 수 있어서 좋았어요.\n\n마지막 날은 고딕 지구를 걸으며 바르셀로나 대성당도 보고, 람블라스 거리에서 여유를 즐겼습니다. 바르셀로나는 도시 전체가 예술 작품이에요!', 2, 'msa1', DATE_SUB(NOW(), INTERVAL 8 HOUR)),
('싱가포르 3일 여행 후기', '싱가포르 3일 알찬 여행 후기 공유합니다!\n\n첫날은 마리나 베이 샌즈를 중심으로 돌아다녔어요. 아침에 가든스 바이 더 베이(Gardens by the Bay)를 방문했습니다. 수퍼트리 그로브와 플라워 돔, 클라우드 포레스트가 정말 인상적이었어요. 특히 클라우드 포레스트의 실내 폭포는 장관이었습니다.\n\n점심은 라오파사 호커센터에서 해결했어요. 칠리크랩, 치킨라이스, 락사 등 싱가포르 로컬 음식을 저렴하게 맛볼 수 있었습니다. 저녁에는 마리나 베이 샌즈 야경을 보며 스펙트라 쇼(무료 분수쇼)를 감상했어요.\n\n둘째날은 센토사 섬으로 당일치기를 갔습니다. 유니버셜 스튜디오에서 하루를 보냈어요. 트랜스포머 라이드와 쥬라기 파크 어트랙션이 특히 재미있었습니다. 저녁에는 팔라완 비치에서 석양을 보고 윙스 오브 타임 쇼를 봤어요.\n\n마지막 날은 리틀 인디아와 차이나타운을 걸으며 문화 투어를 했습니다. 스리 비라마칼리암만 사원의 화려한 색채가 인상적이었어요. 차이나타운에서는 맥스웰 푸드센터에서 티엔티엔 치킨라이스를 먹었습니다(줄이 길지만 맛있어요!).\n\n오차드 로드에서 쇼핑도 하고, 공항으로 이동했습니다. 창이공항 주얼의 레인 보텍스(실내 폭포)도 꼭 보세요! 3일이 짧게 느껴질 정도로 알찬 여행이었어요.', 2, 'msa2', DATE_SUB(NOW(), INTERVAL 9 HOUR)),
('호주 시드니 오페라하우스 방문 후기', '시드니 1주일 여행 중 오페라하우스에서 오페라를 관람한 경험을 공유합니다.\n\n시드니 오페라하우스는 1973년에 완공된 세계적인 건축물이에요. 서큘러 키에서 바라본 오페라하우스와 하버 브리지의 조합이 정말 아름다웠습니다.\n\n저는 푸치니의 "라 보엠(La Bohème)"을 관람했어요. Joan Sutherland Theatre에서 공연이 있었는데, 극장 내부도 정말 우아했습니다. 좌석에서 보이는 무대 시야도 좋았고, 음향도 훌륭했어요.\n\n1막이 끝나고 인터미션 때 극장 밖 테라스로 나가면 시드니 하버를 볼 수 있어요. 샴페인을 마시며 야경을 즐기는 시간이 정말 로맨틱했습니다.\n\n공연 자체도 감동적이었어요. 미미와 로돌포의 애틋한 사랑 이야기가 아름다운 아리아와 함께 펼쳐졌습니다. "Che gelida manina"와 "Mi chiamano Mimì" 아리아를 실제로 들으니 소름이 돋았어요.\n\n공연이 끝난 후 오페라하우스 주변을 산책했습니다. 야경이 정말 환상적이었어요. 오페라하우스가 조명을 받아 빛나는 모습이 마치 꿈을 꾸는 것 같았습니다.\n\n다음날은 오페라하우스 가이드 투어에 참여했어요. 내부 구조와 역사에 대해 자세히 알 수 있었습니다. 시드니에 가신다면 오페라 관람을 꼭 해보세요!', 2, 'msa3', DATE_SUB(NOW(), INTERVAL 10 HOUR)),
('런던 해리포터 스튜디오 투어 후기', '런던 워너브라더스 스튜디오 투어 다녀온 해리포터 팬의 후기입니다!\n\n스튜디오는 런던 외곽 Leavesden에 위치해요. 유스턴 역에서 기차로 20분 거리입니다. 사전 예약은 필수! 당일 티켓은 구하기 어려워요.\n\n입장하면 가장 먼저 그레이트 홀을 볼 수 있어요. 실제 촬영에 사용된 세트로 호그와트 학생들이 식사하던 그 홀입니다. 그리핀도르, 슬리데린, 후플푸프, 래번클로 테이블이 그대로 있었어요. 감동의 눈물이...\n\n덤블도어 교장실, 그리핀도르 기숙사 공용실, 마법약 교실, 움브리지 교수실 등 영화 속 세트를 실제로 볼 수 있었습니다. 디테일이 정말 대단해요.\n\n야외 구역에는 프리벳가 4번지(해리가 살던 집), 나이트 버스, 호그와트 다리가 있었어요. 버터비어도 마셔봤는데 달콤하고 부드러운 맛이었습니다.\n\n다이애건 앨리 세트도 압권이었어요. 올리밴더 지팡이 가게, 위즐리 형제 장난감 가게 등이 그대로 재현되어 있었습니다. 실제로 지팡이도 구매할 수 있어요(저는 헤르미온느 지팡이를 샀습니다).\n\n마지막에는 호그와트 성 미니어처 모형이 있었어요. 1:24 스케일로 제작된 거대한 모형인데 정말 정교했습니다.\n\n해리포터 팬이라면 천국 같은 곳이에요. 4-5시간은 족히 걸리니 시간 여유있게 가세요!', 2, 'msa4', DATE_SUB(NOW(), INTERVAL 11 HOUR)),
('이탈리아 로마 역사 탐방 후기', '로마 5일 역사 탐방 여행 후기입니다. 역사 덕후에게는 천국 같은 도시예요!\n\n첫날은 콜로세움(Colosseum)과 포로 로마노(Roman Forum)를 방문했어요. 콜로세움은 서기 80년에 완공된 원형 경기장으로 5만 명을 수용할 수 있었다고 합니다. 내부를 둘러보며 검투사들의 싸움을 상상해봤어요. 지하 구조도 볼 수 있어서 좋았습니다.\n\n포로 로마노는 고대 로마의 중심지였던 곳이에요. 신전, 바실리카, 개선문 등 유적들이 남아있습니다. 오디오 가이드를 들으며 2,000년 전 로마 시민들의 삶을 떠올려봤어요.\n\n둘째날은 바티칸 박물관과 시스티나 성당을 관람했습니다. 미켈란젤로의 천지창조와 최후의 심판을 실제로 보니 입이 떡 벌어졌어요. 라파엘로의 방도 정말 아름다웠습니다. 성 베드로 대성당도 방문했는데 쿠폴라(돔)에 올라가서 본 로마 전경이 장관이었어요.\n\n셋째날은 판테온, 트레비 분수, 스페인 계단을 둘러봤어요. 판테온은 서기 126년에 지어진 신전인데 돔 구조가 정말 인상적이었습니다. 트레비 분수에 동전을 던지며 로마에 다시 오기를 기원했어요.\n\n넷째날은 보르게세 미술관에서 베르니니와 카라바조 작품을 감상하고, 나보나 광장을 산책했습니다.\n\n마지막 날은 카타콤베(지하 묘지) 투어를 했어요. 초기 기독교인들의 흔적을 볼 수 있었습니다. 로마는 역사가 살아 숨쉬는 도시예요!', 2, 'msa5', DATE_SUB(NOW(), INTERVAL 12 HOUR));

-- =====================================================================================
-- 10. 댓글 데이터 삽입
-- =====================================================================================

INSERT INTO `comment` (`commentDescription`, `userId`, `postNumber`, `commentDateWritten`) VALUES
('좋은 정보 감사합니다!', 'msa2', 1, DATE_SUB(NOW(), INTERVAL 23 HOUR)),
('저도 제주도 가고 싶네요.', 'msa3', 1, DATE_SUB(NOW(), INTERVAL 22 HOUR)),
('렌터카는 어디서 빌리셨나요?', 'msa4', 1, DATE_SUB(NOW(), INTERVAL 21 HOUR)),
('파리 정보 정말 유용하네요!', 'msa1', 2, DATE_SUB(NOW(), INTERVAL 47 HOUR)),
('숙소 추천 부탁드립니다.', 'msa5', 2, DATE_SUB(NOW(), INTERVAL 46 HOUR)),
('도쿄 여행 준비중인데 도움됐어요!', 'msa6', 3, DATE_SUB(NOW(), INTERVAL 71 HOUR)),
('코스 참고하겠습니다.', 'msa2', 3, DATE_SUB(NOW(), INTERVAL 70 HOUR)),
('다낭 진짜 좋죠!', 'msa1', 4, DATE_SUB(NOW(), INTERVAL 95 HOUR)),
('가족 여행 추천합니다.', 'msa4', 4, DATE_SUB(NOW(), INTERVAL 94 HOUR)),
('유럽 여행 준비중인데 감사합니다.', 'msa3', 5, DATE_SUB(NOW(), INTERVAL 119 HOUR)),
('체크리스트 완전 유용해요!', 'msa6', 5, DATE_SUB(NOW(), INTERVAL 118 HOUR)),
('방콕 정말 가고 싶어요!', 'msa2', 6, DATE_SUB(NOW(), INTERVAL 143 HOUR)),
('맛있는 음식 추천 부탁드려요.', 'msa1', 6, DATE_SUB(NOW(), INTERVAL 142 HOUR)),
('뉴욕 가고 싶습니다!', 'msa5', 7, DATE_SUB(NOW(), INTERVAL 167 HOUR)),
('맨해튼 정보 감사합니다.', 'msa3', 7, DATE_SUB(NOW(), INTERVAL 166 HOUR)),
('제주도 한달살기 부럽네요!', 'msa2', 31, DATE_SUB(NOW(), INTERVAL 30 MINUTE)),
('저도 내년에 제주도 한달살기 해볼 생각입니다.', 'msa3', 31, DATE_SUB(NOW(), INTERVAL 25 MINUTE)),
('파리 여행 후기 정말 도움됐어요!', 'msa1', 32, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
('센강 유람선 꼭 타봐야겠네요.', 'msa4', 32, DATE_SUB(NOW(), INTERVAL 55 MINUTE)),
('도쿄 맛집 리스트 공유 가능한가요?', 'msa5', 33, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
-- 자유게시판 댓글 추가 (빠진 게시글들)
('방콕 맛집 정말 많죠!', 'msa1', 6, DATE_SUB(NOW(), INTERVAL 140 HOUR)),
('바르셀로나 정말 멋진 도시예요!', 'msa2', 8, DATE_SUB(NOW(), INTERVAL 188 HOUR)),
('시드니 꼭 가보고 싶어요!', 'msa1', 10, DATE_SUB(NOW(), INTERVAL 236 HOUR)),
('밴쿠버 자연경관 정말 아름답다고 들었어요.', 'msa2', 13, DATE_SUB(NOW(), INTERVAL 308 HOUR)),
('산토리니 정말 로맨틱하죠!', 'msa1', 16, DATE_SUB(NOW(), INTERVAL 380 HOUR)),
('이스탄불 정말 가고 싶네요!', 'msa2', 18, DATE_SUB(NOW(), INTERVAL 428 HOUR)),
('세부 바다 정말 깨끗하더라구요!', 'msa2', 19, DATE_SUB(NOW(), INTERVAL 452 HOUR)),
('니스 해변 산책 좋죠!', 'msa4', 21, DATE_SUB(NOW(), INTERVAL 500 HOUR)),
('오로라 꼭 보고 싶어요!', 'msa1', 24, DATE_SUB(NOW(), INTERVAL 572 HOUR)),
('뉴질랜드 자연 정말 환상적이죠!', 'msa2', 25, DATE_SUB(NOW(), INTERVAL 596 HOUR)),
('두브로브니크 정말 아름다운 도시예요!', 'msa3', 26, DATE_SUB(NOW(), INTERVAL 620 HOUR)),
('사하라 사막 별 정말 많이 보이겠네요!', 'msa2', 28, DATE_SUB(NOW(), INTERVAL 668 HOUR)),
('해운대 좋죠!', 'msa1', 29, DATE_SUB(NOW(), INTERVAL 692 HOUR)),
-- 여행 후기 댓글 추가 (빠진 게시글들)
('다낭 가족여행 좋죠!', 'msa2', 34, DATE_SUB(NOW(), INTERVAL 3 HOUR)),
('유럽 배낭여행 부럽네요!', 'msa3', 35, DATE_SUB(NOW(), INTERVAL 4 HOUR)),
('방콕 야시장 정말 재미있어요!', 'msa1', 36, DATE_SUB(NOW(), INTERVAL 5 HOUR)),
('브로드웨이 뮤지컬 정말 보고 싶어요!', 'msa2', 37, DATE_SUB(NOW(), INTERVAL 6 HOUR)),
('바르셀로나 가우디 건축물 정말 대단하죠!', 'msa3', 38, DATE_SUB(NOW(), INTERVAL 7 HOUR)),
('싱가포르 야경 정말 멋지죠!', 'msa4', 39, DATE_SUB(NOW(), INTERVAL 8 HOUR)),
('시드니 오페라하우스 꼭 가보고 싶어요!', 'msa5', 40, DATE_SUB(NOW(), INTERVAL 9 HOUR)),
('해리포터 팬으로서 정말 부럽네요!', 'msa6', 41, DATE_SUB(NOW(), INTERVAL 10 HOUR)),
('로마 역사 정말 대단하죠!', 'msa1', 42, DATE_SUB(NOW(), INTERVAL 11 HOUR)),
-- 여행정보 게시판 댓글 추가 (boardNumber=3)
('파리 정보 정말 유용합니다!', 'msa3', 2, DATE_SUB(NOW(), INTERVAL 48 HOUR)),
('도쿄 여행 준비중인데 감사합니다!', 'msa4', 3, DATE_SUB(NOW(), INTERVAL 72 HOUR)),
('유럽 배낭여행 체크리스트 완전 도움돼요!', 'msa1', 5, DATE_SUB(NOW(), INTERVAL 120 HOUR)),
('뉴욕 가이드 정말 자세하네요!', 'msa2', 7, DATE_SUB(NOW(), INTERVAL 168 HOUR)),
('싱가포르 일정 참고할게요!', 'msa3', 9, DATE_SUB(NOW(), INTERVAL 216 HOUR)),
('해리포터 투어 정보 감사합니다!', 'msa5', 11, DATE_SUB(NOW(), INTERVAL 264 HOUR)),
('로마 여행 팁 정말 유용해요!', 'msa6', 12, DATE_SUB(NOW(), INTERVAL 288 HOUR)),
('발리 여행 정보 감사합니다!', 'msa2', 14, DATE_SUB(NOW(), INTERVAL 336 HOUR)),
('홍콩 야경 명소 꼭 가보고 싶어요!', 'msa4', 15, DATE_SUB(NOW(), INTERVAL 360 HOUR)),
('스위스 알프스 정말 아름답겠네요!', 'msa5', 17, DATE_SUB(NOW(), INTERVAL 408 HOUR)),
('LA 여행 정보 도움됐어요!', 'msa2', 20, DATE_SUB(NOW(), INTERVAL 480 HOUR)),
('프라하 여행 팁 감사합니다!', 'msa4', 22, DATE_SUB(NOW(), INTERVAL 528 HOUR)),
('칸쿤 여행 정보 유용하네요!', 'msa5', 23, DATE_SUB(NOW(), INTERVAL 552 HOUR)),
('리스본 여행시 참고하겠습니다!', 'msa4', 27, DATE_SUB(NOW(), INTERVAL 648 HOUR)),
('속초 여행 정보 감사합니다!', 'msa6', 30, DATE_SUB(NOW(), INTERVAL 720 HOUR));

-- =====================================================================================
-- 11. 칸반 데이터 삽입 (풍부한 목업 데이터)
-- =====================================================================================

INSERT INTO `kanban` (`userId`, `taskDescription`, `taskStatus`, `taskOrder`, `priority`, `dueDate`, `createdDate`) VALUES
-- msa1 유저 칸반
('msa1', '제주도 항공권 예약하기', 'todo', 0, 'high', DATE_ADD(CURDATE(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('msa1', '숙소 예약 완료하기', 'todo', 1, 'high', DATE_ADD(CURDATE(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('msa1', '렌터카 예약하기', 'todo', 2, 'medium', DATE_ADD(CURDATE(), INTERVAL 7 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('msa1', '여행 일정표 작성하기', 'inprogress', 0, 'high', DATE_ADD(CURDATE(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('msa1', '맛집 리스트 정리하기', 'inprogress', 1, 'medium', DATE_ADD(CURDATE(), INTERVAL 4 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('msa1', '여행 가이드북 읽기', 'done', 0, 'low', DATE_SUB(CURDATE(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('msa1', '여권 유효기간 확인', 'done', 1, 'high', DATE_SUB(CURDATE(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),

-- msa2 유저 칸반
('msa2', '파리 박물관 패스 구매', 'todo', 0, 'high', DATE_ADD(CURDATE(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('msa2', '유레일 패스 예약하기', 'todo', 1, 'high', DATE_ADD(CURDATE(), INTERVAL 12 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('msa2', '호텔 조식 여부 확인', 'todo', 2, 'low', DATE_ADD(CURDATE(), INTERVAL 15 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('msa2', '환전하기', 'inprogress', 0, 'high', DATE_ADD(CURDATE(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('msa2', '여행자 보험 가입하기', 'inprogress', 1, 'medium', DATE_ADD(CURDATE(), INTERVAL 8 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
('msa2', '비행기 좌석 배정 완료', 'done', 0, 'medium', DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('msa2', '여행용 캐리어 구매', 'done', 1, 'low', DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),

-- msa3 유저 칸반
('msa3', '베트남 비자 신청하기', 'todo', 0, 'high', DATE_ADD(CURDATE(), INTERVAL 7 DAY), NOW()),
('msa3', '호치민 투어 예약', 'todo', 1, 'medium', DATE_ADD(CURDATE(), INTERVAL 14 DAY), NOW()),
('msa3', '현지 SIM 카드 구매', 'todo', 2, 'low', DATE_ADD(CURDATE(), INTERVAL 20 DAY), NOW()),
('msa3', '여행 짐 싸기', 'inprogress', 0, 'medium', DATE_ADD(CURDATE(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('msa3', '필요한 약 구매하기', 'inprogress', 1, 'high', DATE_ADD(CURDATE(), INTERVAL 12 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
('msa3', '예방접종 완료', 'done', 0, 'high', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 15 DAY)),
('msa3', '여행 경비 계획 세우기', 'done', 1, 'medium', DATE_SUB(CURDATE(), INTERVAL 7 DAY), DATE_SUB(NOW(), INTERVAL 12 DAY)),

-- msa4 유저 칸반
('msa4', '호주 ETA 신청하기', 'todo', 0, 'high', DATE_ADD(CURDATE(), INTERVAL 15 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('msa4', '시드니 오페라하우스 티켓 예매', 'todo', 1, 'high', DATE_ADD(CURDATE(), INTERVAL 20 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('msa4', '국제 운전면허증 발급', 'todo', 2, 'medium', DATE_ADD(CURDATE(), INTERVAL 18 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('msa4', '여행 사진 SD 카드 준비', 'inprogress', 0, 'low', DATE_ADD(CURDATE(), INTERVAL 22 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('msa4', '현지 날씨 확인하기', 'inprogress', 1, 'low', DATE_ADD(CURDATE(), INTERVAL 25 DAY), DATE_SUB(NOW(), INTERVAL 4 DAY)),
('msa4', '항공권 발권 완료', 'done', 0, 'high', DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 20 DAY)),
('msa4', '숙소 위치 확인', 'done', 1, 'medium', DATE_SUB(CURDATE(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY)),

-- msa5 유저 칸반
('msa5', '스페인 레알 마드리드 경기 티켓', 'todo', 0, 'high', DATE_ADD(CURDATE(), INTERVAL 30 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('msa5', '바르셀로나 사그라다 파밀리아 예약', 'todo', 1, 'high', DATE_ADD(CURDATE(), INTERVAL 32 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('msa5', '마드리드 교통권 구매', 'todo', 2, 'medium', DATE_ADD(CURDATE(), INTERVAL 35 DAY), DATE_SUB(NOW(), INTERVAL 5 DAY)),
('msa5', '플라멩코 공연 예약', 'inprogress', 0, 'medium', DATE_ADD(CURDATE(), INTERVAL 33 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY)),
('msa5', '현지 음식점 리스트 작성', 'inprogress', 1, 'low', DATE_ADD(CURDATE(), INTERVAL 36 DAY), DATE_SUB(NOW(), INTERVAL 6 DAY)),
('msa5', '여행 경로 계획 완료', 'done', 0, 'high', DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_SUB(NOW(), INTERVAL 25 DAY)),
('msa5', '쇼핑 리스트 정리', 'done', 1, 'low', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(NOW(), INTERVAL 30 DAY)),

-- msa6 유저 칸반
('msa6', '태국 방콕 호텔 예약', 'todo', 0, 'high', DATE_ADD(CURDATE(), INTERVAL 25 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),
('msa6', '푸켓 투어 예약하기', 'todo', 1, 'medium', DATE_ADD(CURDATE(), INTERVAL 28 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),
('msa6', '태국 전통 마사지 예약', 'todo', 2, 'low', DATE_ADD(CURDATE(), INTERVAL 30 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),
('msa6', '현지 투어 가이드 찾기', 'inprogress', 0, 'medium', DATE_ADD(CURDATE(), INTERVAL 27 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY)),
('msa6', '여행 준비물 구매하기', 'inprogress', 1, 'medium', DATE_ADD(CURDATE(), INTERVAL 29 DAY), DATE_SUB(NOW(), INTERVAL 8 DAY)),
('msa6', '비자 발급 완료', 'done', 0, 'high', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(NOW(), INTERVAL 40 DAY)),
('msa6', '항공권 예약 완료', 'done', 1, 'high', DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(NOW(), INTERVAL 45 DAY));

-- =====================================================================================
-- 12. Q&A 게시판 데이터 삽입
-- =====================================================================================

INSERT INTO `Answer` (`qnaTitle`, `qnaDescription`, `qnaDateWritten`, `qnaRef`, `qnaDepth`, `qnaStep`, `userId`) VALUES
-- 질문 1
('유럽 여행 예산은 얼마나 잡아야 하나요?', '유럽 3국 2주 여행을 계획 중인데, 항공료 제외하고 1인당 예산을 얼마나 잡아야 할까요?', DATE_SUB(NOW(), INTERVAL 10 DAY), 1, 0, 0, 'msa1'),
-- 질문 1에 대한 답변
('RE: 유럽 여행 예산은 얼마나 잡아야 하나요?', '저는 4국 2주 여행에 1인당 약 300만원 정도 사용했습니다. 숙소와 식사 비용이 생각보다 많이 들었어요.', DATE_SUB(NOW(), INTERVAL 9 DAY), 1, 1, 0, 'msa2'),

-- 질문 2
('일본 여행 시 와이파이 어떻게 하나요?', '일본 여행 시 포켓 와이파이를 대여하는게 좋을까요, 아니면 유심을 구매하는게 나을까요?', DATE_SUB(NOW(), INTERVAL 8 DAY), 3, 0, 0, 'msa3'),
-- 질문 2에 대한 답변
('RE: 일본 여행 시 와이파이 어떻게 하나요?', '저는 포켓 와이파이 대여했는데 정말 편했어요. 여러 명이 사용할 수 있어서 좋았습니다.', DATE_SUB(NOW(), INTERVAL 7 DAY), 3, 1, 0, 'msa4'),

-- 질문 3
('동남아 여행 필수 준비물이 뭔가요?', '처음으로 동남아 여행을 가는데, 꼭 챙겨야 할 준비물이 있을까요?', DATE_SUB(NOW(), INTERVAL 6 DAY), 5, 0, 0, 'msa5'),
-- 질문 3에 대한 답변
('RE: 동남아 여행 필수 준비물이 뭔가요?', '모기약, 선크림, 우산은 필수입니다! 현지에서도 구매 가능하지만 미리 준비하는게 좋아요.', DATE_SUB(NOW(), INTERVAL 5 DAY), 5, 1, 0, 'msa6'),

-- 질문 4
('뉴욕 메트로 카드 어디서 사나요?', '뉴욕 지하철 이용을 위한 메트로 카드는 어디서 구매하는게 좋을까요?', DATE_SUB(NOW(), INTERVAL 4 DAY), 7, 0, 0, 'msa1'),
-- 질문 4에 대한 답변
('RE: 뉴욕 메트로 카드 어디서 사나요?', '공항이나 지하철역 매표소에서 구매하실 수 있습니다. 7일 무제한권 추천드려요!', DATE_SUB(NOW(), INTERVAL 3 DAY), 7, 1, 0, 'msa2'),

-- 질문 5
('호텔 vs 에어비앤비 어떤게 나을까요?', '여행 시 숙박을 호텔로 할지 에어비앤비로 할지 고민중입니다. 추천 부탁드립니다.', DATE_SUB(NOW(), INTERVAL 2 DAY), 9, 0, 0, 'msa3'),
-- 질문 5에 대한 답변
('RE: 호텔 vs 에어비앤비 어떤게 나을까요?', '단기 여행은 호텔, 장기 여행은 에어비앤비가 좋습니다. 주방 사용이 필요하면 에어비앤비 추천!', DATE_SUB(NOW(), INTERVAL 1 DAY), 9, 1, 0, 'msa4'),

-- 질문 6
('겨울 유럽 여행 복장은 어떻게?', '12월에 유럽 여행을 가는데, 옷을 어떻게 준비해야 할까요?', DATE_SUB(NOW(), INTERVAL 12 HOUR), 11, 0, 0, 'msa5'),

-- 질문 7
('환전은 어디서 하는게 좋을까요?', '해외 여행 시 환전을 국내 은행에서 할지, 현지에서 할지 고민됩니다. 어디가 환율이 더 좋을까요?', DATE_SUB(NOW(), INTERVAL 15 DAY), 12, 0, 0, 'msa6'),

-- 질문 8
('비행기 좌석은 어디가 제일 좋나요?', '장거리 비행인데 창가석과 복도석 중 어느 것이 더 편할까요?', DATE_SUB(NOW(), INTERVAL 20 DAY), 13, 0, 0, 'msa1'),

-- 질문 9
('여행자 보험 꼭 가입해야 하나요?', '단기 여행인데 여행자 보험이 정말 필요할까요? 추천하는 보험이 있나요?', DATE_SUB(NOW(), INTERVAL 25 DAY), 14, 0, 0, 'msa2'),

-- 질문 10
('해외에서 분실물 발생 시 어떻게 하나요?', '여행 중 여권이나 지갑을 잃어버리면 어떻게 대처해야 하나요?', DATE_SUB(NOW(), INTERVAL 30 DAY), 15, 0, 0, 'msa3'),

-- 질문 11
('패키지 여행 vs 자유여행 뭐가 나을까요?', '처음 해외여행 가는데 패키지와 자유여행 중 어떤 걸 선택하는게 좋을까요?', DATE_SUB(NOW(), INTERVAL 35 DAY), 16, 0, 0, 'msa4');

-- =====================================================================================
-- 13. QnAref 업데이트
-- =====================================================================================

SET SQL_SAFE_UPDATES = 0;
UPDATE `Answer` SET qnaRef = qnaNumber WHERE qnaDepth = 0;
SET SQL_SAFE_UPDATES = 1;

-- =====================================================================================
-- End of Database Initialization Script
-- =====================================================================================
