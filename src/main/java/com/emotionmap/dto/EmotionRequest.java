package com.emotionmap.dto;

import com.emotionmap.enums.EmotionType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class EmotionRequest {

    @NotNull
    private EmotionType emotionType;

    @NotNull
    private Double latitude;

    @NotNull
    private Double longitude;

    @Size(max = 255)
    private String note;
}
