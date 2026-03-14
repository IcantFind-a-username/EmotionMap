package com.emotionmap.dto;

import lombok.Data;

@Data
public class EmotionTrend {

    private String date;
    private Integer happyCount;
    private Integer sadCount;
    private Integer angryCount;
    private Integer anxiousCount;
    private Integer calmCount;
}
