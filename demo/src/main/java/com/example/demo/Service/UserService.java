//package com.example.demo.Service;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.crypto.bcrypt.BCrypt;
//import org.springframework.stereotype.Service;
//
//import com.example.demo.Domain.User;
//import com.example.demo.mapper.UserMapper;
//
//@Service
//public class LoginService {
//
//	@Autowired
//	private UserMapper userMapper;
//
//	// user_id 기준으로 로그인
//	public boolean login(String user_id, String rawPassword) {
//		User user = userMapper.findByUserId(user_id); // Mapper 메서드 이름 변경 반영
//		if (user == null)
//			return false;
//
//		// BCrypt 비밀번호 검증
//		return BCrypt.checkpw(rawPassword, user.getUser_pw()); // 컬럼명에 맞춰 user_pw 사용
//	}
//}

//package com.example.demo.Service;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.crypto.bcrypt.BCrypt;
//import org.springframework.stereotype.Service;
//
//import com.example.demo.Domain.User;
//import com.example.demo.mapper.UserMapper;
//
//@Service
//public class UserService {
//
//	@Autowired
//	private UserMapper userMapper;
//
//	// 회원가입
//	public void register(String user_id, String rawPassword) {
//		String hashed = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
//		User user = new User();
//		user.setUser_id(user_id);
//		user.setUser_pw(hashed);
//		userMapper.save(user);
//	}
//
//	// 로그인
//	public boolean login(String user_id, String rawPassword) {
//		User user = userMapper.findById(user_id);
//		if (user == null)
//			return false;
//		return BCrypt.checkpw(rawPassword, user.getUser_pw());
//	}
//}

package com.example.demo.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;

import com.example.demo.Domain.User;
import com.example.demo.mapper.UserMapper;

@Service
public class UserService {

	@Autowired
	private UserMapper userMapper;

	// 회원가입
	public void register(String user_id, String user_pw, String user_name) {
		User user = new User();
		user.setUser_id(user_id);
		// 비밀번호 암호화
		user.setUser_pw(BCrypt.hashpw(user_pw, BCrypt.gensalt()));
		user.setUser_name(user_name); // 이름 필수

		// users 테이블에 저장
		userMapper.save(user);
	}

	// 로그인
	public boolean login(String user_id, String rawPassword) {
		User user = userMapper.findById(user_id);
		if (user == null)
			return false;
		return BCrypt.checkpw(rawPassword, user.getUser_pw());
	}
}