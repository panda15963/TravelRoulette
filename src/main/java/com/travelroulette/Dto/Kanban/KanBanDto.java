package com.travelroulette.Dto.Kanban;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KanBanDto {
    private Integer taskId;
    private String taskDescription;
    private TaskStatus taskStatus;
    private LocalDateTime dueDate;
    private Integer taskOrder;
    private Priority priority;
    @Builder.Default
    private LocalDateTime createDate = LocalDateTime.now();
    private String userId;

    // ✅ TaskStatus Enum (DB, JS 통일)
    public enum TaskStatus {
        TODO("todo"),
        IN_PROGRESS("inprogress"),
        DONE("done");

        private final String value;
        TaskStatus(String value) { this.value = value; }
        public String getValue() { return value; }
        public static TaskStatus from(String value) {
            if (value == null) return TODO;
            switch (value.toLowerCase()) {
                case "inprogress": return IN_PROGRESS;
                case "done": return DONE;
                default: return TODO;
            }
        }
    }

    // ✅ Priority Enum (DB, JS, CSS 통일)
    public enum Priority {
        HIGH("high"),
        MEDIUM("medium"),
        LOW("low");

        private final String value;
        Priority(String value) { this.value = value; }
        public String getValue() { return value; }
        public static Priority from(String value) {
            if (value == null) return MEDIUM;
            switch (value.toLowerCase()) {
                case "high": return HIGH;
                case "low": return LOW;
                default: return MEDIUM;
            }
        }
    }
}
