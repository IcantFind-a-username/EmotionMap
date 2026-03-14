package com.emotionmap.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.emotionmap.enums.EmotionType;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("emotion_records")
public class EmotionRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private EmotionType emotionType;

    private Double latitude;

    private Double longitude;

    private String note;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
