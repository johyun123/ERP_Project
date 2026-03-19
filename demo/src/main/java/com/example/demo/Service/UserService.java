package com.example.demo.Service;

import java.util.List;

import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.Domain.Employees;
import com.example.demo.Domain.User;
import com.example.demo.mapper.UserMapper;

@Service
public class UserService {
	private final UserMapper userMapper;
	private final PasswordEncoder passwordEncoder;
	private final HRMService hrmService;

	UserService(UserMapper userMapper, PasswordEncoder passwordEncoder, HRMService hrmService) {
		this.userMapper = userMapper;
		this.passwordEncoder = passwordEncoder;
		this.hrmService = hrmService;
	}

	// 전체 사용자 조회
	public List<User> getAllUsers() {
		return userMapper.findAll();
	}

	// emp_num 기준으로 사용자 조회
	public User getUserById(String emp_num) {
		// 1) employees에서 emp_num으로 직원 조회
		Employees emp = hrmService.getEmployeeById(emp_num);
		if (emp == null)
			return null;
		// 2) users 테이블에서 직원 id 기준 조회
		return userMapper.findById(emp.getId()); // 이미 mapper에 findById 있음
	}

	// 활성화 비활성화 토글
	public void toggleUserActive(Long id) {

		User users = userMapper.findById(id);
		if (users != null) {
			int current = users.getIs_active(); // 1=활성, 0=비활성
			;
			int newStatus = (current == 1 ? 0 : 1);

			System.out.println("현재값 = " + current);
			System.out.println("변경값 = " + newStatus);

			userMapper.updateUserActive(id, newStatus); // userMapper에 update(User user) 필요
		} else {
			System.out.println("❌ 유저 못 찾음");
		}
	}

	// 로그인
	public boolean login(String emp_num_or_userId, String rawPassword) {
		// 1️. 새 방식: emp_num → 직원 → Users.id
		Employees emp = hrmService.getEmployeeById(emp_num_or_userId);
		User users = null;

		if (emp != null) {
			users = userMapper.findById(emp.getId());
		} else {
			// 2️. 기존 방식: user_id 기준
			users = userMapper.findByEmpNum(emp_num_or_userId); // 또는 findByUserId
		}

		if (users == null)
			return false;

		if (users.getIs_active() != 1) {
			return false;
		}

		return BCrypt.checkpw(rawPassword, users.getUser_pw());
	}

	// 🔹 UserService.java
	/**
	 * 로그인 시도 후 User 객체 반환 emp_num 또는 user_id로 로그인 가능
	 */
	public User loginAndGetUser(String emp_num_or_userId, String rawPassword) {
		// 1️⃣ 직원 조회(emp_num)
		Employees emp = hrmService.getEmployeeById(emp_num_or_userId);
		User user = null;

		if (emp != null) {
			// 직원 id로 Users 조회
			user = userMapper.findById(emp.getId());
		} else {
			// emp_num이 아닌 경우(user_id)로 조회
			user = userMapper.findByEmpNum(emp_num_or_userId); // 또는 findByUserId
		}

		// 유저 없음
		if (user == null) {
			return null;
		}
		// 비활성화 계정 차단
		if (user.getIs_active() != 1) {
			throw new RuntimeException("비활성화된 계정입니다.");
		}

		// 2️⃣ User가 존재하고 비밀번호 일치하면 반환, 아니면 null
		if (user != null && BCrypt.checkpw(rawPassword, user.getUser_pw())) {
			return user;
		}

		return null;
	}

	// 🔥 직원 기반 계정 생성
	public void registerByEmployee(String emp_num, String user_pw) {

		// 직원 조회
		Employees emp = hrmService.getEmployeeById(emp_num);
		if (emp == null) {
			throw new RuntimeException("존재하지 않는 직원입니다.");
		}

		// 중복 체크
		if (userMapper.findById(emp.getId()) != null) {
			throw new RuntimeException("이미 계정 있음");
		}

		String encodedPw = passwordEncoder.encode(user_pw);

		User users = new User();
//		users.setEmp_num(emp_num); // employees에서 객체만 참조 users에는 저장 안됨
		users.setUser_pw(encodedPw);
		users.setIs_active(1);

		userMapper.save(users);
	}

	// 중복 체크
	public boolean existsByUserId(String emp_num) {
		// ✅ 수정: emp_num → employees → id → users
		Employees emp = hrmService.getEmployeeById(emp_num);
		if (emp == null)
			return false;

		return userMapper.findById(emp.getId()) != null;
	}

}