package com.emotionmap.controller;

import com.emotionmap.dto.ApiResponse;
import com.emotionmap.dto.CommentRequest;
import com.emotionmap.exception.BusinessException;
import com.emotionmap.service.CommentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/emotions")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    private Long getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && auth.getPrincipal() instanceof Long) {
            return (Long) auth.getPrincipal();
        }
        throw new BusinessException(401, "Authentication required");
    }

    @PostMapping("/{id}/comments")
    public ApiResponse<?> addComment(@PathVariable Long id,
                                     @Valid @RequestBody CommentRequest request) {
        return commentService.addComment(id, request, getCurrentUserId());
    }

    @GetMapping("/{id}/comments")
    public ApiResponse<?> getComments(@PathVariable Long id) {
        return commentService.getComments(id);
    }
}
