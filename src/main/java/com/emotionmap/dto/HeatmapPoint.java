package com.emotionmap.dto;

import lombok.Data;

@Data
public class HeatmapPoint {

    private Double latitude;
    private Double longitude;
    private Double weight;
    private String dominantEmotion;
}
