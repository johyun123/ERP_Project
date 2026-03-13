package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.Domain.User;

@Mapper
public interface UserMapper {
	void save(User user);

	User findById(String user_id);

//	// 회원가입 (user_name 포함)
//	@Insert("INSERT INTO users(user_id, user_pw, user_name) VALUES(#{user_id}, #{user_pw}, #{user_name})")
//	void save(User user);
//
//	// 로그인
//	@Select("SELECT user_id, user_pw, user_name FROM users WHERE user_id = #{user_id}")
//	User findById(String user_id);

}
