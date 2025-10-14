package com.travelroulette.Dao;

import com.travelroulette.Dto.Kanban.KanBanDto;
import com.travelroulette.Dto.Kanban.KanBanDto.TaskStatus;
import com.travelroulette.Dto.Kanban.KanBanDto.Priority;
import com.travelroulette.Utils.ConnectionPoolHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.time.LocalDateTime;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * KanbanDao — Kanban 보드 CRUD + 드래그(정렬/이동) DAO
 * mapRow() 없이 직접 매핑하는 버전
 */
public class KanbanDao {
    private static final Logger logger = LoggerFactory.getLogger(KanbanDao.class);

    /**
     * 유저별 Kanban 전체조회
     * @param userId 로그인한 유저ID
     * @return 해당 유저의 카드 목록
     */
    public List<KanBanDto> KanbanList(String userId) {
        List<KanBanDto> list = new ArrayList<>();

        // SQL: 상태(todo→inprogress→done) 순, 같은 상태 내에서는 taskOrder 기준 정렬
        String sql =
            "SELECT taskId, userId, taskDescription, taskStatus, taskOrder, priority, dueDate, createDate " +
            "FROM Kanban WHERE userId=? " +
            "ORDER BY CASE taskStatus " +
            "WHEN 'todo' THEN 1 WHEN 'inprogress' THEN 2 WHEN 'done' THEN 3 END, taskOrder ASC";

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId); // 유저ID 조건 바인딩
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    // 한 행(카드)마다 DTO로 직접 매핑
                    KanBanDto dto = new KanBanDto();
                    dto.setTaskId(rs.getInt("taskId"));
                    dto.setUserId(rs.getString("userId"));
                    dto.setTaskDescription(rs.getString("taskDescription"));
                    dto.setTaskStatus(TaskStatus.from(rs.getString("taskStatus")));
                    dto.setTaskOrder(rs.getInt("taskOrder"));
                    dto.setPriority(Priority.from(rs.getString("priority")));

                    Timestamp due = rs.getTimestamp("dueDate");
                    Timestamp created = rs.getTimestamp("createDate");

                    if (due != null) dto.setDueDate(due.toLocalDateTime());
                    if (created != null) dto.setCreateDate(created.toLocalDateTime());

