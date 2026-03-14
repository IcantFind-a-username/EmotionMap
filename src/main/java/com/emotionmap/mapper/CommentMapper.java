package com.emotionmap.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.emotionmap.entity.Comment;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommentMapper extends BaseMapper<Comment> {
}
