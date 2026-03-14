package com.emotionmap.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.emotionmap.dto.EmotionTrend;
import com.emotionmap.dto.HeatmapPoint;
import com.emotionmap.entity.EmotionRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface EmotionRecordMapper extends BaseMapper<EmotionRecord> {

    @Select("SELECT * FROM emotion_records " +
            "WHERE ST_Distance_Sphere(POINT(longitude, latitude), POINT(#{lng}, #{lat})) < #{radius} " +
            "ORDER BY created_at DESC LIMIT 200")
    List<EmotionRecord> findNearby(@Param("lat") double lat,
                                   @Param("lng") double lng,
                                   @Param("radius") double radius);

    @Select("SELECT ROUND(latitude, 4) as latitude, ROUND(longitude, 4) as longitude, COUNT(*) as weight, " +
            "(SELECT e2.emotion_type FROM emotion_records e2 " +
            " WHERE ROUND(e2.latitude,4)=ROUND(e.latitude,4) AND ROUND(e2.longitude,4)=ROUND(e.longitude,4) " +
            " GROUP BY e2.emotion_type ORDER BY COUNT(*) DESC LIMIT 1) as dominant_emotion " +
            "FROM emotion_records e " +
            "WHERE ST_Distance_Sphere(POINT(longitude, latitude), POINT(#{lng}, #{lat})) < #{radius} " +
            "GROUP BY ROUND(latitude, 4), ROUND(longitude, 4)")
    List<HeatmapPoint> getHeatmapData(@Param("lat") double lat,
                                      @Param("lng") double lng,
                                      @Param("radius") double radius);

    @Select("SELECT DATE(created_at) as date, " +
            "SUM(CASE WHEN emotion_type='HAPPY' THEN 1 ELSE 0 END) as happy_count, " +
            "SUM(CASE WHEN emotion_type='SAD' THEN 1 ELSE 0 END) as sad_count, " +
            "SUM(CASE WHEN emotion_type='ANGRY' THEN 1 ELSE 0 END) as angry_count, " +
            "SUM(CASE WHEN emotion_type='ANXIOUS' THEN 1 ELSE 0 END) as anxious_count, " +
            "SUM(CASE WHEN emotion_type='CALM' THEN 1 ELSE 0 END) as calm_count " +
            "FROM emotion_records " +
            "WHERE ST_Distance_Sphere(POINT(longitude, latitude), POINT(#{lng}, #{lat})) < #{radius} " +
            "AND created_at >= DATE_SUB(NOW(), INTERVAL #{days} DAY) " +
            "GROUP BY DATE(created_at) ORDER BY date")
    List<EmotionTrend> getTrends(@Param("lat") double lat,
                                 @Param("lng") double lng,
                                 @Param("radius") double radius,
                                 @Param("days") int days);

    @Select("SELECT * FROM emotion_records WHERE user_id = #{userId} ORDER BY created_at DESC")
    List<EmotionRecord> findByUserId(@Param("userId") Long userId);
}
