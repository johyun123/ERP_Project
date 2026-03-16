package com.example.demo.Service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.Domain.User;
import com.example.demo.mapper.UserMapper;

@Service
public class UserService {
	private final UserMapper userMapper;
	private final PasswordEncoder passwordEncoder;
	
	UserService(UserMapper userMapper,
				PasswordEncoder passwordEncoder){
		this.userMapper = userMapper;
		this.passwordEncoder = passwordEncoder;
	}
	
	// 사용자 추가
	public void register(String user_id, String user_pw, String user_name) {
		String encodedPw = passwordEncoder.encode(user_pw);
		User user = new User();
		user.setUser_id(user_id);
		user.setUser_pw(encodedPw);
		user.setUser_name(user_name);

		// users 테이블에 저장
		userMapper.save(user);
	}

	// UserService.java에 추가
	public boolean authenticate(String userId, String rawPw) {
	    User user = userMapper.findById(userId);
	    if (user == null) return false;
	    return passwordEncoder.matches(rawPw, user.getUser_pw());
	}
}