package com.travelroulette.Service;

import com.travelroulette.Dao.KanbanDAO;
import com.travelroulette.Dto.Kanban.KanBanDto;
import com.travelroulette.Dto.Kanban.KanBanDto.TaskStatus;
import com.travelroulette.Dto.Kanban.KanBanDto.Priority;

import java.time.LocalDateTime;
import java.util.List;

public class KanbanService {

    private final KanbanDAO dao = new KanbanDAO();

    /* ========= 조회 ========= */

    /** 유저별 전체 리스트 조회 */
    public List<KanBanDto> list(String userId) {
        requireUser(userId);
        return dao.KanbanList(userId);
    }

    /* ========= 생성 ========= */

    /** 카드 생성(맨 아래로 부착) */
    public Integer create(String userId,
                          String taskDescription,
                          TaskStatus status,
                          Priority priority,
                          LocalDateTime dueDate) {
        requireUser(userId);
        if (taskDescription == null || taskDescription.isBlank())
            throw new IllegalArgumentException("taskDescription is required");

        if (status == null) status = TaskStatus.TODO;
        if (priority == null) priority = Priority.MEDIUM;

        return dao.createCard(userId, taskDescription, status, priority, dueDate);
    }

    /* ========= 수정 ========= */

    /** 카드 수정: 상태/내용/우선순위 (3가지 필드만) */
    public int update(String userId, int taskId, String newStatus, String newDesc, String newPr, String dueDateStr) {
        LocalDateTime due = null;
        if (dueDateStr != null && !dueDateStr.isBlank()) {
            try {
                due = LocalDateTime.parse(dueDateStr);
            } catch (Exception e) {
                try {
                    due = java.time.Instant.parse(dueDateStr)
                            .atZone(java.time.ZoneId.systemDefault())
                            .toLocalDateTime();
                } catch (Exception ignored) {}
            }
        }
        return dao.updateCard(userId, taskId,
                TaskStatus.from(newStatus),
                newDesc,
                Priority.from(newPr),
                due);
    }

    /* ========= 삭제 ========= */

    /** 카드 삭제(동일 컬럼 순서 압축 포함) */
    public int delete(String userId, int taskId) {
        requireUser(userId);
        if (taskId <= 0) throw new IllegalArgumentException("taskId must be positive");
        return dao.deleteCard(userId, taskId);
    }

    /* ========= 드래그: 같은 컬럼 재정렬 ========= */

    /** 같은 컬럼 내 순서 반영 (위→아래 orderedTaskIds 순서대로 0,1,2...) */
    public void reorder(String userId, TaskStatus status, List<Integer> orderedTaskIds) {
        requireUser(userId);
        if (status == null) throw new IllegalArgumentException("status is required");
        if (orderedTaskIds == null || orderedTaskIds.isEmpty())
            throw new IllegalArgumentException("orderedTaskIds is required");

        dao.reorderWithinColumn(userId, status, orderedTaskIds);
    }

    /* ========= 드래그: 다른 컬럼으로 이동 ========= */

    /** 다른 컬럼으로 이동(대상 컬럼의 newOrder 위치로 삽입) */
    public void move(String userId,
                     int taskId,
                     TaskStatus from,
                     TaskStatus to,
                     int newOrder) {
        requireUser(userId);
        if (taskId <= 0) throw new IllegalArgumentException("taskId must be positive");
        if (from == null || to == null) throw new IllegalArgumentException("from/to required");
        if (from == to) return; // 같은 컬럼 이동은 reorder 사용

        dao.moveToAnotherColumn(userId, taskId, from, to, newOrder);
    }

    /* ========= 문자열 파라미터 편의 오버로드(컨트롤러에서 쓰기 좋게) ========= */

    public Integer create(String userId, String desc, String status, String priority, String dueIso) {
        TaskStatus st = TaskStatus.from(status);
        Priority pr = Priority.from(priority);
        LocalDateTime due = (dueIso == null || dueIso.isBlank()) ? null : LocalDateTime.parse(dueIso);
        return create(userId, desc, st, pr, due);
    }



    public void reorder(String userId, String status, List<Integer> orderedTaskIds) {
        reorder(userId, TaskStatus.from(status), orderedTaskIds);
    }

    public void move(String userId, int taskId, String from, String to, int newOrder) {
        move(userId, taskId, TaskStatus.from(from), TaskStatus.from(to), newOrder);
    }

    /* ========= 내부 공용 ========= */

    private void requireUser(String userId) {
        if (userId == null || userId.isBlank())
            throw new IllegalStateException("userId (session) is required");
    }
}
