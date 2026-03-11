//package com.example.demo.mapper;
//
//import org.apache.ibatis.annotations.Mapper;
//import org.apache.ibatis.annotations.Select;
//
//import com.example.demo.Domain.User;
//
//@Mapper
//public interface UserMapper {
//
//	@Select("SELECT * FROM users WHERE user_id = #{user_id}")
//	User findByUserId(String user_id);
//}

package com.example.demo.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.example.demo.Domain.User;

//@Mapper
//public interface UserMapper {
//
//	@Select("SELECT * FROM users WHERE user_id = #{user_id}")
//	User findByUserId(String user_id);
//
//	@Insert("INSERT INTO users(user_id, user_pw) VALUES(#{user_id}, #{user_pw})")
//	void save(User user);
//}

@Mapper
public interface UserMapper {

	// 회원가입 (user_name 포함)
	@Insert("INSERT INTO users(user_id, user_pw, user_name) VALUES(#{user_id}, #{user_pw}, #{user_name})")
	void save(User user);

	// 로그인
	@Select("SELECT user_id, user_pw, user_name FROM users WHERE user_id = #{user_id}")
	User findById(String user_id);

}