                    list.add(dto); // 리스트에 추가
                }
            }

        } catch (SQLException e) {
            logger.error("❌ KanbanList 조회 중 오류 발생 - userId={}", userId, e);
        }

        return list;
    }
    
    /**
     * 카드 추가(맨 아래로 자동 부착)
     * - insertAtOrder를 사용하지 않는 간단 버전
     * @return 생성된 taskId (실패시 null)
     */
    public Integer createCard(String userId,
                              String taskDescription,
                              TaskStatus status,
                              Priority priority,
                              LocalDateTime dueDate) {

        final String findNextOrder =
                "SELECT COALESCE(MAX(taskOrder)+1, 0) FROM Kanban WHERE userId=? AND taskStatus=?";
        final String insertSql =
                "INSERT INTO Kanban (userId, taskDescription, taskStatus, taskOrder, priority, dueDate) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionPoolHelper.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1) 해당 컬럼의 마지막 인덱스 계산
                int finalOrder = 0;
                try (PreparedStatement ps = conn.prepareStatement(findNextOrder)) {
                    ps.setString(1, userId);
                    ps.setString(2, status.getValue());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) finalOrder = rs.getInt(1);
                    }
                }

                // 2) INSERT
                Integer newId = null;
                try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, userId);
                    ps.setString(2, taskDescription);
                    ps.setString(3, status.getValue());                  // 'todo' | 'inprogress' | 'done'
                    ps.setInt(4, finalOrder);                            // 맨 아래로
                    ps.setString(5, priority == null ? null : priority.getValue()); // 'High' | 'Medium' | 'Low'
                    ps.setTimestamp(6, dueDate == null ? null : Timestamp.valueOf(dueDate));
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) newId = rs.getInt(1);
                    }
                }

                conn.commit();
                return newId;
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            logger.error("❌ createCard error userId={}, status={}", userId, status, e);
            return null;
        }
    }
    
    /**
     * 카드 수정 (상태, 내용, 우선순위)
     * @param userId 로그인한 유저ID
     * @param taskId 수정할 카드 ID
     * @param newStatus 새 상태 (todo / inprogress / done)
     * @param newDescription 새 내용
     * @param newPriority 새 우선순위 (High / Medium / Low)
     * @return 수정된 행 수 (성공 시 1)
     */
    public int updateCard(String userId, Integer taskId,
            TaskStatus newStatus, String newDescription,
            Priority newPriority, LocalDateTime newDueDate) {

	final String sql = """
			UPDATE Kanban
			SET taskStatus=?, taskDescription=?, priority=?, dueDate=?
			WHERE taskId=? AND userId=?
			""";
	
	try (Connection conn = ConnectionPoolHelper.getConnection();
		PreparedStatement ps = conn.prepareStatement(sql)) {
	
		ps.setString(1, newStatus.getValue());
		ps.setString(2, newDescription);
		ps.setString(3, newPriority == null ? null : newPriority.getValue());
		ps.setTimestamp(4, newDueDate == null ? null : Timestamp.valueOf(newDueDate));
		ps.setInt(5, taskId);
		ps.setString(6, userId);
		
		return ps.executeUpdate();
	} catch (SQLException e) {
		e.printStackTrace();
	return 0;
	}
}
    
    /**
     * 같은 컬럼 내에서 드래그 정렬 결과를 그대로 반영
     * @param userId 로그인 유저
     * @param status 대상 컬럼 (TODO/IN_PROGRESS/DONE)
     * @param orderedTaskIds 위→아래 순서대로 정렬된 taskId 리스트
     */
    public void reorderWithinColumn(String userId,
                                    TaskStatus status,
                                    List<Integer> orderedTaskIds) {
        if (orderedTaskIds == null || orderedTaskIds.isEmpty()) return;

        StringBuilder sb = new StringBuilder();
        sb.append("UPDATE Kanban SET taskOrder = CASE taskId ");
        for (int i = 0; i < orderedTaskIds.size(); i++) {
            sb.append("WHEN ").append(orderedTaskIds.get(i)).append(" THEN ").append(i).append(" ");
        }
        sb.append("END WHERE userId=? AND taskStatus=? AND taskId IN (");
        for (int i = 0; i < orderedTaskIds.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(orderedTaskIds.get(i));
        }
        sb.append(")");

        try (Connection conn = ConnectionPoolHelper.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            ps.setString(1, userId);
            ps.setString(2, status.getValue());
            ps.executeUpdate();
        } catch (SQLException e) {
            logger.error("❌ reorderWithinColumn error, userId={}, status={}, ids={}", userId, status, orderedTaskIds, e);
        }
    }
    /**
    * 카드 삭제 (자기 컬럼의 순서 압축 포함)
    * @return 삭제된 행 수(성공 1, 없으면 0)
    */
    		public int deleteCard(String userId, Integer taskId) {
    		    final String qMeta =
    		        "SELECT taskStatus, taskOrder FROM Kanban WHERE taskId=? AND userId=?";
    		    final String qCompact =
    		        "UPDATE Kanban SET taskOrder = taskOrder - 1 " +
    		        "WHERE userId=? AND taskStatus=? AND taskOrder > ?";
    		    final String qDelete =
    		        "DELETE FROM Kanban WHERE taskId=? AND userId=?";

    		    try (Connection conn = ConnectionPoolHelper.getConnection()) {
    		        conn.setAutoCommit(false);
    		        try {
    		            String status;
    		            int order;

    		            // 1) 지울 카드의 상태/순서 조회
    		            try (PreparedStatement ps = conn.prepareStatement(qMeta)) {
    		                ps.setInt(1, taskId);
    		                ps.setString(2, userId);
    		                try (ResultSet rs = ps.executeQuery()) {
    		                    if (!rs.next()) { conn.rollback(); return 0; }
    		                    status = rs.getString(1);
    		                    order = rs.getInt(2);
    		                }
    		            }

    		            // 2) 실제 삭제
    		            int deleted;
    		            try (PreparedStatement ps = conn.prepareStatement(qDelete)) {
    		                ps.setInt(1, taskId);
    		                ps.setString(2, userId);
    		                deleted = ps.executeUpdate();
    		            }

    		            // 3) 같은 컬럼 뒤쪽 카드들 taskOrder 압축
    		            if (deleted > 0) {
    		                try (PreparedStatement ps = conn.prepareStatement(qCompact)) {
    		                    ps.setString(1, userId);
    		                    ps.setString(2, status);
    		                    ps.setInt(3, order);
    		                    ps.executeUpdate();
    		                }
    		            }

    		            conn.commit();
    		            return deleted;
    		        } catch (SQLException ex) {
    		            conn.rollback();
    		            throw ex;
    		        } finally {
    		            conn.setAutoCommit(true);
    		        }
    		    } catch (SQLException e) {
    		        logger.error("❌ deleteCard error - userId={}, taskId={}", userId, taskId, e);
    		        return 0;
    		    }
    		}
    /**
    * 카드 하나를 다른 컬럼으로 이동시키며, 대상 컬럼의 newOrder 위치에 끼워넣기
    * @param userId 로그인 유저
    * @param taskId 이동할 카드 ID
    * @param from 기존 컬럼
    * @param to 대상 컬럼
    * @param newOrder 대상 컬럼에서 들어갈 새 순서(0부터 시작)
    */
   public void moveToAnotherColumn(String userId,
                                   Integer taskId,
                                   TaskStatus from,
                                   TaskStatus to,
                                   int newOrder) {
	   
	   if (from == to) {
	        // 같은 컬럼 이동은 reorderWithinColumn() 사용
	        return;
	    }

       final String qCurrentOrder =
               "SELECT taskOrder FROM Kanban WHERE taskId=? AND userId=? AND taskStatus=?";
       final String qCountInTarget =
               "SELECT COUNT(*) FROM Kanban WHERE userId=? AND taskStatus=?";
       final String qCompactFrom =
               "UPDATE Kanban SET taskOrder = taskOrder - 1 " +
               "WHERE userId=? AND taskStatus=? AND taskOrder > ?";
       final String qShiftTo =
               "UPDATE Kanban SET taskOrder = taskOrder + 1 " +
               "WHERE userId=? AND taskStatus=? AND taskOrder >= ?";
       final String qUpdateSelf =
               "UPDATE Kanban SET taskStatus=?, taskOrder=? WHERE taskId=? AND userId=?";

       try (Connection conn = ConnectionPoolHelper.getConnection()) {
           conn.setAutoCommit(false);
           try {
               // 0) 현재 카드의 기존 order 조회
               int oldOrder;
               try (PreparedStatement ps = conn.prepareStatement(qCurrentOrder)) {
                   ps.setInt(1, taskId);
                   ps.setString(2, userId);
                   ps.setString(3, from.getValue());
                   try (ResultSet rs = ps.executeQuery()) {
                       if (!rs.next()) throw new SQLException("Task not found in source column");
                       oldOrder = rs.getInt(1);
                   }
               }

               // (보호) newOrder 범위 보정
               int targetCount = 0;
               try (PreparedStatement ps = conn.prepareStatement(qCountInTarget)) {
                   ps.setString(1, userId);
                   ps.setString(2, to.getValue());
                   try (ResultSet rs = ps.executeQuery()) {
                       if (rs.next()) targetCount = rs.getInt(1);
                   }
               }
               if (newOrder < 0) newOrder = 0;
               if (newOrder > targetCount) newOrder = targetCount;

               // 1) 원래 컬럼 압축 (빠진 자리 -1씩)
               try (PreparedStatement ps = conn.prepareStatement(qCompactFrom)) {
                   ps.setString(1, userId);
                   ps.setString(2, from.getValue());
                   ps.setInt(3, oldOrder);
                   ps.executeUpdate();
               }

               // 2) 대상 컬럼 newOrder 이상 +1 밀기
               try (PreparedStatement ps = conn.prepareStatement(qShiftTo)) {
                   ps.setString(1, userId);
                   ps.setString(2, to.getValue());
                   ps.setInt(3, newOrder);
                   ps.executeUpdate();
               }

               // 3) 자기 자신 이동 (컬럼+순서 갱신)
               try (PreparedStatement ps = conn.prepareStatement(qUpdateSelf)) {
                   ps.setString(1, to.getValue());
                   ps.setInt(2, newOrder);
                   ps.setInt(3, taskId);
                   ps.setString(4, userId);
                   ps.executeUpdate();
               }

               conn.commit();
           } catch (SQLException ex) {
               conn.rollback();
               throw ex;
           } finally {
               conn.setAutoCommit(true);
           }
       } catch (SQLException e) {
           logger.error("❌ moveToAnotherColumn error, userId={}, taskId={}, from={}, to={}, newOrder={}",
                   userId, taskId, from, to, newOrder, e);
       }
   }
}