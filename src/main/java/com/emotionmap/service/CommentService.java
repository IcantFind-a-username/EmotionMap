package com.emotionmap.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.emotionmap.dto.ApiResponse;
import com.emotionmap.dto.CommentRequest;
import com.emotionmap.entity.Comment;
import com.emotionmap.exception.BusinessException;
import com.emotionmap.mapper.CommentMapper;
import com.emotionmap.mapper.EmotionRecordMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentMapper commentMapper;
    private final EmotionRecordMapper emotionRecordMapper;

    public ApiResponse<Comment> addComment(Long emotionRecordId, CommentRequest req, Long userId) {
        if (emotionRecordMapper.selectById(emotionRecordId) == null) {
            throw new BusinessException(404, "Emotion record not found");
        }

        Comment comment = new Comment();
        comment.setEmotionRecordId(emotionRecordId);
        comment.setUserId(userId);
        comment.setContent(req.getContent());
        commentMapper.insert(comment);

        return ApiResponse.success(comment);
    }

    public ApiResponse<List<Comment>> getComments(Long emotionRecordId) {
        List<Comment> comments = commentMapper.selectList(
                new QueryWrapper<Comment>()
                        .eq("emotion_record_id", emotionRecordId)
                        .orderByDesc("created_at"));
        return ApiResponse.success(comments);
    }
}
