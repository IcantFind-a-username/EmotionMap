package com.emotionmap.service;

import com.emotionmap.dto.ApiResponse;
import com.emotionmap.dto.EmotionRequest;
import com.emotionmap.dto.EmotionTrend;
import com.emotionmap.dto.HeatmapPoint;
import com.emotionmap.entity.EmotionRecord;
import com.emotionmap.mapper.EmotionRecordMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class EmotionService {

    private final EmotionRecordMapper emotionRecordMapper;
    private final RedisTemplate<String, Object> redisTemplate;

    public ApiResponse<EmotionRecord> submitEmotion(EmotionRequest req, Long userId) {
        EmotionRecord record = new EmotionRecord();
        record.setUserId(userId);
        record.setEmotionType(req.getEmotionType());
        record.setLatitude(req.getLatitude());
        record.setLongitude(req.getLongitude());
        record.setNote(req.getNote());
        emotionRecordMapper.insert(record);

        // Invalidate heatmap cache
        Set<String> keys = redisTemplate.keys("heatmap:*");
        if (keys != null && !keys.isEmpty()) {
            redisTemplate.delete(keys);
        }

        return ApiResponse.success(record);
    }

    public ApiResponse<List<EmotionRecord>> getNearby(double lat, double lng, double radius) {
        List<EmotionRecord> records = emotionRecordMapper.findNearby(lat, lng, radius);
        return ApiResponse.success(records);
    }

    @SuppressWarnings("unchecked")
    public ApiResponse<List<HeatmapPoint>> getHeatmap(double lat, double lng, double radius) {
        String cacheKey = "heatmap:" + lat + ":" + lng + ":" + radius;

        Object cached = redisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            return ApiResponse.success((List<HeatmapPoint>) cached);
        }

        List<HeatmapPoint> data = emotionRecordMapper.getHeatmapData(lat, lng, radius);
        redisTemplate.opsForValue().set(cacheKey, data, 5, TimeUnit.MINUTES);
        return ApiResponse.success(data);
    }

    public ApiResponse<List<EmotionTrend>> getTrends(double lat, double lng, int days) {
        List<EmotionTrend> trends = emotionRecordMapper.getTrends(lat, lng, 2000, days);
        return ApiResponse.success(trends);
    }

    public ApiResponse<List<EmotionRecord>> getUserEmotions(Long userId) {
        List<EmotionRecord> records = emotionRecordMapper.findByUserId(userId);
        return ApiResponse.success(records);
    }
}
