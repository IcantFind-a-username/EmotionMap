package com.emotionmap.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.emotionmap.dto.ApiResponse;
import com.emotionmap.dto.LoginRequest;
import com.emotionmap.dto.RegisterRequest;
import com.emotionmap.entity.User;
import com.emotionmap.exception.BusinessException;
import com.emotionmap.mapper.UserMapper;
import com.emotionmap.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public ApiResponse<?> register(RegisterRequest req) {
        User existing = userMapper.selectOne(
                new QueryWrapper<User>().eq("username", req.getUsername()));
        if (existing != null) {
            throw new BusinessException(400, "Username already taken");
        }

        User user = new User();
        user.setUsername(req.getUsername());
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        userMapper.insert(user);

        return ApiResponse.success();
    }

    public ApiResponse<?> login(LoginRequest req) {
        User user = userMapper.selectOne(
                new QueryWrapper<User>().eq("username", req.getUsername()));

        if (user == null || !passwordEncoder.matches(req.getPassword(), user.getPassword())) {
            throw new BusinessException(401, "Invalid credentials");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        return ApiResponse.success(Map.of(
                "token", token,
                "userId", user.getId(),
                "username", user.getUsername()
        ));
    }
}
