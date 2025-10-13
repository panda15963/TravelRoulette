package com.travelroulette.dao;

import com.travelroulette.dto.kanban.kanBanDto;
import com.travelroulette.utils.ConnectionPoolHelper;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class kanbanDao {

    /* =========================================================
       1) 전체조회
       ========================================================= */
    public List<kanBanDto> findAllByUser(String userId) {
        String sql = """
            SELECT task_id, user_id, task_content, task_status, task_order, due_date, priority, created_at
            FROM kanban_task
            WHERE user_id = ?
            ORDER BY FIELD(task_status,'todo','inprogress','done'), task_order ASC
        """;

        List<kanBanDto> list = new ArrayList<>();
        try (
            Connection conn = ConnectionPoolHelper.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    kanBanDto dto = new kanBanDto();
                    dto.setTaskId(String.valueOf(rs.getInt("task_id"))); // int로 수정
                    dto.setUserId(rs.getString("user_id"));
                    dto.setTaskDescription(rs.getString("task_content"));
                    dto.setTaskStatus(kanBanDto.TaskStatus.from(rs.getString("task_status")));
                    dto.setTaskOrder(rs.getInt("task_order"));
                    Timestamp due = rs.getTimestamp("due_date");
                    dto.setDueDate(due != null ? due.toLocalDateTime() : null);
                    String pri = rs.getString("priority");
                    dto.setPriority(pri != null ? kanBanDto.Priority.from(pri) : null);
                    Timestamp created = rs.getTimestamp("created_at");
                    if (created != null) dto.setCreateDate(created.toLocalDateTime());
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* =========================================================
       2) 카드 추가
       ========================================================= */
    public int insertCard(kanBanDto dto) {
        String nextOrderSql = """
            SELECT IFNULL(MAX(task_order) + 1, 0) AS next_order
            FROM kanban_task
            WHERE user_id = ? AND task_status = ?
        """;
        String insertSql = """
            INSERT INTO kanban_task
            (user_id, task_content, task_status, task_order, due_date, priority)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        int newId = 0;

        try (
            Connection conn = ConnectionPoolHelper.getConnection();
            PreparedStatement ps1 = conn.prepareStatement(nextOrderSql);
        ) {
            conn.setAutoCommit(false);

            // order 계산
            ps1.setString(1, dto.getUserId());
            ps1.setString(2, dto.getTaskStatus().getValue());
            int nextOrder = 0;
            try (ResultSet rs = ps1.executeQuery()) {
                if (rs.next()) nextOrder = rs.getInt("next_order");
            }

            try (PreparedStatement ps2 = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps2.setString(1, dto.getUserId());
                ps2.setString(2, dto.getTaskDescription());
                ps2.setString(3, dto.getTaskStatus().getValue());
                ps2.setInt(4, nextOrder);
                if (dto.getDueDate() != null) {
                    ps2.setTimestamp(5, Timestamp.valueOf(dto.getDueDate()));
                } else {
                    ps2.setNull(5, Types.TIMESTAMP);
                }
                ps2.setString(6, dto.getPriority() != null ? dto.getPriority().getValue() : null);
                ps2.executeUpdate();

                try (ResultSet keys = ps2.getGeneratedKeys()) {
                    if (keys.next()) newId = keys.getInt(1);
                }
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newId;
    }

    /* =========================================================
       3) 카드 내용 수정
       ========================================================= */
    public int updateCardContent(int taskId, String userId, String newContent,
                                 LocalDateTime newDueDate, kanBanDto.Priority newPriority) {
        String sql = """
            UPDATE kanban_task
            SET task_content = ?, due_date = ?, priority = ?
            WHERE task_id = ? AND user_id = ?
        """;

        try (
            Connection conn = ConnectionPoolHelper.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, newContent);
            if (newDueDate != null) {
                ps.setTimestamp(2, Timestamp.valueOf(newDueDate));
            } else {
                ps.setNull(2, Types.TIMESTAMP);
            }
            if (newPriority != null) {
                ps.setString(3, newPriority.getValue());
            } else {
                ps.setNull(3, Types.VARCHAR);
            }
            ps.setInt(4, taskId);
            ps.setString(5, userId);

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /* =========================================================
       4) 카드 삭제
       ========================================================= */
    public int deleteCard(int taskId, String userId) {
        String selectSql = """
            SELECT task_status, task_order
            FROM kanban_task
            WHERE task_id = ? AND user_id = ?
            FOR UPDATE
        """;
        String shiftSql = """
            UPDATE kanban_task
            SET task_order = task_order - 1
            WHERE user_id = ? AND task_status = ? AND task_order > ?
        """;
        String deleteSql = "DELETE FROM kanban_task WHERE task_id = ? AND user_id = ?";

        int deleted = 0;

        try (Connection conn = ConnectionPoolHelper.getConnection()) {
            conn.setAutoCommit(false);

            String status;
            int oldOrder;

            try (PreparedStatement ps1 = conn.prepareStatement(selectSql)) {
                ps1.setInt(1, taskId);
                ps1.setString(2, userId);
                try (ResultSet rs = ps1.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return 0;
                    }
                    status = rs.getString("task_status");
                    oldOrder = rs.getInt("task_order");
                }
            }

            try (PreparedStatement ps2 = conn.prepareStatement(deleteSql)) {
                ps2.setInt(1, taskId);
                ps2.setString(2, userId);
                deleted = ps2.executeUpdate();
                if (deleted == 0) {
                    conn.rollback();
                    return 0;
                }
            }

            try (PreparedStatement ps3 = conn.prepareStatement(shiftSql)) {
                ps3.setString(1, userId);
                ps3.setString(2, status);
                ps3.setInt(3, oldOrder);
                ps3.executeUpdate();
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return deleted;
    }

    /* =========================================================
       5) 카드 이동 (드래그)
       ========================================================= */
    public void moveCard(int taskId, String userId, kanBanDto.TaskStatus targetStatus, int targetOrder) {
        String lockSql = """
            SELECT task_status, task_order
            FROM kanban_task
            WHERE task_id = ? AND user_id = ?
            FOR UPDATE
        """;
        String countTargetSql = """
            SELECT COUNT(*) AS cnt
            FROM kanban_task
            WHERE user_id = ? AND task_status = ?
        """;
        String shiftDownSql = """
            UPDATE kanban_task
            SET task_order = task_order - 1
            WHERE user_id = ? AND task_status = ? AND task_order > ? AND task_order <= ?
        """;
        String shiftUpSql = """
            UPDATE kanban_task
            SET task_order = task_order + 1
            WHERE user_id = ? AND task_status = ? AND task_order >= ? AND task_order < ?
        """;
        String pullSourceSql = """
            UPDATE kanban_task
            SET task_order = task_order - 1
            WHERE user_id = ? AND task_status = ? AND task_order > ?
        """;
        String pushTargetSql = """
            UPDATE kanban_task
            SET task_order = task_order + 1
            WHERE user_id = ? AND task_status = ? AND task_order >= ?
        """;
        String updateSelfSql = """
            UPDATE kanban_task
            SET task_status = ?, task_order = ?
            WHERE task_id = ? AND user_id = ?
        """;

        try (Connection conn = ConnectionPoolHelper.getConnection()) {
            conn.setAutoCommit(false);

            // 1️⃣ 현재 카드 상태/순서
            String srcStatusStr;
            int srcOrder;

            try (PreparedStatement ps = conn.prepareStatement(lockSql)) {
                ps.setInt(1, taskId);
                ps.setString(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) throw new SQLException("Task not found or no permission");
                    srcStatusStr = rs.getString("task_status");
                    srcOrder = rs.getInt("task_order");
                }
            }

            kanBanDto.TaskStatus srcStatus = kanBanDto.TaskStatus.from(srcStatusStr);

            // 2️⃣ 타깃 열 카드 개수
            int targetCount;
            try (PreparedStatement ps = conn.prepareStatement(countTargetSql)) {
                ps.setString(1, userId);
                ps.setString(2, targetStatus.getValue());
                try (ResultSet rs = ps.executeQuery()) {
                    rs.next();
                    targetCount = rs.getInt("cnt");
                }
            }

            if (srcStatus == targetStatus) targetCount--;
            if (targetCount < 0) targetCount = 0;
            if (targetOrder < 0) targetOrder = 0;
            if (targetOrder > targetCount) targetOrder = targetCount;

            boolean sameColumn = (srcStatus == targetStatus);

            if (sameColumn) {
                if (targetOrder != srcOrder) {
                    if (targetOrder > srcOrder) {
                        try (PreparedStatement ps = conn.prepareStatement(shiftDownSql)) {
                            ps.setString(1, userId);
                            ps.setString(2, targetStatus.getValue());
                            ps.setInt(3, srcOrder);
                            ps.setInt(4, targetOrder);
                            ps.executeUpdate();
                        }
                    } else {
                        try (PreparedStatement ps = conn.prepareStatement(shiftUpSql)) {
                            ps.setString(1, userId);
                            ps.setString(2, targetStatus.getValue());
                            ps.setInt(3, targetOrder);
                            ps.setInt(4, srcOrder);
                            ps.executeUpdate();
                        }
                    }

                    try (PreparedStatement ps = conn.prepareStatement(updateSelfSql)) {
                        ps.setString(1, targetStatus.getValue());
                        ps.setInt(2, targetOrder);
                        ps.setInt(3, taskId);
                        ps.setString(4, userId);
                        ps.executeUpdate();
                    }
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(pullSourceSql)) {
                    ps.setString(1, userId);
                    ps.setString(2, srcStatus.getValue());
                    ps.setInt(3, srcOrder);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(pushTargetSql)) {
                    ps.setString(1, userId);
                    ps.setString(2, targetStatus.getValue());
                    ps.setInt(3, targetOrder);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(updateSelfSql)) {
                    ps.setString(1, targetStatus.getValue());
                    ps.setInt(2, targetOrder);
                    ps.setInt(3, taskId);
                    ps.setString(4, userId);
                    ps.executeUpdate();
                }
            }

            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
