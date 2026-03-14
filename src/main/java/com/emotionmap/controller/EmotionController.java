package com.emotionmap.controller;

import com.emotionmap.dto.ApiResponse;
import com.emotionmap.dto.EmotionRequest;
import com.emotionmap.exception.BusinessException;
import com.emotionmap.service.EmotionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/emotions")
@RequiredArgsConstructor
public class EmotionController {

    private final EmotionService emotionService;

    private Long getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof Long) {
            return (Long) auth.getPrincipal();
        }
        return null;
    }

    @PostMapping
    public ApiResponse<?> submitEmotion(@Valid @RequestBody EmotionRequest request) {
        return emotionService.submitEmotion(request, getCurrentUserId());
    }

    @GetMapping("/nearby")
    public ApiResponse<?> getNearby(@RequestParam double lat,
                                    @RequestParam double lng,
                                    @RequestParam(defaultValue = "1000") double radius) {
        return emotionService.getNearby(lat, lng, radius);
    }

    @GetMapping("/heatmap")
    public ApiResponse<?> getHeatmap(@RequestParam double lat,
                                     @RequestParam double lng,
                                     @RequestParam(defaultValue = "1000") double radius) {
        return emotionService.getHeatmap(lat, lng, radius);
    }

    @GetMapping("/trends")
    public ApiResponse<?> getTrends(@RequestParam double lat,
                                    @RequestParam double lng,
                                    @RequestParam(defaultValue = "7") int days) {
        return emotionService.getTrends(lat, lng, days);
    }

    @GetMapping("/my")
    public ApiResponse<?> getMyEmotions() {
        Long userId = getCurrentUserId();
        if (userId == null) {
            throw new BusinessException(401, "Authentication required");
        }
        return emotionService.getUserEmotions(userId);
    }
}
