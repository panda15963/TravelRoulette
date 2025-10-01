package com.travelroulette.dto.kanban;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class kanBanDto {
    private Integer taskId;
    private String taskDescription;
    private String taskStatus;
    private LocalDateTime dueDate;
    private String priority;
    private LocalDateTime createDate;
    private String userId;
}
