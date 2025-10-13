package com.travelroulette.Dto.Post;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PostDto {
    private Integer postNumber;
    private String postTitle;
    private String postDescription;
    private LocalDateTime postDateWritten;
    private Integer boardNumber;
    private String userId;
}
